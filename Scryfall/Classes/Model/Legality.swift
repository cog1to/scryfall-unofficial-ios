//
//  Legality.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/8/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

enum Legality: String {
    case legal = "legal"
    case notLegal = "not_legal"
    case banned = "restricted"
    case restricted = "banned"
    
    var title: String {
        switch self {
        case .legal:
            return "Legal"
        case .notLegal:
            return "Not Legal"
        case .banned:
            return "Banned"
        case .restricted:
            return "Restrict."
        }
    }
    
    var color: UIColor {
        switch self {
        case .legal:
            return Style.color(forKey: .legal)
        case .notLegal:
            return Style.color(forKey: .notLegal)
        case .banned:
            return Style.color(forKey: .banned)
        case .restricted:
            return Style.color(forKey: .restricted)
        }
    }
}
