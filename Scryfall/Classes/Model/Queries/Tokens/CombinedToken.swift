//
//  CombinedToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum LogicalOperator: String {
    case or = "OR"
    case and = "AND"
}

class CombinedToken: QueryToken {
    var op: LogicalOperator
    var value: [QueryToken]
    var negative: Bool
    
    func string() throws -> String {
        let string = try value.map { return try $0.string() }.joined(separator: " \(op.rawValue) ")
        return "(\(string))"
    }
    
    init(value: [QueryToken], op: LogicalOperator = .and, negative: Bool = false) {
        self.op = op
        self.value = value
        self.negative = negative
    }
}
