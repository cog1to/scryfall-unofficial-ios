//
//  TextType.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum TextValue {
    case plain(String)
    case regexp(String)
    
    var value: String {
        switch self {
        case .plain(let text):
            return "\"\(text)\""
        case .regexp(let text):
            return "/\(text)/"
        }
    }
}
