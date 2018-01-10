//
//  ManaToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ManaToken: NegatableToken<[ManaSymbol]> {
    override func name() throws -> String {
        return "mana"
    }
    
    override func valueString() throws -> String {
        return value.map { $0.rawValue }.joined(separator: "")
    }
}
