//
//  Color.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

// Supported colors
enum Color: String {
    case white = "w"
    case blue = "u"
    case black = "b"
    case red = "r"
    case green = "g"
    case colorless = "c"
    
    static func from(string: String) throws -> Set<Color> {
        switch string.lowercased() {
        case "w":
            return [.white]
        case "u":
            return [.blue]
        case "b":
            return [.black]
        case "r":
            return [.red]
        case "g":
            return [.green]
        case "uw", "wu", "azorius":
            return [.white, .blue]
        case "wg", "gw", "selesnya":
            return [.white, .green]
        case "rg", "gr", "gruul":
            return [.green, .red]
        case "ub", "bu", "dimir":
            return [.blue, .black]
        case "wr", "rw", "boros":
            return [.red, .white]
        case "bg", "gb", "golgari":
            return [.black, .green]
        case "ur", "ru", "izzet":
            return [.blue, .red]
        case "wb", "bw", "orzhov":
            return [.white, .black]
        case "ug", "gu", "simic":
            return [.blue, .green]
        case "rb", "br", "rakdos":
            return [.black, .red]
        case "wug", "ugw", "wgu", "uwg", "gwu", "guw", "bant":
            return [.white, .blue, green]
        case "wgr", "wrg", "rwg", "rgw", "gwr", "grw", "naya":
            return [.red, .white, .green]
        case "wbu", "wub", "uwb", "uwb", "buw", "bwu", "esper":
            return [.white, .blue, .black]
        case "ubr", "urb", "rub", "rbu", "bur", "bru", "grixis":
            return [.blue, .black, .red]
        case "brg", "bgr", "rbg", "rgb", "gbr", "grb", "jund":
            return [.red, .green, .black]
        default:
            throw QueryError.unknownColorString(string)
        }
    }
}
