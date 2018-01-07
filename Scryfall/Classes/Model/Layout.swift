//
//  CardLayout.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Layout {
    case normal
    case transform
    case flip
    case split
    
    var name: String {
        get {
            switch self {
            case .normal:
                return "Normal"
            case .transform:
                return "Transform"
            case .flip:
                return "Flip"
            case .split:
                return "Split"
            }
        }
    }
    
    init?(value: String) {
        switch value.lowercased() {
        case "normal":
            self = .normal
        case "flip":
            self = .flip
        case "transform":
            self = .transform
        case "split":
            self = .split
        default:
            return nil
        }
    }
}
