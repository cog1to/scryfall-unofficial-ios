//
//  RoundCornerButton2.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/12/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

@IBDesignable
class RoundCornerButton: UIView {
    internal var leftIcon: UIImageView!
    internal var rightIcon: UIImageView!
    internal var titleLabel: UILabel!
    internal var stackView: UIStackView!
    
    /// PubSub to propagate tap events.
    private var onTapSubject: PublishSubject<Void> = PublishSubject<Void>()
    
    /// Tap event observable.
    public var onTap: Observable<Void> {
        return onTapSubject.asObservable()
    }
    
    @IBInspectable var title: String? {
        didSet {
            if (titleLabel != nil) {
                titleLabel.text = title
            }
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            if (leftIcon != nil) {
                leftIcon.image = leftImage?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            if (rightIcon != nil) {
                rightIcon.image = rightImage?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            self.stackView.tintColor = tintColor
            self.titleLabel.textColor = tintColor
            self.leftIcon.tintColor = tintColor
            self.rightIcon.tintColor = tintColor
            self.layer.borderColor = tintColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // Create layout
        leftIcon = UIImageView()
        leftIcon.contentMode = .center
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        leftIcon.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        leftIcon.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        leftIcon.tintColor = Style.color(forKey: .tint)
        
        rightIcon = UIImageView()
        rightIcon.contentMode = .center
        rightIcon.translatesAutoresizingMaskIntoConstraints = false
        rightIcon.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        rightIcon.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        rightIcon.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        rightIcon.tintColor = Style.color(forKey: .tint)
        
        titleLabel = UILabel()
        titleLabel.text = nil
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(leftIcon)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(rightIcon)
        stackView.spacing = 8.0
        
        // Style layout
        layer.cornerRadius = Constants.commonCornerRadius
        layer.borderWidth = 1.0/UIScreen.main.scale
        layer.borderColor = Style.color(forKey: .tint).cgColor
        titleLabel.textColor = Style.color(forKey: .tint)
        titleLabel.font = Style.font(forKey: .bold)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(4)
        }
        
        // Add gesture recognizer.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchUpInside(recognizer:)))
        tapRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapRecognizer)
    }
}

/// Touch events for active state highlighting
extension RoundCornerButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tintColor = Style.color(forKey: .text)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tintColor = Style.color(forKey: .tint)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tintColor = Style.color(forKey: .tint)
    }
}

/// Tap gesture recognizer
extension RoundCornerButton {
    @objc func touchUpInside(recognizer: UIGestureRecognizer) {
        onTapSubject.onNext(())
    }
}
