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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cardImageView: CardImageView!
    @IBOutlet weak var cardDetailsView: CardDetailsView!
    @IBOutlet weak var cardSetView: CardSetView!
    var printingsTable: PrintingsTable?
    
    var viewModel: CardDetailsViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Style.color(forKey: .background)
    }
    
    func updateCard(_ card: Card) {
        self.cardDetailsView.configure(for: card,
                                       artistAction: self.viewModel.onArtist,
                                       watermarkAction: self.viewModel.onWatermark,
                                       reservedAction: self.viewModel.onReserved)
        self.cardSetView.configure(forCard: card, tapAction: self.viewModel.onSet)
    }
    
    func bindViewModel() {
        viewModel.card.drive(onNext: { [unowned self] card in
            // Get images either from the card, or from it's cardfaces.
            var imageUris = card.imageUris.filter({ return $0.key == .png }).map({$0.value})
            if imageUris.count == 0, let faces = card.faces {
                imageUris = faces.flatMap { return $0.imageUris.filter({$0.key == .png}).map({$0.value}) }
            }

            self.cardImageView.configure(for: imageUris, layout: card.layout)
            self.updateCard(card)

            if let oldTable = self.printingsTable {
                oldTable.removeFromSuperview()
            }
        }).disposed(by: disposeBag)

        viewModel.prints.drive(onNext: { [weak self] cards, selected in
            guard let strongSelf = self, cards.count > 0 else {
                return
            }

            let printingsTable = PrintingsTable()
            printingsTable.configure(cards: cards, selected: selected, action: strongSelf.viewModel.onPrintingSelected, allPrintsAction: strongSelf.viewModel.onAllPrint)

            strongSelf.stackView.addArrangedSubview(printingsTable)
            strongSelf.printingsTable = printingsTable
            printingsTable.widthAnchor.constraint(equalTo: strongSelf.stackView.widthAnchor, multiplier: 1.0).isActive = true

            strongSelf.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        viewModel.onCancel.execute(())
    }
}
