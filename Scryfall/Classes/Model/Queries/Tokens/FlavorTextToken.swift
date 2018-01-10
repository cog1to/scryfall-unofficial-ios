//
//  FlavorTextToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class FlavorTextToken: QueryToken {
    var negative: Bool
    var value: TextValue
    
    override var string: String {
        return (negative ? "-" : "") + "ft:\(value.value)"
    }
    
    init(value: TextValue, negative: Bool = false) throws {
        self.value = value
        self.negative = negative
    }
}
