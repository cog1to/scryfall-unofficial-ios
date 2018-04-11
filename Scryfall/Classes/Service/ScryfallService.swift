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
    let setsEndpoint = "sets"
    
    func card(set: String, number: Int) -> Observable<Card?> {
        return WebService.json(API: API, endpoint: "\(cardEndpoint)/\(set)/\(number)").map {
            return Card(json: $0)
        }
    }
    
    func search(query: String, sort: SortOrder) -> Observable<CardsList> {
        return WebService.json(API: API, endpoint: "\(searchEndpoint)", query: ["q": query, "order": sort.rawValue]).map {
            guard let list = CardsList(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return list
        }
    }
    
    func search(params: [URLQueryItem], sort: SortOrder) -> Observable<CardsList> {
        var allParams = params
        allParams.append(URLQueryItem(name: "order", value: sort.rawValue))
        
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
}
