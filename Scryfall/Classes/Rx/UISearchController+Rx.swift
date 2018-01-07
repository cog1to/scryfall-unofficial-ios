//
//  UISearchController+Rx.swift
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
 * UISearchController extension for RxSwift to expose UISearchResultsUpdating methods.
 */
class UISearchControllerUpdaterDelegateProxy: DelegateProxy<UISearchController, UISearchResultsUpdating>, UISearchResultsUpdating, DelegateProxyType {
    
    typealias ParentObject = UISearchController
    typealias Delegate = UISearchResultsUpdating
    
    public weak private(set) var searchController: UISearchController?
    
    public init(searchController: ParentObject) {
        self.searchController = searchController
        super.init(parentObject: searchController, delegateProxy: UISearchControllerUpdaterDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { UISearchControllerUpdaterDelegateProxy(searchController: $0) }
    }
    
    static func currentDelegate(for object: UISearchController) -> UISearchResultsUpdating? {
        return object.searchResultsUpdater
    }
    
    static func setCurrentDelegate(_ delegate: UISearchResultsUpdating?, to object: UISearchController) {
        object.searchResultsUpdater = delegate
    }
    
    let searchSubject = PublishSubject<String?>()
    
    func updateSearchResults(for searchController: UISearchController) {
        searchSubject.onNext(searchController.searchBar.text)
    }
}

extension Reactive where Base: UISearchController {
    public var updateSearchResults: Observable<String?> {
        let proxy = UISearchControllerUpdaterDelegateProxy.proxy(for: base)
        return proxy.searchSubject
    }
}

