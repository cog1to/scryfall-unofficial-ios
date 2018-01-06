//
//  BindableType.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

public protocol BindableType {
    // Associated type of a binded view model.
    associatedtype ViewModelType
    
    // View model
    var viewModel: ViewModelType! { get set }
    
    // Binds view model.
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    public mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
