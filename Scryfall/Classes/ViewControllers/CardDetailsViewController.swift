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

class CardDetailsViewController: UIViewController, BindableType {
    var viewModel: CardDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        viewModel.onCancel.execute(())
    }
}
