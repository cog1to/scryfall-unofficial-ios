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
    
    init(view: ListSettingsHeaderView, presenter: UIViewController?) {
        self.view = view
        self.presenter = presenter
        super.init()
        
        view.firstOptionButton.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in self.firstOptionTapped()
        }).disposed(by: rx.disposeBag)
        view.secondOptionButton.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.secondOptionTapped()
        }).disposed(by: rx.disposeBag)
    }
    
    func setFirstOption(_ option: T1) {
        view.firstOptionButton.titleLabel.text = option.name
    }
    
    func setSecondOption(_ option: T2) {
        view.secondOptionButton.titleLabel.text = option.name
    }
    
    private func firstOptionTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for option in T1.all {
            alertController.addAction(UIAlertAction(title: option.name, style: .default, handler: { _ in
                if let action = self.firstOptionSelected {
                    self.setFirstOption(option)
                    action.execute(option)
                }
            }))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view.firstOptionButton.rightIcon
        }
        
        if let presenter = presenter {
            presenter.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func secondOptionTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for option in T2.all {
            alertController.addAction(UIAlertAction(title: option.name, style: .default, handler: { _ in
                if let action = self.secondOptionSelected {
                    self.setSecondOption(option)
                    action.execute(option)
                }
            }))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view.secondOptionButton.rightIcon
        }
        
        if let presenter = presenter {
            presenter.present(alertController, animated: true, completion: nil)
        }
    }
}
