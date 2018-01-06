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
    
    init(card: Card, service: ScryfallServiceType, coordinator: SceneCoordinatorType) {
        self.card = card
        self.service = service
        self.coordinator = coordinator
        
        onCancel = CocoaAction {
            return coordinator.pop()
        }
    }
}
