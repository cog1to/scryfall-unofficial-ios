//
//  SetSortOrder.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/28/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum SetSortOrder: String, StringRepresentableOption {
    case releaseDate = "date"
    case blockOrGroup = "block"
    case name = "set"
    case cards = "cards"
    
    var name: String {
        switch self {
        case .releaseDate:
            return "Release Date"
        case .blockOrGroup:
            return "Block/Group"
        case .name:
            return "Name"
        case .cards:
            return "Cards"
        }
    }
    
    static var all: [SetSortOrder] = [.releaseDate, .name, .blockOrGroup, .cards]
}
