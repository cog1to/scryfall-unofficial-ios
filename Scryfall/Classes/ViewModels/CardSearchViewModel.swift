//
//  CardSearchViewModel.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class CardSearchViewModel {
    let scryfallService: ScryfallServiceType
    let sceneCoordinator: SceneCoordinatorType
    let cards: Variable<[Card]>
    let hasMore: Variable<Bool>
    let loading: Variable<Bool>
    let searchText = Variable<String>("")
    let sortOrder = Variable<CardSortOrder>(.name)
    let direction = Variable<SortDirection>(.auto)
    
    lazy var random: Observable<Card>  = {
        return self._random.share(replay: 1, scope: .forever)
    }()
    
    private var nextPage: URL?
    private var lastRequest: Disposable?
    private let bag = DisposeBag()
    
    private let _searchText = Variable<String>("")
    private let _sortOrder = Variable<CardSortOrder>(.name)
    private let _direction = Variable<SortDirection>(.auto)
    private let _random = PublishSubject<Card>()
    
    init(service: ScryfallServiceType, coordinator: SceneCoordinatorType) {
        scryfallService = service
        sceneCoordinator = coordinator
        cards = Variable<[Card]>([])
        hasMore = Variable<Bool>(false)
        loading = Variable<Bool>(false)
        
        let searchText = _searchText.asObservable().filter({ return $0.count > 0})
        Observable.combineLatest(searchText, _sortOrder.asObservable(), _direction.asObservable()).subscribe(onNext: { (text, order, direction) in
            self.loading.value = true
            self.lastRequest?.dispose()
            
            let request = self.scryfallService.search(query: text, sort: order, direction: direction).share(replay: 1, scope: .whileConnected)
            self.lastRequest = request.subscribe(onNext: { cardsList in
                self.cards.value = cardsList.data
                self.hasMore.value = cardsList.hasMore
                self.nextPage = cardsList.nextPage
            }, onError: { error in
                switch error {
                case WebServiceError.badStatusCode(let code):
                    if (code == 404) {
                        self.cards.value = []
                        self.hasMore.value = false
                        self.nextPage = nil
                    } else {
                        // show error
                        print("API error")
                    }
                default:
                    // show error
                    print("API error")
                }
            })
            
            request.subscribe({ _ in
                self.loading.value = false
            }).disposed(by: self.bag)
        }).disposed(by: bag)
    }
    
    lazy var onCancel: Action<Void, Void> = { [unowned self] in
        return Action { [unowned self] in
            self.hasMore.value = false
            self.cards.value = []
            
            return .just(())
        }
    }()
    
    lazy var onSearch: Action<String, Void> = { [unowned self] in
        return Action { [unowned self] query in
            self._searchText.value = query
            return .just(())
        }
    }()
    
    lazy var onMenuItemSelected: Action<PopoverMenuItem, Void> = { [unowned self] in
        return Action { [unowned self] item in
            switch item.name {
            case "All sets":
                let setsViewModel = SetsListViewModel(service: self.scryfallService,
                                                      coordinator: self.sceneCoordinator,
                                                      callback: self.onLink)
                return self.sceneCoordinator.transition(to: Scene.sets(setsViewModel), type: .push)
            case "Random":
                return self.scryfallService.random().observeOn(MainScheduler.instance).flatMap { card -> Observable<Void> in
                    let viewModel = CardDetailsViewModel(card: card,
                                                         service: self.scryfallService,
                                                         coordinator: self.sceneCoordinator,
                                                         callback: self.onLink)
                    return self.sceneCoordinator.transition(to: Scene.details(viewModel), type: .formSheet)
                }
            default:
                return .just(())
            }
        }
    }()
    
    lazy var onNextPage: CocoaAction = { this in
        return CocoaAction {
            if let nextPage = this.nextPage, let components = URLComponents.init(url: nextPage, resolvingAgainstBaseURL: false), let parameters = components.queryItems {
                this.lastRequest?.dispose()
                
                let query = URLQueryItem(name: "q", value: this.searchText.value)
                let order = URLQueryItem(name: "order", value: this.sortOrder.value.rawValue)
                let direction = URLQueryItem(name: "dir", value: this.direction.value.rawValue)
                let page = parameters.first(where: { $0.name == "page" })!
                
                this.lastRequest = this.scryfallService.search(params: [query, order, page, direction]).subscribe(onNext: { cardsList in
                    this.cards.value.append(contentsOf: cardsList.data)
                    this.hasMore.value = cardsList.hasMore
                    this.nextPage = cardsList.nextPage
                })
            }
            
            return .just(())
        }
    }(self)
    
    lazy var showAction: Action<Card, Void> = { this in
        return Action { card in
            let detailsViewModel = CardDetailsViewModel(card: card,
                                                     service: this.scryfallService,
                                                 coordinator: this.sceneCoordinator,
                                                    callback: this.onLink)
            return this.sceneCoordinator.transition(to: Scene.details(detailsViewModel), type: .formSheet)
        }
    }(self)
    
    lazy var onLink: Action<[URLQueryItem], Void> = { [unowned self] in
        return Action { [unowned self] queryItems in
            self.loading.value = true
            self.lastRequest?.dispose()
            
            if let query = queryItems.filter({ $0.name == "q" }).first, let queryText = query.value {
                self.searchText.value = queryText
            }
            
            if let order = queryItems.filter({ $0.name == "order" }).first?.value, let orderValue = CardSortOrder(rawValue: order) {
                self.sortOrder.value = orderValue
            }
            
            if let direction = queryItems.filter({ $0.name == "dir" }).first?.value, let dirValue = SortDirection(rawValue: direction) {
                self.direction.value = dirValue
            } else {
                self.direction.value = .auto
            }
            
            let request = self.scryfallService.search(params: queryItems).share(replay: 1, scope: .whileConnected)
            self.lastRequest = request.subscribe(onNext: { cardsList in
                self.cards.value = cardsList.data
                self.hasMore.value = cardsList.hasMore
                self.nextPage = cardsList.nextPage
            })
            
            request.subscribe({ _ in
                self.loading.value = false
            }).disposed(by: self.bag)
            
            return .just(())
        }
    }()
    
    lazy var onSortOrderChange: Action<CardSortOrder, Void> = { [unowned self] in
        return Action { [unowned self] sortOrder in
            self._sortOrder.value = sortOrder
            return .just(())
        }
    }()
    
    lazy var onSortDirectionChange: Action<SortDirection, Void> = { [unowned self] in
        return Action { [unowned self] direction in
            self._direction.value = direction
            return .just(())
        }
    }()
}
