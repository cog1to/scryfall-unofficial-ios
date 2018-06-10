//
//  ScryfallService.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift

class Scryfall: ScryfallServiceType {
    let API = "https://api.scryfall.com"
    let cardEndpoint = "cards"
    let searchEndpoint = "cards/search"
    let randomEndpoint = "cards/random"
    let setsEndpoint = "sets"
    
    func card(set: String, number: Int) -> Observable<Card?> {
        return WebService.json(API: API, endpoint: "\(cardEndpoint)/\(set)/\(number)").map {
            return Card(json: $0)
        }
    }
    
    func search(query: String, sort: CardSortOrder, direction: SortDirection) -> Observable<CardsList> {
        var params = ["q": query, "order": sort.rawValue]
        if (direction != .auto) {
            params["dir"] = direction.rawValue
        }
        
        return WebService.json(API: API, endpoint: "\(searchEndpoint)", query: params).map {
            guard let list = CardsList(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return list
        }
    }
    
    func search(params: [URLQueryItem], sort: CardSortOrder, direction: SortDirection) -> Observable<CardsList> {
        var allParams = params
        allParams.append(URLQueryItem(name: "order", value: sort.rawValue))
        if (direction != .auto) {
            allParams.append(URLQueryItem(name: "dir", value: direction.rawValue))
        }
        
        return WebService.json(API: API, endpoint: "\(searchEndpoint)", query: allParams).map {
            guard let list = CardsList(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return list
        }
    }
    
    func sets(force: Bool = false) -> Observable<RemoteList<CardSet>> {
        return WebService.json(API: API, endpoint: "\(setsEndpoint)", force: force).map {
            guard let list = RemoteList<CardSet>(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return list
        }
    }
    
    func sets(order: SetSortOrder, type: CardSetType, force: Bool = false) -> Observable<RemoteList<CardSet>> {
        let params = [URLQueryItem(name: "order", value: order.rawValue), URLQueryItem(name: "type", value: type.rawValue)]
        
        return WebService.json(API: API, endpoint: "\(setsEndpoint)", query: params, force: force).map {
            guard let list = RemoteList<CardSet>(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return list
        }
    }
    
    func rulings(card: Card, force: Bool) -> Observable<RulingsList> {
        return WebService.json(API: API, endpoint: "\(cardEndpoint)/\(card.setCode)/\(card.collectorsNumber)/rulings").map {
            guard let list = RulingsList(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return list
        }
    }
    
    func random() -> Observable<Card> {
        return WebService.json(API: API, endpoint: "\(randomEndpoint)").map {
            guard let card = Card(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return card
        }
    }
}
