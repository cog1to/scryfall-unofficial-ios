//
//  CardFace.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardFace {
    var name: String
    var manaCost: String?
    var typeLine: String
    var oracleText: String?
    var imageUris: [URL]?
    
    init?(json: JSON) {
        guard let name = json["name"].string, let typeLine = json["type_line"].string else {
            return nil
        }
        
        self.name = name
        self.typeLine = typeLine
        
        if let oracleText = json["oracle_text"].string {
            self.oracleText = oracleText
        }
        
        if let manaCost = json["mana_cost"].string {
            self.manaCost = manaCost
        }
        
        if let imageUris = json["image_uris"].array {
            self.imageUris = imageUris.map { return $0.url! }
        }
    }
}
