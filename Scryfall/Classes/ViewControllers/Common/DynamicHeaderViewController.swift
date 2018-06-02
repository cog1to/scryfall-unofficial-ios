//
//  DynamicHeaderViewController.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/2/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DynamicHeaderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchOptionsView: ListSettingsHeaderView!
    @IBOutlet var searchOptionsConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraints: Array<NSLayoutConstraint>!
    
    internal var disposeBag = DisposeBag()
    
    fileprivate var maxSettingsHeaderHeight: CGFloat = 0
    fileprivate var settingsHeaderConstraint: NSLayoutConstraint!
    fileprivate var previousScrollOffset: CGFloat = 0
    
    struct TopGuide {
        let guide: Any?
        let attribute: NSLayoutAttribute
    }
    
    var topGuide: TopGuide {
        return TopGuide(guide: view.safeAreaLayoutGuide, attribute: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.didScroll.subscribe(onNext: { [unowned self] in
            self.scrollViewDidScroll(self.tableView)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (settingsHeaderConstraint == nil) {
            maxSettingsHeaderHeight = searchOptionsView.frame.size.height
            settingsHeaderConstraint = NSLayoutConstraint(item: searchOptionsView, attribute: .bottom, relatedBy: .equal, toItem: topGuide.guide, attribute: topGuide.attribute, multiplier: 1.0, constant: maxSettingsHeaderHeight)
            view.addConstraint(settingsHeaderConstraint)
        }
        
        searchOptionsConstraint.isActive = false
    }
}

extension DynamicHeaderViewController {
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let settingsHeaderConstraint = settingsHeaderConstraint else {
            return
        }
        
        guard canAnimateHeader(scrollView) else {
            return
        }
        
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        var newHeight = settingsHeaderConstraint.constant
        if isScrollingDown {
            newHeight = max(0, settingsHeaderConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeight = min(maxSettingsHeaderHeight, settingsHeaderConstraint.constant + abs(scrollDiff))
        }
        
        if newHeight != settingsHeaderConstraint.constant {
            settingsHeaderConstraint.constant = newHeight
            scrollView.setContentOffset(CGPoint(x: 0, y: previousScrollOffset), animated: false)
        }
        
        previousScrollOffset = scrollView.contentOffset.y
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + settingsHeaderConstraint.constant
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
}
