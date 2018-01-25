//
//  NetworkCache.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/25/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Requests cache.
 */
class NetworkCache {
    
    static let instance = NetworkCache()
    
    /// Cache expiration time.
    private let cacheDuration = TimeInterval(60 * 60 * 24)
    
    /// Cache limit size.
    private let cacheLimit = 50
    
    func data(forURL url: URL) -> Data? {
        let result = withRealm("reading cache") { realm -> Data? in
            let cache = realm.objects(NetworkCacheItem.self).filter(NSPredicate(format: "url == %@", argumentArray: [url.absoluteString])).first
            if let cache = cache {
                if (cache.date.addingTimeInterval(cacheDuration).compare(Date()) == .orderedAscending) {
                    print("cache for \(url.absoluteString) is outdated")
                    try realm.write {
                        realm.delete(cache)
                    }
                    return nil
                } else {
                    print("returning cache for \(url.absoluteString)")
                    return cache.data
                }
            } else {
                print("no cache for \(url.absoluteString)")
                return nil
            }
        }
        
        if let result = result {
            return result
        } else {
            return nil
        }
    }
    
    func save(data: Data, forURL url: URL) {
        let _ = withRealm("saving cache") { realm -> Void in
            let cache = realm.objects(NetworkCacheItem.self).filter(NSPredicate(format: "url == %@", argumentArray: [url.absoluteString])).first
            if let cache = cache {
                print("cache for \(url.absoluteString) exists, updating")
                try realm.write {
                    cache.data = data
                    cache.date = Date()
                }
            } else {
                print("saving cache for \(url.absoluteString)")
                
                let allItems = realm.objects(NetworkCacheItem.self).sorted(byKeyPath: "date", ascending: false)
                if allItems.count >= cacheLimit, let first = allItems.first {
                    print("cache is full, deleting the oldest item")
                    realm.delete(first)
                }
                
                let newItem = NetworkCacheItem()
                newItem.data = data
                newItem.date = Date()
                try realm.write {
                    newItem.url = url.absoluteString
                    realm.add(newItem)
                }
            }
        }
    }
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    private init() { }
}
