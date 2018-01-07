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
    @IBOutlet var cardImageHolder: CardImageHolder!
    @IBOutlet var cardDetailsHolder: CardDetailsHolder!
    
    var viewModel: CardDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        var imageUris = viewModel.card.imageUris.filter({ return $0.key == .png }).map({$0.value})
        if imageUris.count == 0, let faces = viewModel.card.faces {
            imageUris = faces.flatMap { return $0.imageUris.filter({$0.key == .png}).map({$0.value}) }
        }
        
        cardImageHolder.configure(for: imageUris, layout: viewModel.card.layout)
        cardDetailsHolder.configure(for: viewModel.card)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        viewModel.onCancel.execute(())
    }
}
