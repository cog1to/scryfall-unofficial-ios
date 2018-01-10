//
//  NameToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class NameToken: QueryToken {
    var value: TextValue
    var negative: Bool
    
    override var string: String {
        switch value {
        case .plain:
            return (negative ? "-" : "") + "\(value.value)"
        case .regexp:
            return (negative ? "-" : "") + "name:" + "\(value.value)"
        }
    }
    
    init(value: TextValue, negative: Bool = false) {
        self.value = value
        self.negative = negative
    }
}
