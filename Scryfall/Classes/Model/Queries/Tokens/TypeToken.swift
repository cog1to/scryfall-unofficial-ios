//
//  TypeToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class TypeToken: QueryToken {
    var negative: Bool
    var value: String
    
    override var string: String {
        return (negative ? "-" : "") + "t:\(value)"
    }
    
    init(value: String, negative: Bool = false) throws {
        guard !value.contains(" ") else {
            throw QueryError.illegalTypeValue(value)
        }
        
        self.value = value
        self.negative = negative
    }
}
