//
//  UIImageUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/26.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class UIImageUtilsTests: XCTestCase {
    
    func testMakeColorImageサイズ指定あり() {
        UIGraphicsBeginImageContext(CGSize(width: 20, height: 30))
        let image = UIImage.makeColorImage(color: .red, size: CGSize(width: 20, height: 30))
        if let image = image {
            XCTAssertEqual(image.size.width, 20)
            XCTAssertEqual(image.size.height, 30)
        } else {
            XCTFail()
        }
        UIGraphicsEndImageContext()
    }
    func testMakeColorImageサイズ指定なし() {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let image = UIImage.makeColorImage(color: .red)
        if let image = image {
            XCTAssertEqual(image.size.width, 1)
            XCTAssertEqual(image.size.height, 1)
        } else {
            XCTFail()
        }
        UIGraphicsEndImageContext()
    }
}
