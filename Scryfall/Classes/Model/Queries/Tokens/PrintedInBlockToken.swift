//
//  PrintedInBlockToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class PrintedInBlockToken: EqualityToken<CardSet> {
    override func name() throws -> String {
        return "block"
    }
    
    override func valueString() throws -> String {
        return value.code
    }
}
