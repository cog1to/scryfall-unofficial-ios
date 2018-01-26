//
//  PrintingsTable.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/16/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import RxGesture

/**
 * Printings table custom view.
 */
class PrintingsTable: UIView {
    
    private let maxPrints = 5
    
    private var stackView: UIStackView!
    private var disposeBag = DisposeBag()
    
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
    
    func configure(cards: [Card], selected: Card, action: Action<Card, Void>, allPrintsAction: CocoaAction) {
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
        if let index = cards.index(where: { card -> Bool in return card.ID == selected.ID }) {
            let window = ((maxPrints - 1) / 2)
            var start = max(0, index - window)
            var end = min(cards.count, index + window + 1)
            
            if index == 0 {
                end = min(cards.count, index + maxPrints)
            }
            
            if index == cards.count - 1 {
                start = max(0, index - maxPrints + 1)
            }
            
            let slice = cards[start..<end]
            
            for card in slice {
                if let rowView = Bundle.main.loadNibNamed("PrintingsTableRow", owner: nil, options: nil)!.first as? PrintingsTableRow {
                    rowView.configure(card: card, selected: card.ID == selected.ID)
                    
                    stackView.addArrangedSubview(rowView)
                    stackView.addConstraint(NSLayoutConstraint(item: rowView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1.0, constant: -(2.0*1.0/UIScreen.main.scale)))
                    
                    for (idx, view) in rowView.pricesStackView.subviews.enumerated() {
                        addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: headerLabels[idx], attribute: .width, multiplier: 1.0, constant: 0.0))
                    }
                    
                    rowView.rx.tapGesture().when(.recognized).map({ _ in return card }).bind(to: action.inputs).disposed(by: disposeBag)
                }
            }
        }
        
        // Put 'all prints' link if there are too many prints
        if cards.count > maxPrints {
            if let linkView = Bundle.main.loadNibNamed("PrintingsTableFooter", owner: nil, options: nil)!.first as? PrintingsTableFooter {
                linkView.title = "View all \(cards.count) prints →"
                
                stackView.addArrangedSubview(linkView)
                stackView.addConstraint(NSLayoutConstraint(item: linkView, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1.0, constant: -(2.0*1.0/UIScreen.main.scale)))
                
                linkView.rx.tapGesture().when(.recognized).map({_ in return ()}).bind(to: allPrintsAction.inputs).disposed(by: disposeBag)
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
