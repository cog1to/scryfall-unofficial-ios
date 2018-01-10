//
//  BorderToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class BorderToken: QueryToken {
    var negative: Bool
    var value: Border
    
    override var string: String {
        return (negative ? "-" : "") + "border:\(value.rawValue)"
    }
    
    init(value: Border, negative: Bool = false) throws {
        self.value = value
        self.negative = negative
    }
}
