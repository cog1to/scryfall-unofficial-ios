//
//  Rarity.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Rarity {
    case common
    case uncommon
    case rare
    case mythic
    
    var name: String {
        get {
            switch self {
            case .common:
                return "Common"
            case .uncommon:
                return "Uncommon"
            case .rare:
                return "Rare"
            case .mythic:
                return "Mythic"
            }
        }
    }
    
    init?(value: String) {
        switch value.lowercased() {
        case "common":
            self = .common
        case "uncommon":
            self = .uncommon
        case "rare":
            self = .rare
        case "mythic":
            self = .mythic
        default:
            return nil
        }
    }
}
