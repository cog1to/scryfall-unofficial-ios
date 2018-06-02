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
    let sortOrder = Variable<SortOrder>(.name)
    
    private var nextPage: URL?
    private var lastRequest: Disposable?
    private let bag = DisposeBag()
    
    private let _searchText = Variable<String>("")
    private let _sortOrder = Variable<SortOrder>(.name)
    
    init(service: ScryfallServiceType, coordinator: SceneCoordinatorType) {
        scryfallService = service
        sceneCoordinator = coordinator
        cards = Variable<[Card]>([])
        hasMore = Variable<Bool>(false)
        loading = Variable<Bool>(false)
        
        let searchText = _searchText.asObservable().filter({ return $0.count > 0})
        Observable.combineLatest(searchText, _sortOrder.asObservable()).subscribe(onNext: { (text, order) in
            self.loading.value = true
            self.lastRequest?.dispose()
            
            let request = self.scryfallService.search(query: text, sort: order).share(replay: 1, scope: .whileConnected)
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
    
    lazy var onCancel: Action<Void, Void> = { this in
        return Action {
            this.hasMore.value = false
            this.cards.value = []
            
            return Observable.just(())
        }
    }(self)
    
    lazy var onSearch: Action<String, Void> = { this in
        return Action { query in
            this._searchText.value = query
            return Observable.just(())
        }
    }(self)
    
    lazy var onMenuItemSelected: Action<String, Void> = { this in
        return Action { query in
            let setsViewModel = SetsListViewModel(service: this.scryfallService,
                                                  coordinator: this.sceneCoordinator,
                                                  callback: this.onLink)
            return this.sceneCoordinator.transition(to: Scene.sets(setsViewModel), type: .push)
        }
    }(self)
    
    lazy var onNextPage: CocoaAction = { this in
        return CocoaAction {
            if let nextPage = this.nextPage, let components = URLComponents.init(url: nextPage, resolvingAgainstBaseURL: false), let parameters = components.queryItems {
                this.lastRequest?.dispose()
                this.lastRequest = this.scryfallService.search(params: parameters).subscribe(onNext: { cardsList in
                    this.cards.value.append(contentsOf: cardsList.data)
                    this.hasMore.value = cardsList.hasMore
                    this.nextPage = cardsList.nextPage
                })
            }
            
            return Observable.just(())
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
    
    lazy var onLink: Action<[URLQueryItem], Void> = { this in
        return Action { queryItems in
            this.loading.value = true
            this.lastRequest?.dispose()
            
            if let query = queryItems.filter({ $0.name == "q" }).first, let queryText = query.value {
                this.searchText.value = queryText
            }
            
            if let order = queryItems.filter({ $0.name == "order" }).first?.value, let orderValue = SortOrder(rawValue: order) {
                this.sortOrder.value = orderValue
            }
            
            let request = self.scryfallService.search(params: queryItems).share(replay: 1, scope: .whileConnected)
            this.lastRequest = request.subscribe(onNext: { cardsList in
                this.cards.value = cardsList.data
                this.hasMore.value = cardsList.hasMore
                this.nextPage = cardsList.nextPage
            })
            
            request.subscribe({ _ in
                this.loading.value = false
            }).disposed(by: this.bag)
            
            return Observable.just(())
        }
    }(self)
    
    lazy var onSortOrderChange: Action<SortOrder, Void> = { this in
        return Action { sortOrder in
            this._sortOrder.value = sortOrder
            return Observable.just(())
        }
    }(self)
}
