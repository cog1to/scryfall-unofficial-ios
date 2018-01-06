//
//  WebService.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

enum WebServiceError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON
}

class WebService {
    static func request(API: String, endpoint: String, query: [String: Any] = [:]) -> Observable<JSON> {
        do {
            let items = try query.map { pair -> URLQueryItem in
                guard let v = pair.value as? CustomStringConvertible else {
                    throw WebServiceError.invalidParameter(pair.key, pair.value)
                }
                
                return URLQueryItem(name: pair.key, value: v.description)
            }
            
            return self.request(API: API, endpoint: endpoint, query: items)
        } catch {
            return Observable.error(error)
        }
    }
    
    static func request(API: String, endpoint: String, query: [URLQueryItem]) -> Observable<JSON> {
        do {
            guard let url = URL(string: API)?.appendingPathComponent(endpoint),
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    throw WebServiceError.invalidURL(endpoint)
            }
            
            components.queryItems = query
            
            guard let finalURL = components.url else {
                throw WebServiceError.invalidURL(endpoint)
            }
            
            let request = URLRequest(url: finalURL)
            
            return URLSession.shared.rx.response(request: request).map { _, data -> JSON in
                let jsonObject = JSON(data: data)
                return jsonObject
            }
        } catch {
            return Observable.error(error)
        }
    }
}
