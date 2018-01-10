//
//  ValueToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ValueToken<T>: QueryToken {
    var value: T

    func name() throws -> String {
        throw QueryError.notImplemented
    }

    func valueString() throws -> String {
        throw QueryError.notImplemented
    }
    
    func string() throws -> String {
        return try "\(name()):\(valueString())"
    }
    
    init(value: T) {
        self.value = value
    }
}
