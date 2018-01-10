//
//  OracleTextToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class OracleTextToken: QueryToken {
    var negative: Bool
    var value: TextValue
    
    override var string: String {
        return (negative ? "-" : "") + "o:\(value.value)"
    }
    
    init(value: TextValue, negative: Bool = false) throws {
        self.value = value
        self.negative = negative
    }
}
