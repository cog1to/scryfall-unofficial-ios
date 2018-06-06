//
//  UIFont+Extension.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    func withTraits(_ traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        if let fd = fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: fd, size: pointSize)
        }

        return self
    }
    
    func italics() -> UIFont {
        return withTraits(.traitItalic)
    }
    
    func bold() -> UIFont {
        return withTraits(.traitBold)
    }
    
    func boldItalics() -> UIFont {
        return withTraits([ .traitBold, .traitItalic ])
    }
}
