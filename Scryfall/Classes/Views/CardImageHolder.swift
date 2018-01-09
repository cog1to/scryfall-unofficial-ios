//
//  CardImageCollectionCell.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Action

/**
 * View that holds card image.
 * Call configure(for:layout:) to make it download and show card images.
 */
class CardImageHolder: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var flipButton: UIButton!
    
    private static let downloader = ImageDownloader()
    private var images = Variable<[UIImage]>([])
    private var flipped = Variable<Bool>(false)
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(patternImage: UIImage(named: "stripes")!)
        
        flipButton.titleLabel?.font = Style.font(forKey: .bold)
        flipButton.layer.borderColor = Style.color(forKey: .tint).cgColor
        flipButton.layer.borderWidth = 1.0/UIScreen.main.scale
        flipButton.layer.cornerRadius = 4.0
        setup()
    }
    
    fileprivate func setup() {
        flipButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.flipped.value = !strongSelf.flipped.value
        }).disposed(by: disposeBag)
    }
    
    func configure(for imageUris: [URL], layout: Layout) {
        // Show or hide transform button. Right now we show it only for double-faced cards.
        switch layout {
        case .normal, .split, .flip:
            flipButton.isHidden = true
        case .transform:
            flipButton.isHidden = false
            flipButton.setTitle("Transform", for: .normal)
        }
        
        // Schedule image downloading.
        Observable<URL>.from(imageUris)
            .flatMap {
                return CardImageHolder.downloader.image(for: $0)
            }.filter {
                $0 != nil
            }.map{
                $0!
            }.toArray().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
                if let strongSelf = self {
                    strongSelf.images.value = $0
                }
            }).disposed(by: disposeBag)
        
        // Watch to changes in images or flipped state to update UI.
        Observable.combineLatest(images.asObservable(), flipped.asObservable())
            .subscribe(onNext: { [weak self] imageValues, flipped in
                guard let strongSelf = self else {
                    return
                }
                
                if flipped, imageValues.count > 1 {
                    strongSelf.imageView.image = imageValues[1]
                } else if let image = imageValues.first {
                    strongSelf.imageView.image = image
                }
            }).disposed(by: disposeBag)
    }
}
