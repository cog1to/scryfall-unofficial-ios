//
//  CardSortOrder.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 2/16/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum CardSortOrder: String, StringRepresentableOption {
    case name = "name"
    case set = "set"
    case rarity = "rarity"
    case color = "color"
    case usd = "usd"
    case tix = "tix"
    case eur = "eur"
    case cmc = "cmc"
    case power = "power"
    case toughness = "toughness"
    case edhrec = "edhrec"
    case artist = "artist"
    
    var name: String {
        switch self {
        case .name:
            return "Name"
        case .set:
            return "Set/Number"
        case .artist:
            return "Artist Name"
        case .cmc:
            return "CMC"
        case .power:
            return "Power"
        case .toughness:
            return "Toughness"
        case .color:
            return "Color/ID"
        case .edhrec:
            return "EDHREC Rank"
        case .rarity:
            return "Rarity"
        case .usd:
            return "Price: USD"
        case .eur:
            return "Price: EUR"
        case .tix:
            return "Price: TIX"
        }
    }
    
    static var all: [CardSortOrder] = [.name, .set, .rarity, .color, .usd, .tix, .eur, .cmc, .power, .toughness, .edhrec, .artist]
}
