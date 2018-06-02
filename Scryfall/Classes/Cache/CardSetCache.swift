//
//  CardSetCache.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 4/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift

class CardSetCache {
    static let instance = CardSetCache()
    
    let scryfall = Scryfall()
    
    func set(forCode code: String) -> Observable<CardSet> {
        return sets().map({ return $0.filter({ set in set.code == code }).first }).flatMap { set -> Observable<CardSet> in
            if let set = set {
                return Observable.just(set)
            } else {
                return self.sets(force: true).map({ return $0.filter({ set in set.code == code }).first! })
            }
        }
    }
    
    private var _sets: [CardSet]?
    
    func sets(force: Bool = false) -> Observable<[CardSet]> {
        if let sets = _sets, !force {
            return Observable<[CardSet]>.just(sets)
        }
        
        let observable = scryfall.sets(force: true).map({ return $0.data }).do(onNext: { [unowned self] in
            self._sets = $0
        })
        
        return observable
    }
    
    // MARK: - Variable bindings
}
