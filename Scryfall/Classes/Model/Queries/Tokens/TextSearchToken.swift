//
//  TextSearchToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class TextSearchToken: QueryToken {
    var value: String
    var negative: Bool
    var exact: Bool
    
    override var string: String {
        return (negative ? "-" : "") + (exact ? "!" : "") + "\"\(value)\""
    }
    
    init(value: String, exact: Bool = false, negative: Bool = false) {
        self.value = value
        self.exact = exact
        self.negative = negative
    }
}
