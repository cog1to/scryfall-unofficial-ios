//
//  UIBarButtonItem+Extension.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 6/4/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    var view: UIView? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view
    }
}
