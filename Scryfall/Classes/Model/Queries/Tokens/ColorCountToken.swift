//
//  ColorCountToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ColorCountToken: QueryToken {
    var value: Int
    var comparison: Comparison
    var negative: Bool
    
    override var string: String {
        return (negative ? "-" : "") + "colors" + comparison.rawValue + "\(value)"
    }
    
    init(value: Int, comparison: Comparison = .equals, negative: Bool = false) {
        self.value = value
        self.comparison = comparison
        self.negative = negative
    }
}
