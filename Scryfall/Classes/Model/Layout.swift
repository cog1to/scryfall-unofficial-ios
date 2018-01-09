//
//  CardLayout.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Layout: String {
    case normal = "normal"
    case transform = "transform"
    case flip = "flip"
    case split = "split"
    
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
}
