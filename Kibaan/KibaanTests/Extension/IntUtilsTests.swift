//  Created by Yamamoto Keita on 2018/08/09.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class IntUtilsTests: XCTestCase {
    
    func testOptionalStringValue() {
        let i: Int? = 123
        XCTAssertEqual(i.stringValue, "123")
    }
    
    func testOptionalMinusStringValue() {
        let i: Int? = -123
        XCTAssertEqual(i.stringValue, "-123")
    }
    
    func testOptionalStringValueNil() {
        let i: Int? = nil
        XCTAssertEqual(i.stringValue, "")
    }
    
    func testStringValue() {
        let i: Int = 123
        XCTAssertEqual(i.stringValue, "123")
    }
    
    func testMinusStringValue() {
        let i: Int = -123
        XCTAssertEqual(i.stringValue, "-123")
    }
    
    func testIniStringValue() {
        let i: Int = Int()
        XCTAssertEqual(i.stringValue, "0")
    }
    
    func testRandom() {
        let min = -3
        let max = 3
        
        // test range
        for _ in 1...10 {
            let random = Int.random(min: min, max: max)
            XCTAssert(min <= random && random <= max)
        }
        
        // test limit
        var random = Int.random(min: 0, max: 0)
        XCTAssertEqual(random, 0)
        
        // test limit1
        random = Int.random(min: 1, max: 1)
        XCTAssertEqual(random, 1)
    }
    
    func testRandomFill() {
        var hasZero = false
        var hasOne = false
        
        for _ in 1...30 {
            let random = Int.random(min: 0, max: 1)
            
            if random == 0 {
                hasZero = true
            } else if random == 1 {
                hasOne = true
            }
        }
        
        assert(hasZero && hasOne)
    }
}
