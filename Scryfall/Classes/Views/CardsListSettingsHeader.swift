//
//  CardsListSettingsHeader.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 2/15/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import NSObject_Rx
import Action

class CardsListSettingsHeader: UIView {

    private let nibName = "CardsListSettingsHeader"
    
    @IBOutlet weak var displayModeLabel: UILabel!
    @IBOutlet weak var displayModeButton: RoundCornerButton!
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var sortingButton: RoundCornerButton!

    weak var presenter: UIViewController?
    
    var sortOrderSelected: Action<SortOrder, Void>?
    var displayModeSelected: Action<DisplayMode, Void>?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func awakeFromNib() {
        displayModeLabel.font = Style.font(forKey: .subtext)
        displayModeLabel.textColor = Style.color(forKey: .text)
        
        displayModeButton.titleLabel.font = Style.font(forKey: .subtextBold)
        
        sortingLabel.font = Style.font(forKey: .subtext)
        sortingLabel.textColor = Style.color(forKey: .text)
        
        sortingButton.titleLabel.font = Style.font(forKey: .subtextBold)
        
        // Wiring buttons.
        displayModeButton.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in self.displayModeTapped()
        }).disposed(by: rx.disposeBag)
        sortingButton.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.sortOrderTapped()
        }).disposed(by: rx.disposeBag)
    }
    
    func setDisplayMode(_ mode: DisplayMode) {
        displayModeButton.titleLabel.text = mode.name
    }
    
    func setSortOrder(_ order: SortOrder) {
        sortingButton.titleLabel.text = order.name
    }
    
    private func displayModeTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for mode in DisplayMode.all {
            alertController.addAction(UIAlertAction(title: mode.name, style: .default, handler: { _ in
                if let action = self.displayModeSelected {
                    self.setDisplayMode(mode)
                    action.execute(mode)
                }
            }))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = displayModeButton.rightIcon
        }
        
        if let presenter = presenter {
            presenter.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func sortOrderTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for order in SortOrder.all {
            alertController.addAction(UIAlertAction(title: order.name, style: .default, handler: { _ in
                if let action = self.sortOrderSelected {
                    self.setSortOrder(order)
                    action.execute(order)
                }
            }))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sortingButton.rightIcon
        }
        
        if let presenter = presenter {
            presenter.present(alertController, animated: true, completion: nil)
        }
    }
}
