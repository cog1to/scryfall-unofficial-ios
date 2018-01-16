//
//  CardFace.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardFace: JSONConvertible {
    var name: String
    var manaCost: String? = nil
    var typeLine: String
    var oracleText: String? = nil
    var flavorText: String? = nil
    var imageUris: [CardImageType: URL]
    var power: String? = nil
    var toughness: String? = nil
    var loyalty: String? = nil
    
    required init?(json: JSON) {
        guard let name = json["name"].string else {
            return nil
        }
        
        self.name = name
        self.typeLine = json["type_line"].string ?? ""
        self.oracleText = json["oracle_text"].string
        self.flavorText = json["flavor_text"].string
        self.power = json["power"].string
        self.toughness = json["toughness"].string
        self.loyalty = json["loyalty"].string
        
        if let manaCost = json["mana_cost"].string {
            self.manaCost = manaCost
        }
        
        if let imageUris = json["image_uris"].dictionaryObject {
            let filtered = imageUris.filter { ($0.value as? String) != nil }
            self.imageUris = Dictionary<CardImageType, URL>(uniqueKeysWithValues: filtered.map { (pair) in
                return (CardImageType(rawValue: pair.key)!, URL(string: pair.value as! String)!)
            })
        } else {
            self.imageUris = [:]
        }
    }
}
