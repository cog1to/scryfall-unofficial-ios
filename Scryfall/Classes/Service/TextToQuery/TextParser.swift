//
//  TextParser.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 4/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class TextParser: TextParserType {
    func tokenize(string: String) -> [TextParserToken] {
        let words = string.components(separatedBy: CharacterSet.whitespaces)
        
        let tokens = words.map { token -> TextParserToken in
            let lowercasedToken = token.lowercased()
            
            switch lowercasedToken {
            case "white", "blue", "black", "red", "green", "colorless":
                return .color(Color(rawValue: lowercasedToken)!)
            case "and", "or":
                return .logical(LogicalOperator(rawValue: lowercasedToken)!)
            default:
                return .unknown(lowercasedToken)
            }
        }
        
        return tokens
    }
}
