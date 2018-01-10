//
//  IsInToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum IncludedType {
    case set(MTGSet)
    case game(Game)
    case product(Product)
}

class IsInToken: EqualityToken<IncludedType> {
    override func name() throws -> String {
        return "in"
    }
    
    override func valueString() throws -> String {
        switch value {
        case .set(let set):
            return set.rawValue
        case .game(let game):
            return game.rawValue
        case .product(let product):
            return product.rawValue
        }
    }
}
