//
//  PrintingsTableHeader.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/16/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class PrintingsTableHeader: UIView {
    @IBOutlet weak var headersStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor = Style.color(forKey: .navigationTint)
        titleLabel.textColor =  Style.color(forKey: .printingText)
        titleLabel.font = Style.font(forKey: .bold)
        titleLabel.text = "Prints".uppercased()
    }
    
    func configure(prices: [PriceType]) {
        headersStackView.subviews.forEach { headersStackView.removeArrangedSubview($0) }
        
        for priceType in prices {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor =  Style.color(forKey: .printingText)
            label.font = Style.font(forKey: .bold)
            label.text = priceType.abbreviation
            
            headersStackView.addArrangedSubview(label)
        }
    }
}
