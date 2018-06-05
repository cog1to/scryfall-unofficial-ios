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
import TagListView

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
    var languagesView: TagListView?
    
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
                imageUris = faces.flatMap {
                    return $0.imageUris.filter({$0.key == .png}).map({$0.value})
                }
            }

            self.cardImageView.configure(for: imageUris, layout: card.layout)
            self.updateCard(card)
        }).disposed(by: disposeBag)

        viewModel.prints
            .drive(onNext: { [weak self] cards in
                OperationQueue.main.addOperation { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                if let oldPrintingsTable = strongSelf.printingsTable {
                    oldPrintingsTable.removeFromSuperview()
                }
                
                let printingsTable = PrintingsTable()
                printingsTable.configure(cards: cards, selected: strongSelf.viewModel.cardVariable.value, action: strongSelf.viewModel.onPrintingSelected, allPrintsAction: strongSelf.viewModel.onAllPrint)
                
                strongSelf.stackView.addArrangedSubview(printingsTable)
                strongSelf.printingsTable = printingsTable
                printingsTable.widthAnchor.constraint(equalTo: strongSelf.stackView.widthAnchor, multiplier: 1.0).isActive = true
                
                strongSelf.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.languages
            .drive(onNext: { [weak self] cards in
                self?.updateLanguages(cards: cards, selected: self!.viewModel.cardVariable.value)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        viewModel.onCancel.execute(())
    }
    
    private func updateLanguages(cards: [Card], selected: Card) {
        OperationQueue.main.addOperation { [weak self] in
            guard let strongSelf = self, selected.language != nil else {
                return
            }
            
            var tagListView: TagListView? = strongSelf.languagesView
            if tagListView == nil {
                tagListView = TagListView()
                tagListView!.translatesAutoresizingMaskIntoConstraints = false
                tagListView!.textFont = Style.font(forKey: .text)
                tagListView!.alignment = .center
                tagListView!.marginY = 4.0
                strongSelf.stackView.insertArrangedSubview(tagListView!, at: 1)
                tagListView!.widthAnchor.constraint(equalTo: strongSelf.stackView.widthAnchor, multiplier: 1.0).isActive = true
                
                strongSelf.languagesView = tagListView
            } else {
                tagListView!.removeAllTags()
            }
            
            if (cards.count == 0) {
                tagListView!.addTagView(strongSelf.view(forCard: selected, selected: true))
            } else {
                for card in cards.filter({ return $0.language != nil }) {
                    let tagView = strongSelf.view(forCard: card, selected: (card.ID == selected.ID))
                    tagListView!.addTagView(tagView)
                }
            }
            
            tagListView!.layoutSubviews()
        }
    }
    
    private func view(forCard card: Card, selected: Bool) -> TagView {
        let tagView = TagView(title: card.language!.rawValue.uppercased())
        
        tagView.textFont = Style.font(forKey: .text)
        tagView.paddingX = 4.0
        tagView.paddingY = 4.0
        tagView.cornerRadius = Constants.commonCornerRadius
        
        tagView.backgroundColor = selected
            ? Style.color(forKey: .tint)
            : Style.color(forKey: .navigationTint)
        
        tagView.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.onLanguage.execute(card)
            self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }).disposed(by: disposeBag)
        
        return tagView
    }
}
