//
//  RulingsView.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RulingsListView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rulingsContainer: UIView!
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        titleLabel.font = Style.font(forKey: .bold)
        titleLabel.textColor = Style.color(forKey: .text)
    }
    
    func configure(for rulings: [CardRuling]) {
        for view in rulingsContainer.subviews {
            view.removeFromSuperview()
        }
        
        let views = rulings.map { ruling -> UIView? in
            if let view = Bundle.main.loadNibNamed("RulingsView", owner: nil, options: nil)?.first as? RulingsView {
                view.configure(for: ruling)
                return view
            }
            return nil
        }
        
        let filtered = views.filter({ $0 != nil }).map({ $0! })
        for (index, view) in filtered.enumerated() {
            rulingsContainer.addSubview(view)
            
            view.snp.makeConstraints { make -> Void in
                make.left.equalToSuperview().inset(0)
                make.right.equalToSuperview().inset(0)
            }
            
            if index == 0 {
                view.snp.makeConstraints { make -> Void in
                    make.top.equalToSuperview()
                }
            }
        
            if index > 0 {
                let previousView = filtered[index - 1]
                view.snp.makeConstraints { make -> Void in
                    make.top.equalTo(previousView.snp.bottom).inset(-16)
                }
            }
            
            if index == (filtered.count - 1) {
                view.snp.makeConstraints { make -> Void in
                    make.bottom.equalToSuperview()
                }
            }
        }
        
        setNeedsLayout()
    }
}
