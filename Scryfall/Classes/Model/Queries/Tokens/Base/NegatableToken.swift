//
//  NegatableToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class NegatableToken<T>: ValueToken<T> {
    var negative: Bool
    
    func applyNegation(string: String) -> String {
        return (negative ? "-" : "") + string
    }
    
    init(value: T, negative: Bool = false) {
        self.negative = negative
        super.init(value: value)
    }
}
