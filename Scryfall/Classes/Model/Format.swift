//
//  Format.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/7/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Format {
    case standard
    case frontier
    case modern
    case pauper
    case legacy
    case penny
    case vintage
    case duel
    case commander
    case onevone
    case future
    
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
                return "Commander"
            case .onevone:
                return "1v1 Cmdr."
            case .future:
                return "Future Standard"
            }
        }
    }
    
    init?(value: String) {
        switch value.lowercased() {
        case "standard":
            self = .standard
        case "pauper":
            self = .pauper
        case "modern":
            self = .modern
        case "legacy":
            self = .legacy
        case "vintage":
            self = .vintage
        case "penny":
            self = .penny
        case "frontier":
            self = .frontier
        case "duel":
            self = .duel
        case "1v1":
            self = .onevone
        case "commander":
            self = .commander
        case "future":
            self = .future
        default:
            return nil
        }
    }
    
    static var displayed: [Format] {
        get {
            return [.standard, .frontier, .modern, .pauper, .legacy, .penny, .vintage, .duel, .commander, .onevone]
        }
    }
}
