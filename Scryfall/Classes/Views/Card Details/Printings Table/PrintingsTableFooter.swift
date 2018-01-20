//
//  PrintingsTableFooter.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/19/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class PrintingsTableFooter: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        titleLabel.font = Style.font(forKey: .subtext)
        titleLabel.textColor = Style.color(forKey: .text)
    }
}
