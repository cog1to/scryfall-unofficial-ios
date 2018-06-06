//
//  RulingsList.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/6/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import SwiftyJSON

class RulingsList: RemoteList<CardRuling> {
    required init?(json: JSON) {
        super.init(json: json)
    }
}
