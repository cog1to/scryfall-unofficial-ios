//
//  Card.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

//
//  Card.swift
//  Card Converter
//
//  Created by Alexander Rogachev on 17/11/2017.
//  Copyright © 2017 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class Card {
    var ID: String
    var multiverseIDs: [Int]
    var mtgoID: Int?
    var uri: URL?
    var scryfallUri: URL?
    var printSearchUri: URL?
    var setName: String
    var setCode: String
    var name: String
    var collectorsNumber: String
    var priceUSD: Float?
    var imageUris: [CardImageURIType: URL]
    var typeLine: String
    var rarity: Rarity
    var manaCost: String?
    var faces: [CardFace]?
    var layout: Layout
    var oracleText: String?
    var flavorText: String?
    var power: String?
    var toughness: String?
    
    init?(json: JSON) {
        guard let id = json["id"].string else {
            return nil
        }
        
        guard let rarity = json["rarity"].string else {
            return nil
        }
        
        guard let layout = json["layout"].string else {
            return nil
        }
        
        self.ID = id
        self.mtgoID = json["mtgo_id"].int
        self.multiverseIDs = json["multiverse_ids"].arrayObject as! [Int]
        self.uri = json["uri"].url
        self.scryfallUri = json["scryfall_uri"].url
        self.printSearchUri = json["print_search_uri"].url
        self.setName = json["set_name"].stringValue
        self.setCode = json["set"].stringValue
        self.name = json["name"].stringValue
        self.collectorsNumber = json["collectors_number"].stringValue
        self.typeLine = json["type_line"].stringValue
        self.oracleText = json["oracle_text"].string
        self.flavorText = json["flavor_text"].string
        self.power = json["power"].string
        self.toughness = json["toughness"].string
        
        if let priceString = json["usd"].string, let price = Float(priceString) {
            self.priceUSD = price
        }
        
        if let rarityValue = Rarity(value: rarity) {
            self.rarity = rarityValue
        } else {
            self.rarity = .common
        }
        
        if let layoutValue = Layout(value: layout) {
            self.layout = layoutValue
        } else {
            self.layout = .normal
        }
        
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
        
        if let faces = json["card_faces"].array {
            self.faces = faces.map { return CardFace(json: $0)! }
        }
    }
}
