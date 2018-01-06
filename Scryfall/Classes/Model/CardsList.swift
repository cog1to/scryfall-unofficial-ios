//
//  CardsList.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardsList {
    let totalCards: Int
    let hasMore: Bool
    let data: [Card]
    let nextPage: URL?
    
    init?(json: JSON) {
        guard let totalCards = json["total_cards"].int else {
            return nil
        }
        
        guard let hasMore = json["has_more"].bool else {
            return nil
        }
        
        guard let data = json["data"].array else {
            return nil
        }
        
        self.totalCards = totalCards
        self.hasMore = hasMore
        self.data = data.map { return Card(json: $0)! }
        
        if let nextPage = json["next_page"].url {
            self.nextPage = nextPage
        } else {
            self.nextPage = nil
        }
    }
}
