//
//  ScryfallServiceType.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift

protocol ScryfallServiceType {
    func card(set: String, number: Int) -> Observable<Card?>
    func search(query: String) -> Observable<CardsList>
    func search(params: [URLQueryItem]) -> Observable<CardsList>
}
