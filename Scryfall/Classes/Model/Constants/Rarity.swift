//
//  Rarity.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

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
    
    var color: UIColor {
        switch self {
        case .common:
            return Style.color(forKey: .common)
        case .uncommon:
            return Style.color(forKey: .uncommon)
        case .rare:
            return Style.color(forKey: .rare)
        case .mythic:
            return Style.color(forKey: .mythicRare)
        }
    }
}
