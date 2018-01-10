//
//  ColorIdentity.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ColorIdentityToken: ComparableToken<Set<Color>> {
    override func name() throws -> String {
        return "identity"
    }
}
