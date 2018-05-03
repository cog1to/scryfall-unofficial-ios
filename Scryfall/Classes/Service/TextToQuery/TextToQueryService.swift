//
//  TextToQueryService.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 4/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift

class TextToQueryService: TextToQueryServiceType {
    func parse(query: String) -> Observable<QueryToken?> {
        return Observable.just(nil)
    }
}
