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

        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(cardsList: CardsList, selected: Card, action: Action<Card, Void>, allPrintsAction: CocoaAction) {
        stackView.subviews.forEach { stackView.removeArrangedSubview($0) }
        
        guard cardsList.data.count > 0 else {
            return
        }

        // Header
        var headerLabels = [UIView]()
        if let headerView = Bundle.main.loadNibNamed("PrintingsTableHeader", owner: nil, options: nil)!.first as? PrintingsTableHeader {
            headerView.configure(prices: [.usd, .eur, .tix])
            headerLabels = headerView.headersStackView.subviews
            
            stackView.addArrangedSubview(headerView)
            
            headerView.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
        }
        
        let cards = cardsList.data
        
        // Calculate whether list has multiple printings inside one set.
        let sets = Set<String>(cards.map { $0.setCode })
        let setCounts = sets
            .map({ set -> Int in
                return cards.filter({ card in
                    card.setCode == set
                }).count
            })
        let multiplePrintings = setCounts.filter({$0 > 1}).count > 0
        
        // Printings
        let index = cards.index(where: { card -> Bool in return card.ID == selected.ID }) ?? 0
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
                rowView.configure(card: card, selected: card.ID == selected.ID, withNumber: multiplePrintings)
                
                stackView.addArrangedSubview(rowView)
                
                rowView.snp.makeConstraints { make in
                    make.width.equalTo(stackView).inset(1.0/UIScreen.main.scale)
                }
                
                for (idx, view) in rowView.pricesStackView.subviews.enumerated() {
                    view.snp.makeConstraints { make in
                        make.width.equalTo(headerLabels[idx])
                    }
                }
                
                rowView.rx.tapGesture().when(.recognized).map({ _ in return card }).bind(to: action.inputs).disposed(by: disposeBag)
            }
        }
        
        // Put 'all prints' link if there are too many prints
        if cards.count > maxPrints {
            if let linkView = Bundle.main.loadNibNamed("PrintingsTableFooter", owner: nil, options: nil)!.first as? PrintingsTableFooter {
                if (cardsList.hasMore) {
                    linkView.title = "View all prints →"
                } else {
                    linkView.title = "View all \(cards.count) prints →"
                }
                
                stackView.addArrangedSubview(linkView)
                
                linkView.snp.makeConstraints { make in
                    make.width.equalTo(stackView).inset(1.0/UIScreen.main.scale)
                }
                                
                linkView.rx.tapGesture().when(.recognized).map({_ in return ()}).bind(to: allPrintsAction.inputs).disposed(by: disposeBag)
            }
        }
        
        // Footer
        let footer = UIView()
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.backgroundColor = Style.color(forKey: .navigationTint)
        stackView.addArrangedSubview(footer)
        
        footer.snp.makeConstraints { make in
            make.height.equalTo(2.0)
            make.width.equalToSuperview()
        }
        
        self.setNeedsUpdateConstraints()
        self.layoutSubviews()
    }
}
