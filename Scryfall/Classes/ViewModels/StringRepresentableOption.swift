//
//  StringRepresentable.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/28/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

protocol StringRepresentableOption {
    var name: String { get }
    static var all: [Self] { get }
}
