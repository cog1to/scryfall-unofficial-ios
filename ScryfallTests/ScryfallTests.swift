//
//  ScryfallTests.swift
//  ScryfallTests
//
//  Created by Alexander Rogachev on 1/5/18.
//  Copyright © 2018 Alexander Rogachev. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import Scryfall

class ScryfallTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var subscription: Disposable!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        scheduler.scheduleAt(1000) {
            self.subscription.dispose()
        }
        super.tearDown()
    }
    
    func testPrintings() {
        
    }
    
}
