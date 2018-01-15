//
//  UIView+Extension.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/12/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UIView {
    class func rx_animate(withDuration: TimeInterval, animations: @escaping ()->Void) -> Observable<Void> {
        return Observable<Void>.create { (observer) -> Disposable in
            UIView.animate(withDuration: withDuration, animations: animations, completion: { (finished) in
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
