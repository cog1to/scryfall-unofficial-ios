//
//  CardRuling.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardRuling: JSONConvertible {
    var source: String
    var comment: String
    var publishedAt: Date?
    
    required init?(json: JSON) {
        guard let comment = json["comment"].string, let source = json["source"].string else {
            return nil
        }
        
        self.comment = comment
        self.source = source
        
        if let date = json["published_at"].string, let dateValue = DateFormat.date(from: date) {
            self.publishedAt = dateValue
        }
    }
}
