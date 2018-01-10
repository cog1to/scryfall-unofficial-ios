//
//  TextType.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum TextValue {
    case plain(String, Bool)
    case regexp(String)
    
    var value: String {
        switch self {
        case .plain(let text, let exact):
            return (exact ? "!" : "") + "\"\(text)\""
        case .regexp(let text):
            return "/\(text)/"
        }
    }
}
