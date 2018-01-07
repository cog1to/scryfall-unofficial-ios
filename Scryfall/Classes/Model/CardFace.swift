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
    var flavorText: String?
    var imageUris: [CardImageURIType: URL]
    var power: String?
    var toughness: String?
    
    init?(json: JSON) {
        guard let name = json["name"].string, let typeLine = json["type_line"].string else {
            return nil
        }
        
        self.name = name
        self.typeLine = typeLine
        self.oracleText = json["oracle_text"].string
        self.flavorText = json["flavor_text"].string
        self.power = json["power"].string
        self.toughness = json["toughness"].string
        
        if let manaCost = json["mana_cost"].string {
            self.manaCost = manaCost
        }
        
        if let imageUris = json["image_uris"].dictionaryObject {
            let filtered = imageUris.filter { ($0.value as? String) != nil }
            self.imageUris = Dictionary<CardImageURIType, URL>(uniqueKeysWithValues: filtered.map { (pair) in
                return (CardImageURIType(value: pair.key)!, URL(string: pair.value as! String)!)
            })
        } else {
            self.imageUris = [:]
        }
    }
}