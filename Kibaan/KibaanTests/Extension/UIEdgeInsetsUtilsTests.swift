//
//  UIEdgeInsetsUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/26.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class UIEdgeInsetsUtilsTests: XCTestCase {
    
    func testEdgeInit() {
        let edgeInit: UIEdgeInsets = UIEdgeInsets(size: 20)
        XCTAssertEqual(edgeInit, UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    func testEdgeInit小数点あり() {
        let edgeInit: UIEdgeInsets = UIEdgeInsets(size: 20.5)
        XCTAssertEqual(edgeInit, UIEdgeInsets(top: 20.5, left: 20.5, bottom: 20.5, right: 20.5))
    }
    
    func testScaled() {
        let edgeInit: UIEdgeInsets = UIEdgeInsets(size: 10)
        let scale = edgeInit.scaled(2)
        XCTAssertEqual(scale, UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    func testScaledで小数あり() {
        let edgeInit: UIEdgeInsets = UIEdgeInsets(size: 10)
        let scale = edgeInit.scaled(2.5)
        XCTAssertEqual(scale, UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25))
    }
}
