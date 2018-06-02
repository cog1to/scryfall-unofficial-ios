//
//  CardSetType.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum CardSetType: String, StringRepresentableOption {
    case core = "core"
    case expansion = "expansion"
    case masters = "masters"
    case masterpiece = "masterpiece"
    case fromTheVault = "from_the_vault"
    case premiumDeck = "premium_deck"
    case duelDeck = "duel_deck"
    case commander = "commander"
    case planechase = "planechase"
    case conspiracy = "conspiracy"
    case archenemy = "archenemy"
    case vanguard = "vanguard"
    case funny = "funny"
    case starter = "starter"
    case box = "box"
    case promo = "promo"
    case token = "token"
    case memorabilia = "memorabilia"
    case spellbook = "spellbook"
    case treasureChest = "treasure_chest"
    case cube = "cube"
    case draftInnovation = "draft_innovation"
    case any = "any"
    
    var name: String {
        switch self {
        case .core:
            return "Core"
        case .expansion:
            return "Expansion"
        case .masters:
            return "Masters"
        case .masterpiece:
            return "Masterpiece"
        case .fromTheVault:
            return "From The Vault"
        case .premiumDeck:
            return "Premium Deck"
        case .duelDeck:
            return "Duel deck"
        case .commander:
            return "Commander"
        case .planechase:
            return "Planechase"
        case .archenemy:
            return "Archenemy"
        case .funny:
            return "Funny"
        case .box:
            return "Box"
        case .promo:
            return "Promo"
        case .token:
            return "Token"
        case .cube:
            return "Cube"
        case .treasureChest:
            return "Treasure Chest"
        case .memorabilia:
            return "Memorabilia"
        case .spellbook:
            return "Spellbook"
        case .starter:
            return "Starter"
        case .conspiracy:
            return "Conspiracy"
        case .vanguard:
            return "Vanguard"
        case .draftInnovation:
            return "Draft Innovation"
        case .any:
            return "Any"
        }
    }
    
    static var all: [CardSetType] = [.any, .cube, .archenemy, .box, .commander, .conspiracy, .core, .duelDeck, .draftInnovation, .expansion, .fromTheVault, .funny, .masterpiece, .masters, .memorabilia, .planechase, .premiumDeck, .promo, .spellbook, .starter, .token, .treasureChest, .vanguard]
}
