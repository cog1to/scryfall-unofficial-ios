//
//  PrintedInGame.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class PrintedInGame: QueryToken {
    var value: Game
    var negative: Bool
    
    override var string: String {
        return (negative ? "-" : "") + "game:\(value)"
    }
    
    init(value: Game, negative: Bool = false) {
        self.value = value
        self.negative = negative
    }
}
