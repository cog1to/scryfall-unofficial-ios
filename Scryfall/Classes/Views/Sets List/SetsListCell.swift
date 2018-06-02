//
//  SetsListCell.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/28/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import PocketSVG

class SetsListCell: UITableViewCell {
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var indentView: UILabel!
    @IBOutlet weak var indentContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        indentView.font = Style.font(forKey: .text)
        indentView.textColor = Style.color(forKey: .gray)
        indentView.text = "↳"
        
        cardsLabel.font = Style.font(forKey: .subtext)
        cardsLabel.textColor = Style.color(forKey: .text)
        
        dateLabel.font = Style.font(forKey: .subtext)
        dateLabel.textColor = Style.color(forKey: .text)
    }
    
    func configure(for setItem: SetsListViewModel.SetListItem, tableView: UITableView, indexPath: IndexPath) {
        // Name
        let text = NSMutableAttributedString(string: setItem.name, attributes: [NSAttributedStringKey.font: Style.font(forKey: .text), NSAttributedStringKey.foregroundColor: Style.color(forKey: .text)])
        
        let code = NSAttributedString(string: "  \(setItem.code.uppercased())", attributes: [NSAttributedStringKey.font: Style.font(forKey: .text), NSAttributedStringKey.foregroundColor: Style.color(forKey: .gray)])
        text.append(code)
        
        nameLabel.attributedText = text
        
        weak var tableView = tableView
        
        // Icon
        CardSetCache.instance.set(forCode: setItem.code)
            .filter {
                $0.iconURI != nil
            }
            .flatMap { set in
                return ImageDownloader().data(for: set.iconURI!)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                OperationQueue.main.addOperation {
                    guard let data = data, let tableView = tableView else {
                        return
                    }
                    
                    // Create SVG image view.
                    let svgPaths = SVGBezierPath.paths(fromSVGString: String(data: data, encoding: .utf8)!) as! [SVGBezierPath]
                    let svgView = SVGImageView()
                    svgView.paths = svgPaths
                    svgView.fillColor = Style.color(forKey: .text)
                    
                    if let cell = tableView.cellForRow(at: indexPath) as? SetsListCell {
                        // Remove old image.
                        for subview in cell.iconView.subviews {
                            subview.removeFromSuperview()
                        }
                        
                        // Add new image.
                        svgView.frame = cell.iconView.bounds
                        svgView.contentMode = .scaleAspectFit
                        cell.iconView.addSubview(svgView)
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        // Cards
        cardsLabel.text = "\(setItem.cards) cards"
        
        // Release date
        if let date = setItem.releaseDate {
            dateLabel.text = DateFormat.displayString(from: date)
        } else {
            dateLabel.text = nil
        }
        
        if (setItem.level > 0) {
            indentContainer.isHidden = false
        } else {
            indentContainer.isHidden = true
        }
    }
}
