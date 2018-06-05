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

/// Web service errors
enum WebServiceError: Error {
    
    /// Badly formatted URL
    case invalidURL(String)
    
    /// Bad parameter (Can't properly convert to string)
    case invalidParameter(String, Any)
    
    /// Failed to parse JSON response
    case invalidJSON
    
    /// Got wrong status code
    case badStatusCode(Int)
}

/**
 * Very basic web component that can perform simple calls to a JSON-powered API.
 */
class WebService {
    
    /**
     * Tries to GET a JSON response from given endpoint.
     *
     * - parameter API: Base service URL
     * - parameter endpoint: specific API endpoint to query
     * - parameter query: query parameters
     * - returns: An observable holding the result of performing given web request
     */
    static func json(API: String, endpoint: String, query: [String: Any] = [:], force: Bool = false) -> Observable<JSON> {
        do {
            // Convert raw query values to URLQueryItems
            let items = try query.map { pair -> URLQueryItem in
                guard let v = pair.value as? CustomStringConvertible else {
                    throw WebServiceError.invalidParameter(pair.key, pair.value)
                }
                
                return URLQueryItem(name: pair.key, value: v.description)
            }
            
            // Perform the request.
            return self.json(API: API, endpoint: endpoint, query: items, force: force)
        } catch {
            return Observable.error(error)
        }
    }
    
    /**
     * Tries to GET a JSON response from given endpoint.
     *
     * - parameter API: Base service URL
     * - parameter endpoint: specific API endpoint to query
     * - parameter query: query items
     * - returns: An observable holding the result of performing given web request
     */
    static func json(API: String, endpoint: String, query: [URLQueryItem], force: Bool = false) -> Observable<JSON> {
        do {
            guard let finalURL = url(API: API, endpoint: endpoint, query: query) else {
                throw WebServiceError.invalidURL(endpoint)
            }
            
            if !force, let cachedResponse = NetworkCache.instance.data(forURL: finalURL) {
                return Observable.just(cachedResponse).map { data -> JSON in
                    return JSON(data: data)
                }
            } else {
                let request = URLRequest(url: finalURL)
                
                return URLSession.shared.rx.response(request: request)
                    .map { response, data -> Data in
                        guard 200..<300 ~= response.statusCode else {
                            throw WebServiceError.badStatusCode(response.statusCode)
                        }
                        
                        return data
                    }
                    .do(onNext: {
                        NetworkCache.instance.save(data: $0, forURL: finalURL)
                    })
                    .map { data -> JSON in
                        let jsonObject = JSON(data: data)
                        return jsonObject
                    }
            }
        } catch {
            return Observable.error(error)
        }
    }
        
    static private func url(API: String, endpoint: String, query: [String: Any] = [:]) throws -> URL? {
        // Convert raw query values to URLQueryItems
        let items = try query.map { pair -> URLQueryItem in
            guard let v = pair.value as? CustomStringConvertible else {
                throw WebServiceError.invalidParameter(pair.key, pair.value)
            }
            
            return URLQueryItem(name: pair.key, value: v.description)
        }
        
        return url(API: API, endpoint: endpoint, query: items)
    }
    
    static private func url(API: String, endpoint: String, query: [URLQueryItem]) -> URL? {
        guard let url = URL(string: API)?.appendingPathComponent(endpoint),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return nil
        }
        
        components.queryItems = query
        // Replace all "+" in the percentEncodedQuery with "%2B" (a percent-encoded +)
        // and then replace all "!" with "%21" (a percent-encoded !)
        // and then replace all "%20" (a percent-encoded space) with "+"
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
            .replacingOccurrences(of: "!", with: "%21")
            .replacingOccurrences(of: "%20", with: "+")
        
        guard let finalURL = components.url else {
            return nil
        }
        
        return finalURL
    }
}
