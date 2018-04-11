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
        return scryfall.sets().map({ return $0.data }).map({ return $0.filter({ set in set.code == code }).first }).flatMap { set -> Observable<CardSet> in
            if let set = set {
                return Observable.just(set)
            } else {
                return self.scryfall.sets(force: true).map({ return $0.data }).map({ return $0.filter({ set in set.code == code }).first! })
            }
        }
    }
}
