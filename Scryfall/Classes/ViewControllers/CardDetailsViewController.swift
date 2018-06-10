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
    var rulingsView: RulingsListView?
    
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

        Driver.combineLatest(viewModel.prints, viewModel.card)
            .filter { $0.0 != nil }
            .map { ($0.0!, $0.1) }
            .drive(onNext: { [weak self] cards, selected in
                OperationQueue.main.addOperation { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let oldPrintingsTable = strongSelf.printingsTable {
                        oldPrintingsTable.removeFromSuperview()
                    }
                    
                    let printingsTable = PrintingsTable()
                    printingsTable.configure(cardsList: cards, selected: strongSelf.viewModel.cardVariable.value, action: strongSelf.viewModel.onPrintingSelected, allPrintsAction: strongSelf.viewModel.onAllPrint)
                    
                    if (strongSelf.rulingsView == nil) {
                        strongSelf.stackView.addArrangedSubview(printingsTable)
                    } else {
                        strongSelf.stackView.insertArrangedSubview(printingsTable, at: strongSelf.stackView.subviews.count - 1)
                    }
                    
                    strongSelf.printingsTable = printingsTable
                    printingsTable.widthAnchor.constraint(equalTo: strongSelf.stackView.widthAnchor, multiplier: 1.0).isActive = true
                    
                    strongSelf.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        Driver.combineLatest(viewModel.languages, viewModel.card)
            .drive(onNext: { [weak self] cards, selected in
                self?.updateLanguages(cards: cards, selected: self!.viewModel.cardVariable.value)
            })
            .disposed(by: disposeBag)
        
        viewModel.rulings
            .drive(onNext: { [unowned self] rulings in
                OperationQueue.main.addOperation { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard rulings.count > 0 else {
                        if let view = strongSelf.rulingsView {
                            view.removeFromSuperview()
                            strongSelf.rulingsView = nil
                        }
                        return
                    }
                    
                    var rulingsView: RulingsListView! = strongSelf.rulingsView
                    if rulingsView == nil {
                        rulingsView = Bundle.main.loadNibNamed("RulingsListView", owner: nil, options: nil)?.first! as! RulingsListView
                        rulingsView.translatesAutoresizingMaskIntoConstraints = false
                    }
                    
                    rulingsView.configure(for: rulings)
                    
                    strongSelf.stackView.addArrangedSubview(rulingsView)
                    rulingsView.widthAnchor.constraint(equalTo: strongSelf.stackView.widthAnchor, multiplier: 1.0).isActive = true
                    
                    strongSelf.rulingsView = rulingsView
                }
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
            
            var uniqueCards = [selected]
            for card in cards {
                if !uniqueCards.contains(where: { $0.setCode == card.setCode && $0.language?.rawValue == card.language?.rawValue }) {
                    uniqueCards.append(card)
                }
            }
            
            if (uniqueCards.count == 0) {
                tagListView!.addTagView(strongSelf.view(forCard: selected, selected: true))
            } else {
                for card in uniqueCards.filter({ return $0.language != nil }) {
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
