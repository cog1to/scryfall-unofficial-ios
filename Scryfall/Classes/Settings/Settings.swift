//
//  Settings.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 2/19/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx

class Settings: NSObject {
    private static let instance = Settings()
    
    private enum keys: String {
        case viewMode = "DisplayMode"
    }
    
    static let shared = Settings()
    
    var viewMode = Variable<DisplayMode>(.cards)
    
    override private init() {
        super.init()
        
        viewMode.value = _viewMode
        viewMode.asObservable().skip(1).subscribe(onNext: {
            self._viewMode = $0
        }).disposed(by: rx.disposeBag)
    }
    
    private var _viewMode: DisplayMode {
        get {
            if let value = UserDefaults.standard.string(forKey: keys.viewMode.rawValue),
                let mode = DisplayMode(rawValue: value) {
                return mode
            } else {
                return .cards
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: keys.viewMode.rawValue)
        }
    }
}
