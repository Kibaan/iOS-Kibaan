//
//  UIFontUtilsTest.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/25.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan


class UIFontUtilsTests: XCTestCase {
    
    func testIsBold() {
        XCTAssertEqual(UIFont.boldSystemFont(ofSize: UIFont.labelFontSize).isBold, true)
    }
    
    func testIsNotBold() {
        XCTAssertEqual(UIFont.italicSystemFont(ofSize: UIFont.labelFontSize).isBold, false)
    }
}
