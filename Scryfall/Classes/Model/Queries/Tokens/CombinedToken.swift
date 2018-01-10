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
    var value: [QueryToken]
    var op: LogicalOperator
    
    override var string: String {
        let string = value.map { return $0.string }.joined(separator: " \(op.rawValue) ")
        return "(\(string))"
    }
    
    init(value: [QueryToken], op: LogicalOperator = .and) {
        self.value = value
        self.op = op
    }
}
