//
//  CardSearchCollectionCell.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 2/15/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import UIKit

class CardSearchCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    private static let downloader = ImageDownloader()
    
    override func awakeFromNib() {
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(patternImage: UIImage(named: "stripes")!)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(for card: Card) {
        imageView.layer.cornerRadius = frame.size.width / Constants.widthToCornerRadiusRatio
        
        var imageUri = card.imageUris[.normal]
        if imageUri == nil, let faces = card.faces, faces.count > 0, let faceImage = faces[0].imageUris[.normal] {
            imageUri = faceImage
        }
        
        guard imageUri != nil else {
            return
        }
        
        CardSearchCollectionCell.downloader.image(for: imageUri!)
            .asDriver(onErrorJustReturn: nil)
            .drive(imageView.rx.image)
            .disposed(by: self.rx.disposeBag)
    }
}
