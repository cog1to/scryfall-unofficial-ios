//
//  ColorQueryToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ColorSetToken: ComparableToken<Set<Color>> {
    override func name() throws -> String {
        return "color"
    }
    
    override func valueString() throws -> String {
        return value.reduce("", { $0 + $1.rawValue })
    }
}
