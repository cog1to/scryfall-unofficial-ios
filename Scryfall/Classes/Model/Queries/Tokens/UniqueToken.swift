//
//  UniqueToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/3/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class UniqueToken: StringEnumToken<Unique> {
    override func name() throws -> String {
        return "unique"
    }
}
