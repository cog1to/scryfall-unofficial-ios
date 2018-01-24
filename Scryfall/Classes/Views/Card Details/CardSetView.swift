//
//  CardSetView.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/10/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Action

/**
 * View that displays a single card's set info.
 */
class CardSetView: UIView {
    @IBOutlet weak var setIconView: UIImageView!
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        backgroundColor = Style.color(forKey: .navigationTint)
        layer.cornerRadius = Constants.commonCornerRadius
        
        setIconView.tintColor = Style.color(forKey: .printingText)
        
        setNameLabel.font = Style.font(forKey: .text)
        setNameLabel.textColor = Style.color(forKey: .printingText)
        
        cardNumberLabel.font = Style.font(forKey: .subtext)
        cardNumberLabel.textColor = Style.color(forKey: .printingText)
    }
    
    func configure(forCard card: Card, tapAction: CocoaAction) {
        if let setSymbol = UIImage(named: "set_\(card.setCode)") {
            setIconView.image = setSymbol
        }
        
        setNameLabel.text = "\(card.setName) (\(card.setCode.uppercased()))"
        cardNumberLabel.text = "#\(card.collectorsNumber), \(card.rarity.name)"
        
        rx.tapGesture().when(.recognized).map { _ in return () }.bind(to: tapAction.inputs).disposed(by: rx.disposeBag)
    }
}
