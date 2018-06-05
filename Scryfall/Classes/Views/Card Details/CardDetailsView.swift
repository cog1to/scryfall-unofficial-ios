//
//  CardDetailsView.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/7/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Action

/**
 * View that holds card details information.
 * Call configure(for:) method to make it generate formatted card data.
 */
class CardDetailsView: UIView {
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        stackView.axis = .vertical
        self.backgroundColor = Style.color(forKey: .detailsBackground)
        self.layer.cornerRadius = 4
        self.layer.borderColor = Style.color(forKey: .gray).cgColor
        self.layer.borderWidth = 1.0/UIScreen.main.scale
    }
    
    func configure(for card: Card, artistAction: CocoaAction, watermarkAction: CocoaAction, reservedAction: CocoaAction) {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        let faces = card.faces ?? [card]
        faces.enumerated().forEach { (idx, face) in
            if (idx > 0) {
                stackView.addArrangedSubview(separator())
            }
            
            // Name and cost.
            let titleLabel = label(text: nameString(name: face.printedName ?? face.name, cost: face.manaCost))
            stackView.addArrangedSubview(titleLabel)
            
            // Type line.
            let typeline = face.printedTypeLine ?? face.typeLine
            if typeline.count > 0 {
                stackView.addArrangedSubview(separator())
                stackView.addArrangedSubview(label(withFontStyle: .text, text: typeline))
            }
            
            // Oracle text.
            let text = face.printedText ?? face.oracleText
            if text != nil || face.flavorText != nil {
                stackView.addArrangedSubview(separator())
                stackView.addArrangedSubview(label(text: rulingsString(for: text, flavor: face.flavorText)))
            }
            
            // Power and toughness.
            if let power = face.power, let toughness = face.toughness {
                stackView.addArrangedSubview(separator())
                stackView.addArrangedSubview(label(text: ptString(power: power, toughness: toughness)))
            }
            
            // Starting loyalty.
            if let loyalty = face.loyalty {
                stackView.addArrangedSubview(separator())
                stackView.addArrangedSubview(label(text: loyaltyString(loyalty: loyalty)))
            }
        }
        
        // Watermark.
        if let watermark = card.watermark {
            stackView.addArrangedSubview(separator())
            
            let watermarkLabel = label(text: linkText(prefix: "Watermark:", value: watermark.name))
            watermarkLabel.rx.tapGesture().when(.recognized).map({_ in return ()}).bind(to: watermarkAction.inputs).disposed(by: rx.disposeBag)
            
            stackView.addArrangedSubview(watermarkLabel)
        }
        
        // Artist.
        if let artist = card.artist {
            stackView.addArrangedSubview(separator())
            
            let artistLabel = label(text: linkText(prefix: "Illustrated by", value: artist))
            artistLabel.rx.tapGesture().when(.recognized).map({_ in return ()}).take(1).bind(to: artistAction.inputs).disposed(by: rx.disposeBag)
            
            stackView.addArrangedSubview(artistLabel)
        }
        
        // Reserved flag.
        if card.reserved {
            stackView.addArrangedSubview(separator())
            
            let reservedLabel = label(text: linkText(prefix: "Part of the", value: "Reserved List"))
            reservedLabel.rx.tapGesture().when(.recognized).map({_ in return ()}).bind(to: reservedAction.inputs).disposed(by: rx.disposeBag)
            
            stackView.addArrangedSubview(reservedLabel)
        }
        
        // Legalities.
        if card.legalities.count > 0 {
            let legalityTable = LegalityTable()
            legalityTable.translatesAutoresizingMaskIntoConstraints = false
            legalityTable.configure(legalities: card.legalities, columns: 2)
            
            stackView.addArrangedSubview(separator())
            stackView.addArrangedSubview(embed(legalityTable))
        }
        
        layoutIfNeeded()
    }
}

/// Subviews generation.
extension CardDetailsView {
    fileprivate func separator() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1.0/UIScreen.main.scale))
        view.backgroundColor = Style.color(forKey: .gray)
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
    
    fileprivate func embed(_ view: UIView, allowGrowth: Bool = false) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[child]-8-|", options: [], metrics: nil, views: ["child": view]))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[child]-8-|", options: [], metrics: nil, views: ["child": view]))
        
        return container
    }
}

/// Formatted strings generation.
extension CardDetailsView {
    
    /**
     * Creates formatted oracle text combined with flavor text string.
     *
     * - parameter text: Oracle text of a card or card face.
     * - parameter flavor: Flavor text of a card or card face.
     * - returns: Formatted attributed string with oracle text and flavor text.
     */
    fileprivate func rulingsString(for text: String?, flavor: String?) -> NSAttributedString {
        let combined = NSMutableAttributedString()
        
        // Format each paragraph.
        if let text = text, text.count > 0 {
            let paragraphs = text.components(separatedBy: "\n")
            paragraphs.enumerated().forEach { (idx, string) in
                // Line break after each paragraph except last.
                let updated = (idx == paragraphs.count - 1) ? string : "\(string)\n"
                
                // Apply font.
                let attributed = NSMutableAttributedString(string: updated, attributes: [.font: Style.font(forKey: .text), NSAttributedStringKey.foregroundColor: Style.color(forKey: .text)])
                
                // Italicise reminder text, if it's found.
                let regexp = try! NSRegularExpression(pattern: " \\(.*\\)(\n)?", options: [])
                if let match = regexp.firstMatch(in: attributed.string, options: [], range: NSRange(location: 0, length: attributed.string.count)) {
                    attributed.addAttribute(.font, value: Style.font(forKey: .italic), range: match.range)
                }
                
                combined.append(attributed)
            }
        }
        
        // Add flavor text paragraph.
        if let flavor = flavor, flavor.count > 0 {
            var flavorText = "\(flavor)"
            if (combined.length > 0) {
                flavorText = "\n\(flavorText)"
            }
            
            combined.append(NSAttributedString(string: flavorText, attributes: [.font : Style.font(forKey: .italic)]))
        }
        
        // Replace mana symbols with images.
        combined.replaceSymbols()
        
        // Apply paragraph spacing (it looks nicer this way).
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.headIndent = 0.0
        paragraphStyle.firstLineHeadIndent = 0.0
        paragraphStyle.paragraphSpacing = 8.0
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        combined.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: combined.string.count))
        
        return combined
    }
    
    /**
     * Makes formatted name + mana cost string.
     *
     * - parameter name: Card(face) name
     * - parameter cost: Card(face) mana cost
     * - returns Formatted card name string
     */
    fileprivate func nameString(name: String, cost: String?) -> NSAttributedString {
        // Add mana cost string, if it's not nil.
        let combined = name + (cost != nil ? " \(cost!)" : "")
        
        // Convert to attributed string and replace mana symbols.
        let attributed = NSMutableAttributedString(string: combined, attributes: [NSAttributedStringKey.font : Style.font(forKey: .headline), NSAttributedStringKey.foregroundColor: Style.color(forKey: .text)])
        attributed.replaceSymbols()
        
        return attributed
    }
    
    /**
     * Makes formatted power + toughness cost string.
     *
     * - parameter power: power value
     * - parameter toughness: toughness value
     * - returns Formatted P/T string
     */
    fileprivate func ptString(power: String, toughness: String) -> NSAttributedString {
        return boldedText(string: "\(power.replacingOccurrences(of: ".5", with: "½"))/\(toughness.replacingOccurrences(of: ".5", with: "½"))")
    }
    
    /**
     * Makes formatted loyalty string.
     *
     * - parameter loyalty: Card(face) loyalty value
     * - returns Formatted loyalty string
     */
    fileprivate func loyaltyString(loyalty: String) -> NSAttributedString {
        return boldedText(string: "Loyalty: \(loyalty)")
    }
    
    /**
     * Makes attributed string with bold font.
     *
     * - parameter string: Input string
     * - returns Attributed string with bold font
     */
    fileprivate func boldedText(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.font : Style.font(forKey: .bold), NSAttributedStringKey.foregroundColor: Style.color(forKey: .text)])
    }
    
    /**
     * Makes attributed string with link style.
     *
     * - parameter prefix: Prefix text
     * - parameter value: Link value
     * - returns Attributed string with formatted link text
     */
    fileprivate func linkText(prefix: String, value: String) -> NSAttributedString {
        let prefixString = NSAttributedString(string: "\(prefix) ", attributes: [NSAttributedStringKey.font : Style.font(forKey: .subtext), NSAttributedStringKey.foregroundColor: Style.color(forKey: .text)])
        
        let linkString = NSAttributedString(string: "\(value)", attributes: [NSAttributedStringKey.font : Style.font(forKey: .subtext), NSAttributedStringKey.foregroundColor: Style.color(forKey: .link)])
        
        return [prefixString, linkString].reduce(NSMutableAttributedString(), { (result, next) in
            result.append(next)
            return result
        })
    }
}
