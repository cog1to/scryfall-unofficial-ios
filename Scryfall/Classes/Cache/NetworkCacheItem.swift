//
//  NetworkCacheItem.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/25/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Network cache item.
 */
class NetworkCacheItem: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var data: Data? = nil
    @objc dynamic var date: Date = Date()
    
    override class func primaryKey() -> String? {
        return "url"
    }
}
