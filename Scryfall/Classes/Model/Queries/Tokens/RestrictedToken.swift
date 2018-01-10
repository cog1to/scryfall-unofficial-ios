//
//  RestrictedToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class RestrictedToken: EqualityToken<Format> {
    override func name() throws -> String {
        return "restricted"
    }
    
    override func valueString() throws -> String {
        return value.rawValue
    }
}
