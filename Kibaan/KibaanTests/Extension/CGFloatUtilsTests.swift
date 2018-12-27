//
//  CGFloatUtilsTest.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/26.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class CGFloatUtilsTests: XCTestCase {
    
    func testStringValue() {
        var floatValue: CGFloat = CGFloat(0)
        XCTAssertEqual(floatValue.stringValue, "0.0")
        
        floatValue = CGFloat(1.25)
        XCTAssertEqual(floatValue.stringValue, "1.25")
        
        floatValue = CGFloat(.infinity * 1.0)
        XCTAssertEqual(floatValue.stringValue, "inf")
        
        floatValue = CGFloat(.infinity * -1.0)
        XCTAssertEqual(floatValue.stringValue, "-inf")
        
        floatValue = CGFloat(50)
        XCTAssertEqual(floatValue.stringValue, "50.0")
        
        floatValue = CGFloat(-50)
        XCTAssertEqual(floatValue.stringValue, "-50.0")
    }
    
    func testNanStringValue() {
        var nanFloat: CGFloat = 0.0 * .infinity
        XCTAssertEqual(nanFloat.stringValue(decimalLength: 0), "nan")
        
        nanFloat = -0.0 * .infinity
        XCTAssertEqual(nanFloat.stringValue(decimalLength: 0), "nan")
    }
    
    func testNotNanStringValue() {
        var notNanFloat: CGFloat = 0
        XCTAssertEqual(notNanFloat.stringValue(decimalLength: 0), "0")
        
        notNanFloat = CGFloat(1.2568)
        XCTAssertEqual(notNanFloat.stringValue(decimalLength: 2), "1.26")
        
        notNanFloat = CGFloat(-1.2568)
        XCTAssertEqual(notNanFloat.stringValue(decimalLength: 3), "-1.257")
        
        notNanFloat = CGFloat(1.123456789)
        XCTAssertEqual(notNanFloat.stringValue(decimalLength: 9), "1.123456789")
    }
}
