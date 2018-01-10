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

class IsInToken: QueryToken {
    var value: IncludedType
    var negative: Bool
    
    override var string: String {
        switch value {
        case .set(let set):
            return (negative ? "-" : "") + "in:\(set.rawValue)"
        case .game(let game):
            return (negative ? "-" : "") + "in:\(game.rawValue)"
        case .product(let product):
            return (negative ? "-" : "") + "in:\(product.rawValue)"
        }
        
    }
    
    init(value: IncludedType, negative: Bool) {
        self.value = value
        self.negative = negative
    }
}
