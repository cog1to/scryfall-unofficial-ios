//
//  Price.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/16/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum PriceType {
    case usd
    case eur
    case tix
    
    var symbol: String {
        switch self {
        case .usd:
            return "$"
        case .eur:
            return "€"
        case .tix:
            return ""
        }
    }
    
    var abbreviation: String {
        switch self {
        case .usd:
            return "USD"
        case .eur:
            return "EUR"
        case .tix:
            return "TIX"
        }
    }
}

struct Price {
    var type: PriceType
    var value: Float?
}
