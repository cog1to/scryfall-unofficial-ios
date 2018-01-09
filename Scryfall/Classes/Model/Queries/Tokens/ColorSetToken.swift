//
//  ColorQueryToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ColorSetToken: QueryToken {
    var value: Set<Color>
    var comparison: Comparison
    var negative: Bool
    
    override var string: String {
        return (negative ? "-" : "") + "color" + comparison.rawValue + value.reduce("", { $0 + $1.rawValue })
    }
    
    init(value: Set<Color>, comparison: Comparison = .equals, negative: Bool = false) {
        self.value = value
        self.comparison = comparison
        self.negative = negative
    }
}
