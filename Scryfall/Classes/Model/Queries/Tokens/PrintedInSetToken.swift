//
//  PrintedInSetToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class PrintedInSetToken: EqualityToken<MTGSet> {
    override func name() throws -> String {
        return "set:"
    }
    
    override func valueString() throws -> String {
        return value.rawValue
    }
}
