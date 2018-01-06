//
//  Style.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class Style {
    enum FontKey {
        case text
        case subtext
    }
    
    static private var fontCache: [FontKey: UIFont] = [:]
    
    class func font(forKey key: FontKey) -> UIFont {
        switch key {
        case .text:
            return UIFont.preferredFont(forTextStyle: .body)
        case .subtext:
            return UIFont.preferredFont(forTextStyle: .footnote)
        }
    }
}
