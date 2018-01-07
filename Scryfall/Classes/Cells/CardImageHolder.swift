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

class CardImageHolder: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var flipButton: UIButton!
    
    private let downloader = ImageDownloader()
    private var images = Variable<[UIImage]>([])
    private var flipped = Variable<Bool>(false)
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 10
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
        switch layout {
        case .normal, .split, .flip:
            flipButton.isHidden = true
        case .transform:
            flipButton.isHidden = false
            flipButton.setTitle("Transform", for: .normal)
        }
        
        Observable<URL>.from(imageUris)
            .flatMap { [unowned self] in
                return self.downloader.image(for: $0)
            }.filter {
                $0 != nil
            }.map{
                $0!
            }.toArray().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
                if let strongSelf = self {
                    strongSelf.images.value = $0
                }
            }).disposed(by: disposeBag)
        
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
