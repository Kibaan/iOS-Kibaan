//
//  CGrectUtilsTest.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/26.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class CGrectUtilsTests: XCTestCase {
    
    func testWidthShortLength() {
        let widthShort: CGRect = CGRect(x: 10, y: 20, width: 30, height: 40)
        XCTAssertEqual(widthShort.shortLength, 30)
    }
    
    func testHeightShortLength() {
        let heightShort: CGRect = CGRect(x: 10, y: 20, width: 40, height: 30)
        XCTAssertEqual(heightShort.shortLength, 30)
    }
    
    // widthとheightが等しい時はheightの数値を返す
    func testEqualShortTest() {
        let equalShort: CGRect = CGRect(x: 10, y: 20, width: 50, height: 50)
        XCTAssertEqual(equalShort.shortLength, 50)
    }
    
    func testWidthLongLength() {
        let widthLong: CGRect = CGRect(x: 10, y: 20, width: 40, height: 30)
        XCTAssertEqual(widthLong.longLength, 40)
    }
    
    func testHeightLongLength() {
        let heightLong: CGRect = CGRect(x: 10, y: 20, width: 30, height: 40)
        XCTAssertEqual(heightLong.longLength, 40)
    }
    
    func testEqualLonglength() {
        let equalLong: CGRect = CGRect(x: 10, y: 20, width: 30, height: 30)
        XCTAssertEqual(equalLong.longLength, 30)
    }
}
