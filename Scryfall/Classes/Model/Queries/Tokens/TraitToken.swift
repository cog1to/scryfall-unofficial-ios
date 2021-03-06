//
//  TraitToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class TraitToken: StringEnumToken<Trait> {
    override func name() throws -> String {
        switch value {
        case .hasWatermark:
            return "has"
        default:
            return "is"
        }
    }
    
    override func valueString() throws -> String {
        switch value {
        case .hasWatermark:
            return "watermark"
        default:
            return value.rawValue
        }
    }
}
