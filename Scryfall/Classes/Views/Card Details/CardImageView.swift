//
//  CardImageView.swift
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
class CardImageView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var flipButton: RoundCornerButton!
    
    private static let defaultAnimationDuration = 0.25
    
    private static let downloader = ImageDownloader()
    private var images = Variable<[UIImage]>([])
    private var flipped = Variable<Bool>(false)
    private var disposeBag = DisposeBag()
    private var layout: Layout!
    private var currentAnimator: UIViewPropertyAnimator?
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = Constants.cardCornerRadius
        imageView.backgroundColor = UIColor(patternImage: UIImage(named: "stripes")!)
        
        flipButton.titleLabel?.font = Style.font(forKey: .bold)
        flipButton.layer.borderColor = Style.color(forKey: .tint).cgColor
        flipButton.layer.borderWidth = 1.0/UIScreen.main.scale
        flipButton.layer.cornerRadius = Constants.commonCornerRadius
        setup()
    }
    
    fileprivate func setup() {
        flipButton.onTap.filter { self.currentAnimator == nil }.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.transform(strongSelf.layout)
        }).disposed(by: disposeBag)
    }
    
    func configure(for imageUris: [URL], layout: Layout) {
        self.layout = layout
        
        // Show or hide transform button. Right now we show it only for double-faced cards.
        switch layout {
        case .transform, .doubleFacedToken:
            flipButton.isHidden = false
            flipButton.title = "Transform"
        case .flip:
            flipButton.isHidden = false
            flipButton.title = "Flip"
        case .planar, .split:
            flipButton.isHidden = false
            flipButton.title = "Rotate"
        default:
            flipButton.isHidden = true
        }
        
        imageView.image = nil
        images.value = []
        
        // Schedule image downloading.
        Observable.from(imageUris.map { return CardImageView.downloader.image(for: $0) })
            .merge(maxConcurrent: 1)
            .filter { $0 != nil }
            .enumerated()
            .map { return ($0, $1!) }
            .toArray().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
                if let strongSelf = self {
                    strongSelf.images.value = $0.map { (index, image) in
                        if index != 0 {
                            return UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored)
                        } else {
                            return image
                        }
                    }
                }})
            .disposed(by: disposeBag)
        
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
    
    func transform(_ layout: Layout) {
        switch layout {
        case .planar, .split:
            currentAnimator = UIViewPropertyAnimator(duration: TimeInterval(CardImageView.defaultAnimationDuration), curve: .linear, animations:nil)
            
            currentAnimator!.addAnimations {
                if (self.flipped.value) {
                    self.imageView.transform = CGAffineTransform.identity
                } else {
                    self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
                }
            }
            
            currentAnimator?.addCompletion( { position in
                self.flipped.value = !self.flipped.value
                self.currentAnimator = nil
            })
            
            currentAnimator!.startAnimation()
        case .flip:
            currentAnimator = UIViewPropertyAnimator(duration: TimeInterval(CardImageView.defaultAnimationDuration), curve: .linear, animations:nil)
            
            currentAnimator!.addAnimations {
                if (self.flipped.value) {
                    self.imageView.transform = CGAffineTransform.identity
                } else {
                    self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
            }
            
            currentAnimator?.addCompletion( { position in
                self.flipped.value = !self.flipped.value
                self.currentAnimator = nil
            })
            
            currentAnimator!.startAnimation()
        case .transform:
            currentAnimator = UIViewPropertyAnimator(duration: TimeInterval(CardImageView.defaultAnimationDuration), curve: .linear, animations:nil)
            let direction: CGFloat = flipped.value ? 1.0 : -1.0
            
            currentAnimator!.addAnimations {
                var transform = self.imageView.layer.transform
                if (transform.m34 == 0) {
                    transform.m34 = -1.0/500;
                }
                transform = CATransform3DRotate(transform, direction * CGFloat.pi / 2.0, 0, 1, 0)
                self.imageView.layer.transform = transform
            }
            
            currentAnimator!.addCompletion({ (position) in
                self.flipped.value = !self.flipped.value
                
                self.currentAnimator = UIViewPropertyAnimator(duration: TimeInterval(CardImageView.defaultAnimationDuration), curve: .linear, animations:nil)
                
                self.currentAnimator!.addAnimations {
                    var transform = self.imageView.layer.transform
                    transform = CATransform3DRotate(transform, direction * CGFloat.pi / 2.0, 0, 1, 0)
                    self.imageView.layer.transform = transform
                }
                
                self.currentAnimator!.addCompletion({ _ in
                    self.currentAnimator = nil
                })
                
                self.currentAnimator!.startAnimation()
            })
            
            currentAnimator!.startAnimation()
        default:
            break
        }
    }
}
