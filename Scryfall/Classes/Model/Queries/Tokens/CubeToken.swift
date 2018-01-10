//
//  CubeToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class CubeToken: QueryToken {
    var value: Cube
    var negative: Bool

    override var string: String {
        return (negative ? "-" : "") + "cube:\(value)"
    }
    
    init(value: Cube, negative: Bool = false) {
        self.value = value
        self.negative = negative
    }
}
