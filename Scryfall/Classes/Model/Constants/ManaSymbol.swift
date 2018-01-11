//
//  ManaSymbol.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum ManaSymbol: String {
    case white = "{W}"
    case blue = "{U}"
    case black = "{B}"
    case red = "{R}"
    case green = "{G}"
    case colorless = "{C}"
    
    case x = "{X}"
    case y = "{Y}"
    case z = "{Z}"
    
    case zero = "{0}"
    case one = "{1}"
    case two = "{2}"
    case three = "{3}"
    case four = "{4}"
    case five = "{5}"
    case six = "{6}"
    case seven = "{7}"
    case eight = "{8}"
    case nine = "{9}"
    case ten = "{10}"
    case eleven = "{11}"
    case twelve = "{12}"
    case thirteen = "{13}"
    case fourteen = "{14}"
    case fifteen = "{15}"
    case sixteen = "{16}"
    case seventeen = "{17}"
    case eighteen = "{18}"
    case nineteen = "{19}"
    case twenty = "{20}"
    case hundred = "{100}"
    case million = "{1000000}"
    
    case whiteBlue = "{W/U}"
    case whiteBlack = "{W/B}"
    case blackRed = "{B/R}"
    case blackGreen = "{B/G}"
    case blueBlack = "{U/B}"
    case blueRed = "{U/R}"
    case redGreen = "{R/G}"
    case redWhite = "{R/W}"
    case greenWhite = "{G/W}"
    case greenBlue = "{G/U}"
    
    case twoOrWhite = "{2/W}"
    case twoOrRed = "{2/R}"
    case twoOrBlue = "{2/U}"
    case twoOrBlack = "{2/B}"
    case twoOrGreen = "{2/G}"
    
    case phyrexianWhite = "{W/P}"
    case phyrexianBlack = "{B/P}"
    case phyrexianBlue = "{U/P}"
    case phyrexianRed = "{R/P}"
    case phyrexianGreen = "{G/P}"
    
    case halfWhite = "{HW}"
    case halfRed = "{HR}"
    
    case half = "{½}"
}
