//
//  ManaToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ManaToken: QueryToken {
    var value: [ManaSymbol]
    var negative: Bool
    
    override var string: String {
        let manaString: String = value.map { $0.rawValue }.joined()
        return (negative ? "-" : "") + "mana:\(manaString)"
    }
    
    init(value: [ManaSymbol], negative: Bool = false) throws {
        self.value = value
        self.negative = negative
    }
}
