//
//  Format.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/7/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Format: String {
    case standard = "standard"
    case frontier = "frontier"
    case modern = "modern"
    case pauper = "pauper"
    case legacy = "legacy"
    case penny = "penny"
    case vintage = "vintage"
    case duel = "duel"
    case commander = "commander"
    case onevone = "1v1"
    case future = "future"
    case brawl = "brawl"
    
    var name: String {
        get {
            switch self {
            case .standard:
                return "Standard"
            case .frontier:
                return "Frontier"
            case .modern:
                return "Modern"
            case .pauper:
                return "Pauper"
            case .legacy:
                return "Legacy"
            case .penny:
                return "Penny"
            case .vintage:
                return "Vintage"
            case .duel:
                return "Duel Cmdr."
            case .commander:
                return "Cmdr."
            case .onevone:
                return "1v1 Cmdr."
            case .future:
                return "Future Standard"
            case .brawl:
                return "Brawl"
            }
        }
    }
    
    static var displayed: [Format] {
        get {
            return [.standard, .frontier, .modern, .pauper, .legacy, .penny, .vintage, .commander, .onevone, .brawl]
        }
    }
}
