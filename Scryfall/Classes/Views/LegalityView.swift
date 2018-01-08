//
//  LegalityView.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/8/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class LegalityView: UIStackView {
    @IBOutlet weak var legalityContainer: UIView!
    @IBOutlet weak var legalityLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    
    override func awakeFromNib() {
        legalityContainer.backgroundColor = Style.color(forKey: .notLegal)
        legalityContainer.layer.cornerRadius = 5
        
        legalityLabel.textColor = UIColor.white
        legalityLabel.font = Style.font(forKey: .legality)
        legalityLabel.textAlignment = .center
        
        formatLabel.textColor = Style.color(forKey: .text)
        formatLabel.font = Style.font(forKey: .subtext)
    }
    
    func configure(format: Format, legality: Legality) {
        formatLabel.text = format.name
        legalityLabel.text = legality.title.uppercased()
        legalityContainer.backgroundColor = legality.color
        layoutIfNeeded()
    }
}
