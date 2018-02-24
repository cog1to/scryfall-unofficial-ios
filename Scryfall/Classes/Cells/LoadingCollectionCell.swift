//
//  LoadingCollectionCell.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 2/15/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import UIKit

class LoadingCollectionCell: UICollectionViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        activityIndicator.startAnimating()
    }
}
