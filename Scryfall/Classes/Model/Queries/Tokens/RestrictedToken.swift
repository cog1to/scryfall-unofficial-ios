//
//  RestrictedToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class RestrictedToken: QueryToken {
    var value: Format
    var negative: Bool
    
    override var string: String {
        return (negative ? "-" : "") + "restricted:\(value)"
    }
    
    init(value: Format, negative: Bool = false) {
        self.value = value
        self.negative = negative
    }
}