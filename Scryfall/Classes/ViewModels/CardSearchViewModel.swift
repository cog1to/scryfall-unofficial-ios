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
            return this.scryfallService.search(query: query).do(onNext: { cardsList in
                this.cards.value = cardsList.data
                this.hasMore.value = cardsList.hasMore
                this.nextPage = cardsList.nextPage
            }).map { _ in }
        }
    }(self)
    
    lazy var onNextPage: CocoaAction = { this in
        return CocoaAction {
            if let nextPage = this.nextPage, let components = URLComponents.init(url: nextPage, resolvingAgainstBaseURL: false), let parameters = components.queryItems {
                return this.scryfallService.search(params: parameters).do(onNext: { cardsList in
                    this.cards.value.append(contentsOf: cardsList.data)
                    this.hasMore.value = cardsList.hasMore
                    this.nextPage = cardsList.nextPage
                }).map { _ in }
            } else {
                return Observable<Void>.just(())
            }
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
