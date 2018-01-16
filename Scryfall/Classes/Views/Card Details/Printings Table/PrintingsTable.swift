//
//  PrintingsTable.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/16/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import UIKit

/**
 * Printings table custom view.
 */
class PrintingsTable: UIView {
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = Style.color(forKey: .gray)
        
        stackView = UIStackView(frame: self.frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 1.0/UIScreen.main.scale
        addSubview(stackView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics: nil, views: ["stackView": stackView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: ["stackView": stackView]))
    }
    
    func configure(cards: [Card], selected: Card) {
        stackView.subviews.forEach { stackView.removeArrangedSubview($0) }
        
        guard cards.count > 0 else {
            return
        }
        
        // Header
        var headerLabels = [UIView]()
        if let headerView = Bundle.main.loadNibNamed("PrintingsTableHeader", owner: nil, options: nil)!.first as? PrintingsTableHeader {
            headerView.configure(prices: [.usd, .eur, .tix])
            headerLabels = headerView.headersStackView.subviews
            
            stackView.addArrangedSubview(headerView)
            stackView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1.0, constant: 0))
        }
        
        // Printings
        for card in cards {
            if let rowView = Bundle.main.loadNibNamed("PrintingsTableRow", owner: nil, options: nil)!.first as? PrintingsTableRow {
                rowView.configure(card: card, selected: card.ID == selected.ID)
                stackView.addArrangedSubview(rowView)
                stackView.addConstraint(NSLayoutConstraint(item: rowView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1.0, constant: -(2.0*1.0/UIScreen.main.scale)))
                
                for (idx, view) in rowView.pricesStackView.subviews.enumerated() {
                    addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: headerLabels[idx], attribute: .width, multiplier: 1.0, constant: 0.0))
                }
            }
        }
        
        // Footer
        let footer = UIView()
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.backgroundColor = Style.color(forKey: .navigationTint)
        stackView.addArrangedSubview(footer)
        stackView.addConstraint(NSLayoutConstraint(item: footer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2.0))
        stackView.addConstraint(NSLayoutConstraint(item: footer, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
}
