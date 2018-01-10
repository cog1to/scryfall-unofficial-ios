//
//  PrintedInGame.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class PrintedInGame: EqualityToken<Game> {
    override func name() throws -> String {
        return "game"
    }
    
    override func valueString() throws -> String {
        return value.rawValue
    }
}
