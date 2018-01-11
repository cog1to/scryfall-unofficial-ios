//
//  LayoutToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class LayoutToken: StringEnumToken<Layout> {
    override func name() throws -> String {
        return "layout"
    }
}
