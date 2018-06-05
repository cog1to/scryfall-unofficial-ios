//
//  Language.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/5/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Language: String {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case japanese = "ja"
    case korean = "ko"
    case russian = "ru"
    case chineseSimplified = "zhs"
    case chineseTraditional = "zht"
    case hebrew = "he"
    case latin = "la"
    case ancientGreek = "grc"
    case arabic = "ar"
    case sanskrit = "sa"
    case phyrexian = "px"
    case any = "any"
    
    var name: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Spanish"
        case .french:
            return "French"
        case .german:
            return "German"
        case .italian:
            return "Italian"
        case .portuguese:
            return "Portuguese"
        case .japanese:
            return "Japanese"
        case .korean:
            return "Korean"
        case .russian:
            return "Russian"
        case .chineseSimplified:
            return "Simplified Chinese"
        case .chineseTraditional:
            return "Traditional Chinese"
        case .hebrew:
            return "Hebrew"
        case .latin:
            return "Latin"
        case .ancientGreek:
            return "Ancient Greek"
        case .arabic:
            return "Arabic"
        case .sanskrit:
            return "Sanskrit"
        case .phyrexian:
            return "Phyrexian"
        case .any:
            return "Any"
        }
    }
}
