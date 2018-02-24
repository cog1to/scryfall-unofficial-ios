//
//  DisplayMode.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 2/16/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum DisplayMode: String {
    case cards = "cards"
    case images = "images"
    
    var name: String {
        switch self {
        case .cards:
            return "Cards"
        case .images:
            return "Images"
        }
    }
    
    static var all: [DisplayMode] = [.cards, .images]
}
