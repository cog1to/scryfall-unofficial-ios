//
//  ComparableToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ComparableToken<T>: NegatableToken<T> {
    var comparison: Comparison
    
    override func string() throws -> String {
        return applyNegation(string: try "\(name())\(comparison)\(valueString())")
    }
    
    init(value: T, comparison: Comparison = .equals, negative: Bool = false) {
        self.comparison = comparison
        super.init(value: value, negative: negative)
    }
}
