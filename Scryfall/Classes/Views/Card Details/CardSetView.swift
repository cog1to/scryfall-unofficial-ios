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
import PocketSVG

/**
 * View that displays a single card's set info.
 */
class CardSetView: UIView {
    @IBOutlet weak var setIconView: UIView!
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
        CardSetCache.instance.set(forCode: card.setCode)
            .filter {
                $0.iconURI != nil
            }
            .flatMap { set in
                return ImageDownloader().data(for: set.iconURI!)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                guard let data = data else {
                    return
                }
                
                // Create SVG image view.
                let svgPaths = SVGBezierPath.paths(fromSVGString: String(data: data, encoding: .utf8)!) as! [SVGBezierPath]
                let svgView = SVGImageView()
                svgView.paths = svgPaths
                svgView.fillColor = Style.color(forKey: .printingText)
                
                // Remove old image.
                for subview in self.setIconView.subviews {
                    subview.removeFromSuperview()
                }
                
                // Add new image.
                svgView.frame = self.setIconView.bounds
                svgView.contentMode = .scaleAspectFit
                self.setIconView.addSubview(svgView)
            })
            .disposed(by: self.disposeBag)
        
        setNameLabel.text = "\(card.setName) (\(card.setCode.uppercased()))"
        cardNumberLabel.text = "#\(card.collectorsNumber), \(card.rarity.name)"
        
        rx.tapGesture().when(.recognized).map { _ in return () }.bind(to: tapAction.inputs).disposed(by: rx.disposeBag)
    }
}
