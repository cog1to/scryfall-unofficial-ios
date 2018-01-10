//
//  WatermarkToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class WatermarkToken: QueryToken {
    var negative: Bool
    var value: Watermark
    
    override var string: String {
        return (negative ? "-" : "") + "wm:\(value.rawValue)"
    }
    
    init(value: Watermark, negative: Bool = false) throws {
        self.value = value
        self.negative = negative
    }
}
