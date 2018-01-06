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
    
    func card(set: String, number: Int) -> Observable<Card?> {
        return WebService.request(API: API, endpoint: "\(cardEndpoint)/\(set)/\(number)").map {
            return Card(json: $0)
        }
    }
    
    func search(query: String) -> Observable<CardsList> {
        return WebService.request(API: API, endpoint: "\(searchEndpoint)", query: ["q": query]).map {
            guard let list = CardsList(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return list
        }
    }
    
    func search(params: [URLQueryItem]) -> Observable<CardsList> {
        return WebService.request(API: API, endpoint: "\(searchEndpoint)", query: params).map {
            guard let list = CardsList(json: $0) else {
                throw WebServiceError.invalidJSON
            }
            
            return list
        }
    }
    
}
