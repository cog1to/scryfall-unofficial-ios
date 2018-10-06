//
//  OptionalString+Extension.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 10/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var isNullOrEmpty: Bool {
        return (self == nil) || self!.isEmpty
    }
}
