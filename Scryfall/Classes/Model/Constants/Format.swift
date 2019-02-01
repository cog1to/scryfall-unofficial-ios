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
    case unknown = "unknown"
    case oldschool = "oldschool"
    
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
            case .unknown:
                return "Unknown"
            case .oldschool:
                return "Oldschool"
            }
        }
    }
    
    init?(rawValue: String) {
        switch rawValue {
        case "standard":
            self = .standard
        case "frontier":
            self = .frontier
        case "modern":
            self = .modern
        case "pauper":
            self = .pauper
        case "legacy":
            self = .legacy
        case "penny":
            self = .penny
        case "vintage":
            self = .vintage
        case "duel":
            self = .duel
        case "commander":
            self = .commander
        case "1v1":
            self = .onevone
        case "future":
            self = .future
        case "brawl":
            self = .brawl
        case "oldschool":
            self = .oldschool
        default:
            self = .unknown
        }
    }
    
    static var displayed: [Format] {
        get {
            return [.standard, .frontier, .modern, .pauper, .legacy, .penny, .vintage, .commander, .onevone, .brawl]
        }
    }
}
