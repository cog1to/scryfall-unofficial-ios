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
        case bold
        case italic
        case subtext
        case headline
    }
    
    enum ColorKey {
        case link
    }
    
    class func color(forKey key: ColorKey) -> UIColor {
        switch key {
        case .link:
            return UIColor(netHex: 0x421A81)
        }
    }
    
    class func font(forKey key: FontKey) -> UIFont {
        switch key {
        case .text:
            return UIFont.preferredFont(forTextStyle: .body)
        case .bold:
            return font(fromTextStyle: .body, withTraits: .traitBold)
        case .italic:
            return font(fromTextStyle: .body, withTraits: .traitItalic)
        case .subtext:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .headline:
            return font(fromTextStyle: .title2, withTraits: .traitBold)
        }
    }
    
    static private var fontCache: [FontKey: UIFont] = [:]
    
    private class func font(fromTextStyle style: UIFontTextStyle, withTraits traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let size = descriptor.pointSize
        
        var newTrait = descriptor.symbolicTraits
        newTrait.insert(traits)
        
        let attributes = [UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.AttributeName.symbolic: newTrait.rawValue]]
        let newDescriptor = descriptor.addingAttributes(attributes)
        
        return UIFont.init(descriptor: newDescriptor, size: size)
    }
}
