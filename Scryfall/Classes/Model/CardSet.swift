//
//  CardSet.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardSet: JSONConvertible {
    var code: String
    var mtgoCode: String?
    var name: String
    var setType: CardSetType
    var releasedAt: Date?
    var blockCode: String?
    var block: String?
    var parentSetCode: String?
    var cardCount: Int
    var digital: Bool
    var foil: Bool
    var iconURI: URL?
    var searchURI: URL?
    
    required init?(json: JSON) {
        guard let code = json["code"].string,
            let name = json["name"].string,
            let cardCount = json["card_count"].int,
            let digital = json["digital"].bool,
            let foil = json["foil"].bool else {
                return nil
        }
        
        guard let setTypeString = json["set_type"].string, let setType = CardSetType(rawValue: setTypeString) else {
            return nil
        }
        
        self.code = code
        self.name = name
        self.cardCount = cardCount
        self.digital = digital
        self.foil = foil
        self.setType = setType
        
        self.mtgoCode = json["mtgo_code"].string
        self.block = json["block"].string
        self.blockCode = json["block_code"].string
        self.parentSetCode = json["parent_set_code"].string
        self.iconURI = json["icon_svg_uri"].url
        self.searchURI = json["search_uri"].url
    }
}
