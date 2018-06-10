//
//  RulingsView.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class RulingsView: UIView {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        textLabel.font = Style.font(forKey: .text)
        textLabel.textColor = Style.color(forKey: .text)
        
        dateLabel.font = Style.font(forKey: .text)
        dateLabel.textColor = Style.color(forKey: .gray)
    }
    
    func configure(for ruling: CardRuling) {
        textLabel.text = ruling.comment
        
        if let date = ruling.publishedAt {
            let attributes = [
                NSAttributedStringKey.foregroundColor : Style.color(forKey: .gray),
                NSAttributedStringKey.font: Style.font(forKey: .text).italics()
            ]
            dateLabel.attributedText = NSAttributedString(string: "(\(DateFormat.displayString(from: date)))", attributes: attributes)
        } else {
            dateLabel.text = nil;
        }
    }
}
