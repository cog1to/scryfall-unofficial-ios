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

class NumericToken: ComparableToken<NumericValue> {

    override func valueString() throws -> String {
        return value.value()
    }
    
    /// Override this to provide proper value name.
    internal class func name() -> String {
        return "undefined"
    }
}

