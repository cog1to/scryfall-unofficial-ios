//
//  LanguageToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/5/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class LanguageToken: StringEnumToken<Language> {
    override func name() throws -> String {
        return "lang"
    }
}
