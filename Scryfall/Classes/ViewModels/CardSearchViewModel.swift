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
    
    private var nextPage: URL?
    private var lastRequest: Disposable?
    private let bag = DisposeBag()
    
    init(service: ScryfallServiceType, coordinator: SceneCoordinatorType) {
        scryfallService = service
        sceneCoordinator = coordinator
        cards = Variable<[Card]>([])
        hasMore = Variable<Bool>(false)
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
            this.lastRequest?.dispose()
            this.lastRequest = this.scryfallService.search(query: query).subscribe(onNext: { cardsList in
                this.cards.value = cardsList.data
                this.hasMore.value = cardsList.hasMore
                this.nextPage = cardsList.nextPage
            })
            
            return Observable.just(())
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
            
            return Observable<Void>.just(())
        }
    }(self)
    
    lazy var showAction: Action<Card, Void> = { this in
        return Action { card in
            let detailsViewModel = CardDetailsViewModel(card: card,
                                                     service: this.scryfallService,
                                                 coordinator: this.sceneCoordinator)
            return this.sceneCoordinator.transition(to: Scene.details(detailsViewModel), type: .formSheet)
        }
    }(self)
}
