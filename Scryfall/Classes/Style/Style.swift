//
//  Style.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

/**
 * Provides various fonts and colors used in application.
 */
class Style {
    
    /// Supported fonts
    enum FontKey {
        
        /// Common text (for card oracle text)
        case text
        
        /// Common bold text (power/toughness, loyalty, etc.)
        case bold
        
        /// Common italic text (flavor text, reminder text, etc.)
        case italic
        
        /// Common supplementary text (artist, watermark, reserverd info, etc.)
        case subtext
        
        /// Font for legality plaques
        case legality
        
        /// Common title text (card names)
        case headline
    }
    
    /// Supported colors
    enum ColorKey {
        
        /// Text color.
        case text
        
        /// Clickable link color
        case link
        
        /// Legal plaque background
        case legal
        
        /// Not Legal plaque background
        case notLegal
        
        /// Banned plaque background
        case banned
        
        /// Restricted plaque background
        case restricted
        
        /// Common gray color (borders, separators, etc.)
        case gray
        
        /// Common tint color
        case tint
        
        /// Navigation bar tint
        case navigationTint
        
        /// View background color
        case background
        
        /// Card details view background color
        case detailsBackground
    }
    
    /**
     * Returns color for given color key.
     *
     * - parameter key: Color key value
     * - returns: UIColor for given color key
     */
    class func color(forKey key: ColorKey) -> UIColor {
        switch key {
        case .text:
            return UIColor(netHex: 0x15151C)
        case .link:
            return UIColor(netHex: 0x421A81)
        case .legal:
            return UIColor(netHex: 0x719369)
        case .notLegal:
            return UIColor(netHex: 0xABABAB)
        case .banned:
            return UIColor(netHex: 0xBD757B)
        case .restricted:
            return UIColor(netHex: 0x6C8C99)
        case .tint:
            return UIColor(netHex: 0x421A81)
        case .navigationTint:
            return UIColor(netHex: 0x2B263A)
        case .gray:
            return UIColor.lightGray
        case .background:
            return UIColor(netHex: 0xF5F6FA)
        case .detailsBackground:
            return UIColor(netHex: 0xF9F9F9)
        }
    }
    
    /**
     * Returns font for given font key.
     *
     * - parameter key: Font key value
     * - returns: UIFont for given font key
     */
    class func font(forKey key: FontKey) -> UIFont {
        if let font = fontCache[key] {
            return font
        }
        
        var font: UIFont! = nil
        switch key {
        case .text:
            font = UIFont.preferredFont(forTextStyle: .body)
        case .bold:
            font = getFont(fromTextStyle: .body, withTraits: .traitBold)
        case .italic:
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            let size = descriptor.pointSize
            return UIFont(name: "TimesNewRomanPS-ItalicMT", size: size)!
        case .subtext:
            font = UIFont.preferredFont(forTextStyle: .footnote)
        case .headline:
            font = getFont(fromTextStyle: .title2, withTraits: .traitBold)
        case .legality:
            return UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote).withSymbolicTraits(.traitBold)!, size: 10.0)
        }
        
        fontCache[key] = font
        return font
    }
    
    /// Font cache.
    static private var fontCache: [FontKey: UIFont] = [:]
    
    /**
     * Produces font from given text style and additional traits.
     *
     * - parameter style: Base font style
     * - parameter traits: Additional symbolic traits to apply to the font
     * - returns: New font satisfying the provided critera
     */
    private class func getFont(fromTextStyle style: UIFontTextStyle, withTraits traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        var descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        
        var newTrait = descriptor.symbolicTraits
        newTrait.insert(traits)
        descriptor = descriptor.withSymbolicTraits(newTrait)!
        
        return UIFont(descriptor: descriptor, size: descriptor.pointSize)
    }
}
