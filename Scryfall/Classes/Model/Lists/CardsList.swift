//
//  CardsList.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardsList: RemoteList<Card> {
    let totalCards: Int
    
    required init?(json: JSON) {
        guard let totalCards = json["total_cards"].int else {
            return nil
        }
        
        self.totalCards = totalCards
        
        super.init(json: json)
    }
}
