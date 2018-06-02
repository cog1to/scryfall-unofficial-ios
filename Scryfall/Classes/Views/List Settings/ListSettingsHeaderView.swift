//
//  ListSettingsHeaderView.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/28/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class ListSettingsHeaderView: UIView {
    private let nibName = "ListSettingsHeaderView"
    
    @IBOutlet weak var firstOptionLabel: UILabel!
    @IBOutlet weak var firstOptionButton: RoundCornerButton!
    @IBOutlet weak var secondOptionLabel: UILabel!
    @IBOutlet weak var secondOptionButton: RoundCornerButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    override func awakeFromNib() {
        firstOptionLabel.font = Style.font(forKey: .subtext)
        firstOptionLabel.textColor = Style.color(forKey: .text)
        
        firstOptionButton.titleLabel.font = Style.font(forKey: .subtextBold)
        
        secondOptionLabel.font = Style.font(forKey: .subtext)
        secondOptionLabel.textColor = Style.color(forKey: .text)
        
        secondOptionButton.titleLabel.font = Style.font(forKey: .subtextBold)
    }
}
