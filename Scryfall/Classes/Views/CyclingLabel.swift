//
//  LoadingView.swift
//  Scryfall
//
//  Created by Alexander Rogachev on 1/9/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class CyclingLabel: UILabel {
    var values: [String]?
    var interval: TimeInterval?
    var rx_animating = Variable<Bool>(false)
    
    var bag = DisposeBag()
    
    private var currentIndex: Int = 0
    
    override func awakeFromNib() {
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    private func setup() {
        rx_animating.asObservable().distinctUntilChanged().subscribe(onNext: { [unowned self] value in
            if value {
                self.startRepeating()
            } else {
                self.stop()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    private func startRepeating() {
        guard let values = values, values.count > 0, let interval = interval, interval > 0 else {
            return
        }
        
        guard values.count > 1 else {
            self.text = values[0]
            return
        }
        
        text = values[currentIndex]
        
        Observable<Int>.interval(interval, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self, let values = strongSelf.values else {
                return
            }
            
            strongSelf.currentIndex += 1
            if (strongSelf.currentIndex == values.count) {
                strongSelf.currentIndex = 0
            }
            
            strongSelf.text = values[strongSelf.currentIndex]
        }).disposed(by: bag)
    }
    
    private func stop() {
        bag = DisposeBag()
    }
}
