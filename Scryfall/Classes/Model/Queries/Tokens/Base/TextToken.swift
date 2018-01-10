//
//  TextToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class TextToken: EqualityToken<TextValue> {
    override func valueString() throws -> String {
        switch value {
        case .plain(let string):
            return "\"\(string)\""
        case .regexp(let string):
            return "/\(string)/"
        }
    }
}
