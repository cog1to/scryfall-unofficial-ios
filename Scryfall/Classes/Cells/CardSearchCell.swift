//
//  CardSearchCell.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

/**
 * Card search result cell.
 */
class CardSearchCell: UITableViewCell {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardSetLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    
    override func awakeFromNib() {
        cardNameLabel.font = Style.font(forKey: .text)
        cardSetLabel.font = Style.font(forKey: .text)
        typeLabel.font = Style.font(forKey: .subtext)
        rarityLabel.font = Style.font(forKey: .subtext)
    }
    
    override func prepareForReuse() {
        cardNameLabel.text = nil
        cardSetLabel.text = nil
        typeLabel.text = nil
        rarityLabel.text = nil
    }
    
    func configure(for card: Card) {
        cardNameLabel.text = card.name
        cardSetLabel.text = card.setCode.uppercased()
        rarityLabel.text = card.rarity.name
        
        // If type line is empty for the card, try to get if from first card face if possible.
        if card.typeLine.count > 0 {
            typeLabel.text = card.typeLine
        } else if let faces = card.faces, let firstFace = faces.first, firstFace.typeLine.count > 0 {
            typeLabel.text = firstFace.typeLine
        } else {
            typeLabel.text = nil
        }
    }
}
