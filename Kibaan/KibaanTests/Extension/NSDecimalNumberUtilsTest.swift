//  Created by Yamamoto Keita on 2018/08/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class NSDecimalNumberUtilsTest: XCTestCase {
    
    func testRoundDown() {
        let decimal = NSDecimalNumber(string: "1.98765")
        
        XCTAssertEqual(decimal.roundDown().stringValue, "1")
        XCTAssertEqual(decimal.roundDown(1).stringValue, "1.9")
        XCTAssertEqual(decimal.roundDown(2).stringValue, "1.98")
    }
    
    func testRoundUp() {
        let decimal = NSDecimalNumber(string: "1.12345")
        
        XCTAssertEqual(decimal.roundUp().stringValue, "2")
        XCTAssertEqual(decimal.roundUp(1).stringValue, "1.2")
        XCTAssertEqual(decimal.roundUp(2).stringValue, "1.13")
    }
    
    func testRoundPlain() {
        var decimal = NSDecimalNumber(string: "1.432")
        XCTAssertEqual(decimal.roundPlain().stringValue, "1")
        XCTAssertEqual(decimal.roundPlain(1).stringValue, "1.4")
        XCTAssertEqual(decimal.roundPlain(2).stringValue, "1.43")
        
        decimal = NSDecimalNumber(string: "1.567")
        XCTAssertEqual(decimal.roundPlain().stringValue, "2")
        XCTAssertEqual(decimal.roundPlain(1).stringValue, "1.6")
        XCTAssertEqual(decimal.roundPlain(2).stringValue, "1.57")

    }
    
    // MARK: - Comparable

    func testOrderAcendingLess() {
        let LeftDecimal = NSDecimalNumber(string: "1.2")
        let RightDecimal = NSDecimalNumber(string: "1.3")
        XCTAssertTrue(LeftDecimal < RightDecimal)
    }
    
    func testSameValueOrderAcendingLess() {
        let LeftDecimal = NSDecimalNumber(string: "1.51")
        let RightDecimal = NSDecimalNumber(string: "1.51")
        XCTAssertFalse(LeftDecimal < RightDecimal)
    }
    
    func testEqual() {
        let LeftDecimal = NSDecimalNumber(string: "1.51")
        let RightDecimal = NSDecimalNumber(string: "1.51")
        XCTAssertTrue(LeftDecimal == RightDecimal)
    }
    
    func testNotEqual() {
        let LeftDecimal = NSDecimalNumber(string: "2.5")
        let RightDecimal = NSDecimalNumber(string: "2.512")
        XCTAssertFalse(LeftDecimal == RightDecimal)
    }
}
