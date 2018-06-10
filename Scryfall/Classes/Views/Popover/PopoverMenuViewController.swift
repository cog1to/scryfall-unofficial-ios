//
//  PopoverMenuView.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/28/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import UIKit
import Popover
import RxSwift
import RxCocoa
import Action
import SnapKit

/// Popover menu view controller.
class PopoverMenuViewController: NSObject {
    
    /// Menu cell identifier.
    let popoverCellIdentifier = "PopoverCell"
    
    /// Items to show in the menu.
    let items: [PopoverMenuItem]
    
    /// Popover instance.
    var popover: Popover!
    
    /// Dispose bag.
    let bag = DisposeBag()
    
    fileprivate var popoverOptions: [PopoverOption] = [
        .sideEdge(5),
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    init(items: [PopoverMenuItem]) {
        self.items = items
        super.init()
    }
    
    func show(from view: UIView, itemSelected: Action<PopoverMenuItem, Void>) {
        let popover = Popover(options: popoverOptions)
        
        let stackView = UIStackView(frame: CGRect.zero)
        stackView.axis = .vertical
        
        let itemViews = items.map { item -> UIView in
            // Create an option label.
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = Style.font(forKey: .text)
            label.text = item.name
            
            // Create a label container for stack view.
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            // Bind label container to label.
            label.snp.makeConstraints({ make -> Void in
                make.left.equalToSuperview().inset(10)
                make.right.equalToSuperview().inset(10)
                make.top.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().inset(0)
            })
            
            // Add tap listener.
            view.isUserInteractionEnabled = true
            view.rx.tapGesture().when(.recognized).observeOn(MainScheduler.instance).subscribe(onNext: { _ in
                popover.dismiss()
                itemSelected.execute(item)
            }).disposed(by: bag)
            
            return view
        }
        
        for view in itemViews {
            stackView.addArrangedSubview(view)
        }
        
        // Resize stack view with auto-layout.
        let size = stackView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        stackView.frame = frame
        
        // Popover has a bug with laying out content view starting with arrow's origin.
        // To fix that we wrap content view inside another view with top offset.
        let containerView = UIView(frame: CGRect.zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().inset(0)
            make.right.equalToSuperview().inset(0)
            make.top.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(0)
        }
        
        let containerSize = containerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let containerFrame = CGRect(origin: CGPoint.zero, size: containerSize)
        containerView.frame = containerFrame
        
        self.popover = popover
        self.popover.show(containerView, fromView: view)
    }
}
