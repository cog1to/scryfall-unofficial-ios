//
//  TextParserType.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 4/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

protocol TextParserType {
    func tokenize(string: String) -> [TextParserToken]
}
