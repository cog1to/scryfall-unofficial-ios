//
//  Trait.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Trait: String {
    case hasHybridMana = "hybrid"
    case spitCard = "split"
    case flipCard = "flip"
    case transformCard = "transform"
    case meldCard = "meld"
    case levelerCard = "leveler"
    case spell = "spell"
    case permanent = "permanent"
    case vanilla = "vanilla"
    case hasETBEffect = "etb"
    case funny = "funny"
    case reprint = "reprint"
    case unique = "unique"
    case canBeACommander = "commander"
    case inReservedList = "reserved"
    case hasHiResScan = "hires"
    case promo = "promo"
    case spotlight = "spotlight"
    case bikeland = "bikeland"
    case bounceland = "bounceland"
    case checkland = "checkland"
    case dualland = "dual"
    case fastland = "fastland"
    case fetchland = "fetchland"
    case filterland = "filterland"
    case gainland = "gainland"
    case painland = "painland"
    case scryland = "scryland"
    case shadowland = "shadowland"
    case shockland = "shockland"
    case storageland = "storageland"
    case tangoland = "tangoland"
    case colorshifted = "colorshifted"
    case timeshifted = "timeshifted"
    case masterpiece = "masterpiece"
    case hasWatermark = "watermark"
    case new = "new"
    case old = "old"
    case modern = "modern"
    case future = "future"
    case fullart = "full"
}
