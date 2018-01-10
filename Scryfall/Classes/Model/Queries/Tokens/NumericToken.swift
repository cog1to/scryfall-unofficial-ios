//
//  NumericToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum NumericValue {
    case number(Float)
    case reference(NumericToken.Type)
    
    func value() -> String {
        switch self {
        case .number(let number):
            return "\(number)"
        case .reference(let type):
            return type.name()
        }
    }
}

class NumericToken: QueryToken {
    var value: NumericValue
    var comparison: Comparison
    var negative: Bool
    
    /// Override this to provide proper value name.
    internal class func name() -> String {
        return "undefined"
    }
    
    override var string: String {
        return (negative ? "-" : "") + "\(type(of: self).name())\(comparison.rawValue)\(value.value())"
    }
    
    init(value: NumericValue, comparison: Comparison = .equals, negative: Bool = false) {
        self.value = value
        self.comparison = comparison
        self.negative = negative
    }
}

