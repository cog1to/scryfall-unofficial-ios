//
//  ScryfallServiceType.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift

/**
 * Scryfall service protocol.
 */
protocol ScryfallServiceType {
    /**
     * Returns data for a single card given a set code and set number of a card.
     *
     * - parameter set: Short set code string
     * - parameter number: Card number within the set.
     * - returns: An observable emitting downloaded card data.
     */
    func card(set: String, number: Int) -> Observable<Card?>
    
    /**
     * Returns card list for given search query string.
     *
     * - parameter query: Query string.
     * - parameter sort: Sort order.
     * - returns: An observable emitting downloaded cards data.
     */
    func search(query: String, sort: SortOrder) -> Observable<CardsList>
    
    /**
     * Returns card list for given search query parameters.
     *
     * - parameter params: An array of searchquery items to use for the request.
     * - parameter sort: Sort order.
     * - returns: An observable emitting downloaded cards list data.
     */
    func search(params: [URLQueryItem], sort: SortOrder) -> Observable<CardsList>
    
    /**
     * Returns a list of known sets.
     *
     * - returns: An observable emitting array of known sets.
     */
    func sets() -> Observable<RemoteList<CardSet>>
}


extension ScryfallServiceType {
    func search(query: String) -> Observable<CardsList> {
        return search(query: query, sort: .name)
    }
    
    func search(params: [URLQueryItem]) -> Observable<CardsList> {
        return search(params: params, sort: .name)
    }
}
