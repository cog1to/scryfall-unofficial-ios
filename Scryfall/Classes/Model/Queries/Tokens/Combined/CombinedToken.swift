//
//  CombinedToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/5/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class CombinedToken: QueryToken {
    var value: [QueryToken]
    
    func string() throws -> String {
        let string = try value.map { return try $0.string() }.joined(separator: " ")
        return "\(string)"
    }
    
    init(value: [QueryToken]) {
        self.value = value
    }
}
