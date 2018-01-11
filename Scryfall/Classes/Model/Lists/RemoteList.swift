//
//  RemoteList.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class RemoteList<T>: JSONConvertible where T: JSONConvertible {
    var data: [T]
    var warnings: [String]?
    var hasMore: Bool
    var nextPage: URL?
    
    required init?(json: JSON) {
        guard let data = json["data"].array, let hasMore = json["has_more"].bool else {
            return nil
        }
        
        self.hasMore = hasMore
        self.data = data.map { T.init(json: $0)! }
        self.nextPage = json["next_page"].url
    
        if let warnings = json["warnings"].array {
            self.warnings = warnings.map { return $0.string! }
        }
    }
}
