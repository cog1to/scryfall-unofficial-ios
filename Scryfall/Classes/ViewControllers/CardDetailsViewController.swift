//
//  CardDetailsViewController.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/**
 * Card details controller. Shows card image and detail information about a single card.
 */
class CardDetailsViewController: UIViewController, BindableType {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cardImageView: CardImageView!
    @IBOutlet weak var cardDetailsView: CardDetailsView!
    @IBOutlet weak var cardSetView: CardSetView!
    var printingsTable: PrintingsTable?
    
    var viewModel: CardDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Style.color(forKey: .background)
    }
    
    func bindViewModel() {
        // Get images either from the card, or from it's cardfaces.
        var imageUris = viewModel.card.imageUris.filter({ return $0.key == .png }).map({$0.value})
        if imageUris.count == 0, let faces = viewModel.card.faces {
            imageUris = faces.flatMap { return $0.imageUris.filter({$0.key == .png}).map({$0.value}) }
        }
        
        cardImageView.configure(for: imageUris, layout: viewModel.card.layout)
        cardDetailsView.configure(for: viewModel.card)
        cardSetView.configure(forCard: viewModel.card)
        
        if let prints = viewModel.prints {
            prints.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] cards in
                guard let strongSelf = self, cards.count > 0 else {
                    return
                }
                
                if let oldTable = strongSelf.printingsTable {
                    oldTable.removeFromSuperview()
                }
                
                let printingsTable = PrintingsTable()
                printingsTable.configure(cards: cards, selected: strongSelf.viewModel.card)
                
                strongSelf.stackView.addArrangedSubview(printingsTable)
                strongSelf.printingsTable = printingsTable
                printingsTable.widthAnchor.constraint(equalTo: strongSelf.stackView.widthAnchor, multiplier: 1.0).isActive = true
            }).disposed(by: rx.disposeBag)
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        viewModel.onCancel.execute(())
    }
}
