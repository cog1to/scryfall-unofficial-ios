//
//  UINavigationController+Rx.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/4/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class UINavigationControllerTransitionDelegateProxy: DelegateProxy<UINavigationController, UINavigationControllerDelegate>, UINavigationControllerDelegate, DelegateProxyType {
    
    public typealias NavigationTransitionType = (fromVC: UIViewController, toVC: UIViewController, operation: UINavigationControllerOperation)
    
    let transitionSubject = PublishSubject<NavigationTransitionType>()
    
    public typealias ParentObject = UINavigationController
    public typealias Delegate = UINavigationControllerDelegate
    
    public weak private(set) var navigationController: UINavigationController?
    
    public init(navigationController: ParentObject) {
        self.navigationController = navigationController
        super.init(parentObject: navigationController, delegateProxy: UINavigationControllerTransitionDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { UINavigationControllerTransitionDelegateProxy(navigationController: $0) }
    }
    
    static func currentDelegate(for object: UISearchController) -> UISearchResultsUpdating? {
        return object.searchResultsUpdater
    }
    
    static func setCurrentDelegate(_ delegate: UISearchResultsUpdating?, to object: UISearchController) {
        object.searchResultsUpdater = delegate
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionSubject.onNext((fromVC: fromVC, toVC: toVC, operation: operation))
        return nil
    }
}

extension Reactive where Base: UINavigationController {
    public var delegate: DelegateProxy<UINavigationController, UINavigationControllerDelegate> {
        return UINavigationControllerTransitionDelegateProxy.proxy(for: base)
    }
    
    public var transition: Observable<UINavigationControllerTransitionDelegateProxy.NavigationTransitionType> {
        let proxy = UINavigationControllerTransitionDelegateProxy.proxy(for: base)
        return proxy.transitionSubject
    }
}
