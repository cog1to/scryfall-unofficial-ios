//
//  RarityToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class RarityToken: QueryToken {
    var value: Rarity
    var negative: Bool
    
    override var string: String {
        return (negative ? "-" : "") + "r:\(value.rawValue)"
    }
    
    init(value: Rarity, negative: Bool = false) {
        self.value = value
        self.negative = negative
    }
}
