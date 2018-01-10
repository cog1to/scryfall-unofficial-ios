//
//  FormatToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class FormatToken: QueryToken {
    var value: Format
    var negative: Bool
    
    override var string: String {
        return (negative ? "-" : "") + "f:\(value)"
    }
    
    init(value: Format, negative: Bool = false) {
        self.value = value
        self.negative = negative
    }
}
