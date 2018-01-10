//
//  ArtistToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class ArtistToken: QueryToken {
    var negative: Bool
    var value: String
    
    override var string: String {
        return (negative ? "-" : "") + "a:\"\(value)\""
    }
    
    init(value: String, negative: Bool = false) throws {
        self.value = value
        self.negative = negative
    }
}
