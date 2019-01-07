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
        
        floatValue = CGFloat(50)
        XCTAssertEqual(floatValue.stringValue, "50.0")
        
        floatValue = CGFloat(-50)
        XCTAssertEqual(floatValue.stringValue, "-50.0")
        
        floatValue = CGFloat(.infinity * 1.0)
        XCTAssertEqual(floatValue.stringValue, "inf")
        
        floatValue = CGFloat(.infinity * -1.0)
        XCTAssertEqual(floatValue.stringValue, "-inf")
        
        floatValue = CGFloat.nan
        XCTAssertEqual(floatValue.stringValue, "nan")
    }

    func testStringValueDecimalLength() {
        var floatValue: CGFloat = 0
        XCTAssertEqual(floatValue.stringValue(decimalLength: 0), "0")
        XCTAssertEqual(floatValue.stringValue(decimalLength: 1), "0.0")
        
        floatValue = CGFloat(1.2568)
        XCTAssertEqual(floatValue.stringValue(decimalLength: 2), "1.26")
        XCTAssertEqual(floatValue.stringValue(decimalLength: 3), "1.257")
        
        floatValue = CGFloat(-1.2568)
        XCTAssertEqual(floatValue.stringValue(decimalLength: 4), "-1.2568")
        XCTAssertEqual(floatValue.stringValue(decimalLength: 1), "-1.3")
        
        floatValue = CGFloat(1.123456789)
        XCTAssertEqual(floatValue.stringValue(decimalLength: 9), "1.123456789")
        XCTAssertEqual(floatValue.stringValue(decimalLength: 10), "1.1234567890")
        
        floatValue = CGFloat(100)
        XCTAssertEqual(floatValue.stringValue(decimalLength: 2), "100.00")
        XCTAssertEqual(floatValue.stringValue(decimalLength: -1), "100")
        
        floatValue = CGFloat.nan
        XCTAssertEqual(floatValue.stringValue(decimalLength: 0), "nan")
        XCTAssertEqual(floatValue.stringValue(decimalLength: 2), "nan")
    }
}
