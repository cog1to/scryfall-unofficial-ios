//
//  DateFormat.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 5/30/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation

class DateFormat {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static func date(from dateString: String?) -> Date? {
        guard let value = dateString else {
            return nil
        }
        
        return DateFormat.dateFormatter.date(from: value)
    }
    
    static func displayString(from date: Date) -> String {
        return DateFormat.dateFormatter.string(from: date)
    }
}
