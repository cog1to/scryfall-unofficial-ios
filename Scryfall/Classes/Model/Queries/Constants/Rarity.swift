//
//  Rarity.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Rarity: String {
    case common = "common"
    case uncommon = "uncommon"
    case rare = "rare"
    case mythic = "mythic"
    
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
}
