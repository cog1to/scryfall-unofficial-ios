//
//  Watermark.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum Watermark: String {
    case abzan = "abzan"
    case agentsofsneak = "agentsofsneak"
    case arena = "arena"
    case atarka = "atarka"
    case azorius = "azorius"
    case boros = "boros"
    case colorpie = "colorpie"
    case conspiracy = "conspiracy"
    case crossbreedlabs = "crossbreedlabs"
    case dci = "dci"
    case dnd = "d&d"
    case dimir = "dimir"
    case dromoka = "dromoka"
    case fnm = "fnm"
    case goblinexplosioneers = "goblinexplosioneers"
    case golgari = "golgari"
    case grandprix = "grandprix"
    case gruul = "gruul"
    case izzet = "izzet"
    case jeskai = "jeskai"
    case junior = "junior"
    case juniorapac = "juniorapac"
    case junioreurope = "junioreurope"
    case kolaghan = "kolaghan"
    case leagueofdastardlydoom = "leagueofdastardlydoom"
    case mardu = "mardu"
    case mirran = "mirran"
    case mps = "mps"
    case mtg = "mtg"
    case mtg10 = "mtg10"
    case mtg15 = "mtg15"
    case nerf = "nerf"
    case ojutai = "ojutai"
    case orderofthewidget = "orderofthewidget"
    case orzhov = "orzhov"
    case phyrexian = "phyrexian"
    case planeswalker = "planeswalker"
    case protour = "protour"
    case rakdos = "rakdos"
    case scholarship = "scholarship"
    case selesnya = "selesnya"
    case set = "set"
    case silumgar = "silumgar"
    case simic = "simic"
    case sultai = "sultai"
    case temur = "temur"
    case transformers = "transformers"
    case wotc = "wotc"
    case wpn = "wpn"
    
    var name: String {
        switch self {
        case .set:
            return "Set Symbol"
        case .abzan:
            return "Abzan"
        case .agentsofsneak:
            return "Agents of S.N.E.A.K."
        case .arena:
            return "Arena"
        case .atarka:
            return "Atarka"
        case .azorius:
            return "Azorius"
        case .boros:
            return "Boros"
        case .colorpie:
            return "Color pie"
        case .conspiracy:
            return "Conspiracy"
        case .crossbreedlabs:
            return "Crossbreed Labs"
        case .dci:
            return "DCI"
        case .dimir:
            return "Dimir"
        case .dromoka:
            return "Dromoka"
        case .dnd:
            return "D&D"
        case .fnm:
            return "Friday Night Magic"
        case .goblinexplosioneers:
            return "Goblin Explosioneers"
        case .golgari:
            return "Golgari"
        case .gruul:
            return "Gruul"
        case .grandprix:
            return "Grandprix"
        case .izzet:
            return "Izeet"
        case .jeskai:
            return "Jeskai"
        case .junior:
            return "Junior Series"
        case .juniorapac:
            return "Junior Series APAC"
        case .junioreurope:
            return "Junior Series Europe"
        case .kolaghan:
            return "Kolaghan"
        case .leagueofdastardlydoom:
            return "League of Dastardly Doom"
        case .mps:
            return "MPS"
        case .mtg:
            return "Magic: The Gathering"
        case .mardu:
            return "Mardu"
        case .mtg10:
            return "Magic 10th Anniversary"
        case .mtg15:
            return "Magic 15th Anniversary"
        case .mirran:
            return "Mirran"
        case .nerf:
            return "Nerf"
        case .orzhov:
            return "Orzhov"
        case .ojutai:
            return "Ojutai"
        case .orderofthewidget:
            return "Order of the Widget"
        case .phyrexian:
            return "Phyrexian"
        case .planeswalker:
            return "Planeswalker"
        case .protour:
            return "Pro Tour"
        case .rakdos:
            return "Rakdos"
        case .simic:
            return "Simic"
        case .sultai:
            return "Sultai"
        case .selesnya:
            return "Selesnya"
        case .silumgar:
            return "Silumgar"
        case .scholarship:
            return "Scholarship Series"
        case .temur:
            return "Temur"
        case .transformers:
            return "Transformers"
        case .wpn:
            return "Wizards Play Network"
        case .wotc:
            return "Wizards of the Coast"
        }
    }
}
