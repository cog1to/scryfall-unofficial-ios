//
//  PrintedInBlockToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class PrintedInBlockToken: QueryToken {
    var value: MTGSet
    var negative: Bool
    
    override var string: String {
        return (negative ? "-" : "") + "block:\(value.rawValue)"
    }
    
    init(value: MTGSet, negative: Bool) {
        self.value = value
        self.negative = negative
    }
}
