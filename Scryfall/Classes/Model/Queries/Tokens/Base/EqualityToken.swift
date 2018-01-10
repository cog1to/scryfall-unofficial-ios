//
//  EqualityToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class EqualityToken<T>: NegatableToken<T> {
    override func string() throws -> String {
        return applyNegation(string: try "\(name()):\(valueString())")
    }
}
