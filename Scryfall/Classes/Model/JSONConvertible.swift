//
//  JSONConvertible.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/11/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONConvertible {
    init?(json: JSON)
}
