//
//  StringEnumToken.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class StringEnumToken<T: RawRepresentable>: EqualityToken<T> where T.RawValue == String {
    override func valueString() throws -> String {
        return value.rawValue
    }
}
