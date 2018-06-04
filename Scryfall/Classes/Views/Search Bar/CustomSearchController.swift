//
//  CustomSearchController.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/4/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

class CustomSearchController: UISearchController, UISearchBarDelegate {
    lazy var _searchBar: CustomSearchBar = { [unowned self] in
        let result = CustomSearchBar(frame: CGRect.zero)
        result.delegate = self        
        return result
    }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
}
