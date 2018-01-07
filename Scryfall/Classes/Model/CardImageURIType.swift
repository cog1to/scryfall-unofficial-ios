//
//  CardImage.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum CardImageURIType {
    case small
    case normal
    case large
    case png
    case artCrop
    case borderCrop
    
    init?(value: String) {
        switch value.lowercased() {
        case "small":
            self = .small
        case "normal":
            self = .normal
        case "large":
            self = .large
        case "png":
            self = .png
        case "art_crop":
            self = .artCrop
        case "border_crop":
            self = .borderCrop
        default:
            return nil
        }
    }
}
