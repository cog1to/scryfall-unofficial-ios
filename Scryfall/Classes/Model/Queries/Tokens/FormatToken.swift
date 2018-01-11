//
//  FormatToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class FormatToken: StringEnumToken<Format> {
    override func name() throws -> String {
        return "format"
    }
}
