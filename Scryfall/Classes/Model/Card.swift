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

class Card: CardFace {
    var ID: String
    var multiverseIDs: [Int]?
    var mtgoID: Int?
    var uri: URL?
    var scryfallUri: URL?
    var printSearchUri: URL?
    var setName: String
    var setCode: String
    var collectorsNumber: String
    var priceUSD: Float?
    var rarity: Rarity
    var faces: [CardFace]?
    var layout: Layout
    var artist: String?
    var reserved: Bool
    var legalities: [Format: Legality]
    
    override init?(json: JSON) {
        // Validate mandatory fields.
        guard let id = json["id"].string else {
            return nil
        }
        
        guard let rarity = json["rarity"].string else {
            return nil
        }
        
        guard let layout = json["layout"].string else {
            return nil
        }
        
        // Initialize mandatory fields.
        self.ID = id
        self.setName = json["set_name"].stringValue
        self.setCode = json["set"].stringValue
        self.collectorsNumber = json["collector_number"].stringValue
        self.reserved = json["reserved"].bool ?? false
        
        if let legalitiesDictionary = json["legalities"].dictionary {
            self.legalities = Dictionary<Format, Legality>(uniqueKeysWithValues: legalitiesDictionary.map { (pair) in
                return (Format(rawValue: pair.key)!, Legality(rawValue: pair.value.stringValue)!)
            })
        } else {
            self.legalities = [:]
        }
        
        if let rarityValue = Rarity(rawValue: rarity) {
            self.rarity = rarityValue
        } else {
            self.rarity = .common
        }
        
        if let layoutValue = Layout(rawValue: layout) {
            self.layout = layoutValue
        } else {
            self.layout = .normal
        }
        
        // Initialize parent properties.
        super.init(json: json)
        
        // Initialize optional properties.
        self.mtgoID = json["mtgo_id"].int
        self.uri = json["uri"].url
        self.scryfallUri = json["scryfall_uri"].url
        self.printSearchUri = json["print_search_uri"].url
        self.artist = json["artist"].string
        
        if let multiverseArray = json["multiverse_ids"].array {
            self.multiverseIDs = multiverseArray.map { return $0.intValue }
        }
        
        if let priceString = json["usd"].string, let price = Float(priceString) {
            self.priceUSD = price
        }
        
        if let faces = json["card_faces"].array {
            self.faces = faces.map { return CardFace(json: $0)! }
        }
    }
}
