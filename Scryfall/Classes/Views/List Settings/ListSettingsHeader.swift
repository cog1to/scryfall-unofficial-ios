//
//  ListSettingsHeader.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/28/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class ListSettingsHeader<T1: StringRepresentableOption, T2: StringRepresentableOption>: NSObject {
    private let nibName = "ListSettingsHeader"
    
    var view: ListSettingsHeaderView
    
    weak var presenter: UIViewController?
    
    var firstOptionSelected: Action<T1, Void>?
    var secondOptionSelected: Action<T2, Void>?
    var sortDirectionSelected: Action<SortDirection, Void>?
    
    init(view: ListSettingsHeaderView, presenter: UIViewController?) {
        self.view = view
        self.presenter = presenter
        super.init()
        
        view.firstOptionButton.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in self.showOptions(from: view.firstOptionButton, action: self.firstOptionSelected)
        }).disposed(by: rx.disposeBag)
        
        view.secondOptionButton.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.showOptions(from: view.secondOptionButton, action: self.secondOptionSelected)
        }).disposed(by: rx.disposeBag)
        
        view.sortDirectionButton.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.showOptions(from: view.sortDirectionButton, action: self.sortDirectionSelected)
        }).disposed(by: rx.disposeBag)
    }
    
    func setFirstOption(_ option: T1) {
        view.firstOptionButton.titleLabel.text = option.name
    }
    
    func setSecondOption(_ option: T2) {
        view.secondOptionButton.titleLabel.text = option.name
    }
    
    func setSortDirection(_ option: SortDirection) {
        view.sortDirectionButton.titleLabel.text = option.name
    }
}

extension ListSettingsHeader {
    fileprivate func showOptions<T: StringRepresentableOption>(from button: RoundCornerButton, action: Action<T, Void>?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for option in T.all {
            alertController.addAction(UIAlertAction(title: option.name, style: .default, handler: { _ in
                if let action = action {
                    button.titleLabel.text = option.name
                    action.execute(option)
                }
            }))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = button.rightIcon
        }
        
        if let presenter = presenter {
            presenter.present(alertController, animated: true, completion: nil)
        }
    }
}
