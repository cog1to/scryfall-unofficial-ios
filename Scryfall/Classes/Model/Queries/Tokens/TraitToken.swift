//
//  TraitToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class TraitToken: QueryToken {
    var value: Trait
    var negative: Bool
    
    override var string: String {
        let valueString = (value == .hasWatermark) ? "has:watermark" : "is:\(value.rawValue)"
        return (negative ? "-" : "") + valueString
    }
    
    init(value: Trait, negative: Bool = false) {
        self.value = value
        self.negative = negative
    }
}
