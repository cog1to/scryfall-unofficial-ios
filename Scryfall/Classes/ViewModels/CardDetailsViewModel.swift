//
//  CardDetailsViewModel.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift
import Action

class CardDetailsViewModel {
    let card: Card
    let service: ScryfallServiceType
    let coordinator: SceneCoordinatorType
    let onCancel: CocoaAction
    
    lazy var prints: Observable<[Card]>? = {
        if let printsUrl = card.printSearchUri {
            return Observable<URL>.just(printsUrl)
                .map { url -> [URLQueryItem]? in
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                    return components?.queryItems
                }.filter {
                    $0 != nil
                }.map {
                    $0!
                }.flatMap { [unowned self] in
                    return self.service.search(params: $0)
                }.map { cardList -> [Card] in
                    return cardList.data
                }.share(replay: 1)
        } else {
            return nil
        }
    }()
    
    private let disposeBag = DisposeBag()
    
    init(card: Card, service: ScryfallServiceType, coordinator: SceneCoordinatorType) {
        self.card = card
        self.service = service
        self.coordinator = coordinator
        
        onCancel = CocoaAction {
            return coordinator.pop()
        }
    }
}
