//
//  CardLayout.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Layout: String {
    case normal = "normal"
    case split = "split"
    case flip = "flip"
    case transform = "transform"
    case meld = "meld"
    case leveler = "leveler"
    case planar = "planar"
    case scheme = "scheme"
    case vanguard = "vanguard"
    case token = "token"
    case doubleFacedToken = "double_faced_token"
    case emblem = "emblem"
    case augment = "augment"
    case host = "host"
    
    var name: String {
        get {
            switch self {
            case .doubleFacedToken:
                return "Double-faced Token"
            default:
                return rawValue.capitalized
            }
        }
    }
}
