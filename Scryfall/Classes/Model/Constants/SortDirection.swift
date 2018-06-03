//
//  SortDirection.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/3/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

enum SortDirection: String, StringRepresentableOption {
    case auto = "auto"
    case ascending = "asc"
    case descending = "desc"
    
    var name: String {
        return self.rawValue.capitalized
    }
    
    static var all: [SortDirection] {
        return [.auto, .ascending, .descending]
    }
}
