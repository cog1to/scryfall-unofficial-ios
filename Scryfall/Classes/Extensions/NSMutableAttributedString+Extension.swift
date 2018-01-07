//
//  NSMutableAttributedString+Extension.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/7/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    /**
     * Replaces mana and other magic symbols in receiver with images.
     */
    func replaceSymbols() {
        self.beginEditing()
        
        let string = self.string
        let regex = try! NSRegularExpression(pattern: "\\{(W|U|B|R|G|T|C|Q|S|E|PW|CHAOS|X|Y|Z|0|½|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|100|1000000|∞|W/U|W/B|B/R|B/G|U/B|U/R|R/G|R/W|G/W|G/U|2/W|2/U|2/B|2/R|2/G|P|W/P|U/P|B/P|R/P|G/P|HW|HR)\\}", options: [])
        let matches = regex.matches(in: string, options: [], range: NSRange.init(location: 0, length: string.count))
        matches.reversed().forEach { result in
            let symbol = (string as NSString).substring(with: result.range)
            if let attachment = textAttachment(forSymbol: symbol) {
                self.replaceCharacters(in: result.range, with: attachment)
            }
        }
        
        self.endEditing()
    }
    
    /**
     * Returns an attributed string with image text attachment for given coded symbol string.
     *
     * - parameter symbol: Coded symbol string, like {1} or {W/B}
     * - returns: Attributed string with appropriate image if given symbol string is recongnized,
     *     nil otherwise
     */
    private func textAttachment(forSymbol symbol: String) -> NSAttributedString? {
        let textAttachment = NSTextAttachment()
        
        switch symbol {
        case "{T}":
            textAttachment.image = UIImage(named: "card-symbol-T")
        case "{W}":
            textAttachment.image = UIImage(named: "card-symbol-W")
        case "{U}":
            textAttachment.image = UIImage(named: "card-symbol-U")
        case "{B}":
            textAttachment.image = UIImage(named: "card-symbol-B")
        case "{R}":
            textAttachment.image = UIImage(named: "card-symbol-R")
        case "{G}":
            textAttachment.image = UIImage(named: "card-symbol-G")
        case "{C}":
            textAttachment.image = UIImage(named: "card-symbol-C")
        case "{Q}":
            textAttachment.image = UIImage(named: "card-symbol-Q")
        case "{E}":
            textAttachment.image = UIImage(named: "card-symbol-E")
        case "{PW}":
            textAttachment.image = UIImage(named: "card-symbol-PW")
        case "{CHAOS}":
            textAttachment.image = UIImage(named: "card-symbol-CHAOS")
        case "{X}":
            textAttachment.image = UIImage(named: "card-symbol-X")
        case "{Y}":
            textAttachment.image = UIImage(named: "card-symbol-Y")
        case "{Z}":
            textAttachment.image = UIImage(named: "card-symbol-Z")
        case "{1}":
            textAttachment.image = UIImage(named: "card-symbol-1")
        case "{0}":
            textAttachment.image = UIImage(named: "card-symbol-0")
        case "{½}":
            textAttachment.image = UIImage(named: "card-symbol-HALF")
        case "{2}":
            textAttachment.image = UIImage(named: "card-symbol-2")
        case "{3}":
            textAttachment.image = UIImage(named: "card-symbol-3")
        case "{4}":
            textAttachment.image = UIImage(named: "card-symbol-4")
        case "{5}":
            textAttachment.image = UIImage(named: "card-symbol-5")
        case "{6}":
            textAttachment.image = UIImage(named: "card-symbol-6")
        case "{7}":
            textAttachment.image = UIImage(named: "card-symbol-7")
        case "{8}":
            textAttachment.image = UIImage(named: "card-symbol-8")
        case "{9}":
            textAttachment.image = UIImage(named: "card-symbol-9")
        case "{10}":
            textAttachment.image = UIImage(named: "card-symbol-10")
        case "{11}":
            textAttachment.image = UIImage(named: "card-symbol-11")
        case "{12}":
            textAttachment.image = UIImage(named: "card-symbol-12")
        case "{13}":
            textAttachment.image = UIImage(named: "card-symbol-13")
        case "{14}":
            textAttachment.image = UIImage(named: "card-symbol-14")
        case "{15}":
            textAttachment.image = UIImage(named: "card-symbol-15")
        case "{16}":
            textAttachment.image = UIImage(named: "card-symbol-16")
        case "{17}":
            textAttachment.image = UIImage(named: "card-symbol-17")
        case "{18}":
            textAttachment.image = UIImage(named: "card-symbol-18")
        case "{19}":
            textAttachment.image = UIImage(named: "card-symbol-19")
        case "{20}":
            textAttachment.image = UIImage(named: "card-symbol-20")
        case "{100}":
            textAttachment.image = UIImage(named: "card-symbol-100")
        case "{1000000}":
            textAttachment.image = UIImage(named: "card-symbol-1000000")
        case "{∞}":
            textAttachment.image = UIImage(named: "card-symbol-INFINITY")
        case "{W/U}":
            textAttachment.image = UIImage(named: "card-symbol-WU")
        case "{W/B}":
            textAttachment.image = UIImage(named: "card-symbol-WB")
        case "{B/R}":
            textAttachment.image = UIImage(named: "card-symbol-BR")
        case "{B/G}":
            textAttachment.image = UIImage(named: "card-symbol-BG")
        case "{U/R}":
            textAttachment.image = UIImage(named: "card-symbol-UR")
        case "{U/B}":
            textAttachment.image = UIImage(named: "card-symbol-UB")
        case "{R/G}":
            textAttachment.image = UIImage(named: "card-symbol-RG")
        case "{R/W}":
            textAttachment.image = UIImage(named: "card-symbol-RW")
        case "{G/W}":
            textAttachment.image = UIImage(named: "card-symbol-GW")
        case "{G/U}":
            textAttachment.image = UIImage(named: "card-symbol-GU")
        case "{2/W}":
            textAttachment.image = UIImage(named: "card-symbol-2W")
        case "{2/U}":
            textAttachment.image = UIImage(named: "card-symbol-2U")
        case "{2/B}":
            textAttachment.image = UIImage(named: "card-symbol-2B")
        case "{2/R}":
            textAttachment.image = UIImage(named: "card-symbol-2R")
        case "{2/G}":
            textAttachment.image = UIImage(named: "card-symbol-2G")
        case "{P}":
            textAttachment.image = UIImage(named: "card-symbol-P")
        case "{W/P}":
            textAttachment.image = UIImage(named: "card-symbol-WB")
        case "{U/P}":
            textAttachment.image = UIImage(named: "card-symbol-UP")
        case "{B/P}":
            textAttachment.image = UIImage(named: "card-symbol-BP")
        case "{R/P}":
            textAttachment.image = UIImage(named: "card-symbol-RP")
        case "{G/P}":
            textAttachment.image = UIImage(named: "card-symbol-GP")
        case "{HW}":
            textAttachment.image = UIImage(named: "card-symbol-HW")
        case "{HR}":
            textAttachment.image = UIImage(named: "card-symbol-HR")
        case "{S}":
            textAttachment.image = UIImage(named: "card-symbol-S")
        default:
            return nil
        }
        
        return NSAttributedString(attachment: textAttachment)
    }
}
