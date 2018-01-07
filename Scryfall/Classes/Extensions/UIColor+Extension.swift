//
//  UIColor+Extension.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/7/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    /**
     * Creates UIColor instance from given RGB values.
     *
     * - parameter red: Red component value (0 to 255)
     * - parameter green: Green component value (0 to 255)
     * - parameter blue: Blue component value (0 to 255)
     */
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /**
     * Creates UIColor instance from given hex value.
     *
     * - parameter netHex: Hex value to interpret.
     */
    public convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
