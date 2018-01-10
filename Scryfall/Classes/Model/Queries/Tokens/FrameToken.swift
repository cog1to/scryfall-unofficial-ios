//
//  FrameToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class FrameToken: QueryToken {
    var negative: Bool
    var value: Frame
    
    override var string: String {
        return (negative ? "-" : "") + "frame:\(value.rawValue)"
    }
    
    init(value: Frame, negative: Bool = false) throws {
        self.value = value
        self.negative = negative
    }
}
