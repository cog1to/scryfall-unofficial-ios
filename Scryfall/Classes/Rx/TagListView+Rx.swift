//
//  TagListView+Rx.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/5/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TagListViewDelegateProxy: DelegateProxy<TagListView, TagListViewDelegate>, TagListViewDelegate, DelegateProxyType {
    typealias ParentObject = TagListView
    typealias Delegate = TagListViewDelegate
    
    public weak private(set) var tagListView: TagListView?
    
    public init(tagListView: ParentObject) {
        self.tagListView = tagListView
        super.init(parentObject: tagListView, delegateProxy: TagListViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { TagListViewDelegateProxy(tagListView: $0) }
    }
    
    static func currentDelegate(for object: TagListView) -> TagListViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: TagListViewDelegate?, to object: TagListView) {
        object.delegate = delegate
    }
    
    let tapSubject = PublishSubject<TagView>()
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tapSubject.onNext(tagView)
    }
}

extension Reactive where Base: TagListView {
    public var tagTapped: Observable<TagView> {
        let proxy = TagListViewDelegateProxy.proxy(for: base)
        return proxy.tapSubject
    }
}
