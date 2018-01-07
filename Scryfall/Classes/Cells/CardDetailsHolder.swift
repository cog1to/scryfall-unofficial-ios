//
//  CardDetailsHolder.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/7/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class CardDetailsHolder: UIView {
    @IBOutlet var stackView: UIStackView!
    
    override func awakeFromNib() {
        stackView.axis = .vertical
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0/UIScreen.main.scale
    }
    
    func configure(for card: Card) {
        if let faces = card.faces {
            faces.enumerated().forEach { (idx, face) in
                if (idx > 0) {
                    stackView.addArrangedSubview(separator())
                }
                
                let titleLabel = label(withFontStyle: .headline, text: face.name)
                stackView.addArrangedSubview(titleLabel)
                
                if face.typeLine.count > 0 {
                    stackView.addArrangedSubview(separator())
                    stackView.addArrangedSubview(label(withFontStyle: .text, text: face.typeLine))
                }
                
                if let oracleText = face.oracleText {
                    stackView.addArrangedSubview(separator())
                    stackView.addArrangedSubview(label(text: rulingsString(for: oracleText, flavor: face.flavorText)))
                }
                
                if let power = face.power, let toughness = face.toughness {
                    stackView.addArrangedSubview(separator())
                    stackView.addArrangedSubview(label(text: ptString(power: power, toughness: toughness)))
                }
            }
        } else {
            let titleLabel = label(withFontStyle: .headline, text: card.name)
            stackView.addArrangedSubview(titleLabel)
            
            if card.typeLine.count > 0 {
                stackView.addArrangedSubview(separator())
                let typeLabel = label(withFontStyle: .text, text: card.typeLine)
                stackView.addArrangedSubview(typeLabel)
            }
            
            if let oracleText = card.oracleText {
                stackView.addArrangedSubview(separator())
                let oracleLabel = label(text: rulingsString(for: oracleText, flavor: card.flavorText))
                stackView.addArrangedSubview(oracleLabel)
            }
            
            if let power = card.power, let toughness = card.toughness {
                stackView.addArrangedSubview(separator())
                stackView.addArrangedSubview(label(text: ptString(power: power, toughness: toughness)))
            }
        }
        
        layoutIfNeeded()
    }
}

extension CardDetailsHolder {
    fileprivate func separator() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1.0/UIScreen.main.scale))
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale).isActive = true
        
        return view
    }
    
    fileprivate func label(withFontStyle style: Style.FontKey, text: String?) -> UIView {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Style.font(forKey: style)
        label.text = text
        
        return embed(label)
    }
    
    fileprivate func label(text: NSAttributedString) -> UIView {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.attributedText = text
        
        return embed(label)
    }
    
    fileprivate func embed(_ view: UIView) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[child]-8-|", options: [], metrics: nil, views: ["child": view]))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[child]-8-|", options: [], metrics: nil, views: ["child": view]))
        
        return container
    }
    
    fileprivate func rulingsString(for text: String, flavor: String?) -> NSAttributedString {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.headIndent = 0.0
        paragraphStyle.firstLineHeadIndent = 0.0
        paragraphStyle.paragraphSpacing = 8.0
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let paragraphs = text.components(separatedBy: "\n")
        let combined = NSMutableAttributedString()
        
        paragraphs.enumerated().forEach { (idx, string) in
            let updated = (idx == paragraphs.count - 1) ? string : "\(string)\n"
            combined.append(NSAttributedString(string: updated, attributes: [NSAttributedStringKey.font : Style.font(forKey: .text), NSAttributedStringKey.paragraphStyle : paragraphStyle]))
        }
        
        if let flavor = flavor, flavor.count > 0 {
            combined.append(NSAttributedString(string: "\n\(flavor)", attributes: [NSAttributedStringKey.font : Style.font(forKey: .italic), NSAttributedStringKey.paragraphStyle : paragraphStyle]))
        }
        
        return combined
    }
    
    fileprivate func ptString(power: String, toughness: String) -> NSAttributedString {
        return NSAttributedString(string: "\(power)/\(toughness)", attributes: [NSAttributedStringKey.font : Style.font(forKey: .bold)])
    }
}
