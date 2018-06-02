//
//  Scene.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

import UIKit

enum Scene {
    case search(CardSearchViewModel)
    case details(CardDetailsViewModel)
    case sets(SetsListViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .search(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "CardSearch") as! UINavigationController
            var vc = nc.viewControllers.first as! CardSearchViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .details(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "CardDetails") as! UINavigationController
            var vc = nc.viewControllers.first as! CardDetailsViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .sets(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "SetsList") as! UINavigationController
            var vc = nc.viewControllers.first as! SetsListViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}
