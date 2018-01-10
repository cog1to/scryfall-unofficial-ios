//
//  NameToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class NameToken: TextToken {
    var exact: Bool
    
    override func string() -> String {
        switch value {
        case .plain:
            return applyNegation(string: (exact ? "!" : "") + "\(value.value)")
        case .regexp:
            return applyNegation(string: "name:" + "\(value.value)")
        }
    }
    
    init(value: TextValue, exact: Bool = false, negative: Bool = false) {
        self.exact = exact
        super.init(value: value, negative: negative)
    }
}
