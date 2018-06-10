//
//  LegalityTable.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/8/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

/**
 * Custom control for layoing out legality values.
 */
class LegalityTable: UIStackView {
    override func awakeFromNib() {
        axis = .horizontal
        alignment = .center
        distribution = .fillEqually
        spacing = 4
    }
    
    func configure(legalities: [Format: Legality], columns: Int) {
        subviews.forEach{ $0.removeFromSuperview() }
        
        let displayed = Format.displayed
        let filtered = displayed.filter { legalities.keys.contains($0) }
        
        // Populate columns.
        let columnViews: [UIStackView] = (0..<columns).map{ _ in return newColumn() }
        var legalityViews = [LegalityView]()
        for (index, element) in filtered.enumerated() {
            let column = columns - (index % columns) - 1
            let columnView = columnViews[column]
            
            let legalityView = Bundle.main.loadNibNamed("LegalityView", owner: nil, options: nil)?.first as! LegalityView
            legalityView.configure(format: element, legality: legalities[element]!)
            legalityView.sizeToFit()
            legalityViews.append(legalityView)
            
            columnView.addArrangedSubview(legalityView)
        }
        
        // Make all plaques the same width.
        let maxWidth = legalityViews.reduce(0, { width, view in
            return (view.legalityLabel.frame.size.width > width) ? view.legalityLabel.frame.size.width : width
        })
        legalityViews.forEach { view in
            view.legalityLabel.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
        }
        
        // Add columns to parent view.
        columnViews.reversed().forEach {
            addArrangedSubview($0)
        }
        
        // Make all columns equal width. Theoretically this should be achieved by "distribution = .fillEqually"
        // but for some reason it doesn't work unless I explicitly specify equality constraints.
        columnViews.suffix(from: 1).forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(columnViews[0])
            }
        }
        
        layoutIfNeeded()
    }
    
    private func newColumn() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.spacing = 4
        
        return view
    }
    
    
}
