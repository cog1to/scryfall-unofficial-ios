//
//  PrintingsTableRow.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/16/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class PrintingsTableRow: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rarityIcon: UIImageView!
    @IBOutlet weak var pricesStackView: UIStackView!
    
    override func awakeFromNib() {
        rarityIcon.layer.cornerRadius = rarityIcon.frame.size.height / 2.0
        rarityIcon.layer.borderWidth = 1.0/UIScreen.main.scale
        rarityIcon.layer.borderColor = Style.color(forKey: .gray).cgColor
        rarityIcon.backgroundColor = UIColor.white
    }
    
    func configure(card: Card, selected: Bool) {
        pricesStackView.subviews.forEach { pricesStackView.removeArrangedSubview($0) }
        
        rarityIcon.tintColor = card.rarity.color
        
        // Title label.
        titleLabel.textColor =  Style.color(forKey: .text)
        titleLabel.font = Style.font(forKey: .subtext)
        titleLabel.text = card.setName
        
        // Values labels.
        pricesStackView.translatesAutoresizingMaskIntoConstraints = false
        pricesStackView.axis = .horizontal
        pricesStackView.distribution = .equalSpacing
        pricesStackView.alignment = .center
        pricesStackView.spacing = 8
        
        let prices: [Price] = [Price(type: .usd, value: card.priceUSD),
                               Price(type: .eur, value: card.priceEUR),
                               Price(type: .tix, value: card.priceTIX)]
        for price in prices {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor =  Style.color(forKey: .text)
            label.font = Style.font(forKey: .subtext)
            label.setContentCompressionResistancePriority(UILayoutPriority.init(1000), for: .horizontal)
            
            if let priceValue = price.value {
                label.text = "\(price.type.symbol)\(priceValue)"
            } else {
                label.text = ""
            }
            
            pricesStackView.addArrangedSubview(label)
        }
        
        backgroundColor = selected
            ? Style.color(forKey: .selectedPrinting)
            : UIColor.white
    }
}
