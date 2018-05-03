//
//  SpeechToQueryServiceType.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 4/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift

protocol TextToQueryServiceType {
    func parse(query: String) -> Observable<QueryToken?>;
}
