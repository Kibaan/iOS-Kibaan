//
//  NSLayoutDimensionUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2019/01/07.
//  Copyright © 2019年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class NSLayoutDimensionUtilsTests: XCTestCase {
    
    func testActivateConstraint() {
        let view1 = UIView(frame: .zero)
        let convertedConstraint = view1.widthAnchor.activateConstraint(equalToConstant: 10.0, priority: .lowest)
        
        XCTAssertEqual(convertedConstraint.constant, 10.0)
        XCTAssertEqual(convertedConstraint.priority, UILayoutPriority.lowest)
        XCTAssertEqual(convertedConstraint.isActive, true)
    }
}



