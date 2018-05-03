//
//  TextToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 4/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum TextParserToken {
    case color(Color)
    case unknown(String)
    case logical(LogicalOperator)
}
