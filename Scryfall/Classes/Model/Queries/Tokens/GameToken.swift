//
//  GameToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class GameToken: StringEnumToken<Game> {
    override func name() throws -> String {
        return "game"
    }
}
