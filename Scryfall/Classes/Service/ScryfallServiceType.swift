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
     * - parameter direction: Sort direction.
     * - returns: An observable emitting downloaded cards data.
     */
    func search(query: String, sort: CardSortOrder, direction: SortDirection) -> Observable<CardsList>
    
    /**
     * Returns card list for given search query parameters.
     *
     * - parameter params: An array of searchquery items to use for the request.
     * - parameter sort: Sort order.
     * - parameter direction: Sort direction.
     * - returns: An observable emitting downloaded cards list data.
     */
    func search(params: [URLQueryItem], sort: CardSortOrder, direction: SortDirection) -> Observable<CardsList>
    
    /**
     * Returns a list of all known sets.
     *
     * - parameter force: Forces reloading of the cached response.
     * - returns: An observable emitting array of known sets.
     */
    func sets(force: Bool) -> Observable<RemoteList<CardSet>>
    
    /**
     * Returns a subset of card sets of given type.
     *
     * - parameter order: Sorting order
     * - parameter type: Set type.
     * - parameter force: Flag indicating that method should overwrite existing cache.
     * - returns: An observable emitting a list of sets matching search criteria.
     */
    func sets(order: SetSortOrder, type: CardSetType, force: Bool) -> Observable<RemoteList<CardSet>>
    
    /**
     * Returns a list of rulings.
     *
     * - parameter card: Card to fetch.
     * - parameter force: Flag indicating that method should ignore cache and reload request.
     * - returns: An observable emitting array of card rulings.
     */
    func rulings(card: Card, force: Bool) -> Observable<RulingsList>
    
    /**
     * Returns a random card.
     */
    func random() -> Observable<Card>
}


extension ScryfallServiceType {
    
    /**
     * Convenience search method with default sort and direction values.
     * Default sort type: by card name. Default direction: auto.
     *
     * parameter query: Query string.
     * returns: An observable containg list of search results.
     */
    func search(query: String) -> Observable<CardsList> {
        return search(query: query, sort: .name, direction: .auto)
    }
    
    /**
     * Convenience search method with default sort and direction values.
     * Default sort type: by card name. Default direction: auto.
     *
     * parameter params: List of query items.
     * returns: An observable containg list of search results.
     */
    func search(params: [URLQueryItem]) -> Observable<CardsList> {
        return search(params: params, sort: .name, direction: .auto)
    }
}
