//
//  UILayoutPriorityUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/28.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class UILayoutPriorityUtilsTests: XCTestCase {
    
    
    func testHigherPriority() {
        let higher: UILayoutPriority = UILayoutPriority.highest
        XCTAssertEqual(higher, UILayoutPriority(999))
    }
    
    func testLowerPriority() {
        let lower: UILayoutPriority = UILayoutPriority.lowest
        XCTAssertEqual(lower, UILayoutPriority(1))
    }
}
