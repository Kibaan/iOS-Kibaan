//
//  HTTPTextTaskTests.swift
//  KibaanTests
//
//  Created by altonotes on 2018/12/28.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class HTTPTextTaskTests: XCTestCase {
    
    func testUtr8URL() {
        let expect = expectation(description: "wait for communication.")
        let url = "https://shop.nisshin.oilliogroup.com/"
        let api = HTTPTextTask(url: url)
        api.execute { response in
            XCTAssertTrue(true)
            expect.fulfill()
            }.onError { _, _ in
                XCTAssertTrue(false)
                expect.fulfill()
                return .finish
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testShiftJisURL() {
        let expect = expectation(description: "wait for communication.")
        let url = "http://products.nisshin-oillio.com/katei/shokuyouyu/index.php"
        let api = HTTPTextTask(url: url)
        api.execute { response in
            XCTAssertTrue(true)
            expect.fulfill()
        }.onError { _, _ in
            XCTAssertTrue(false)
            expect.fulfill()
            return .finish
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNotResponseEncodingURL() {
        let expect = expectation(description: "wait for communication.")
        let url = "http://www.capcom.co.jp/amusement/index.html"
        let api = HTTPTextTask(url: url)
        api.execute { response in
            XCTAssertTrue(true)
            expect.fulfill()
            }.onError { _, _ in
                XCTAssertTrue(false)
                expect.fulfill()
                return .finish
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testParseError() {
        let expect = expectation(description: "wait for communication.")
        let url = "http://www.capcom.co.jp/amusement/index.html"
        let api = HTTPTextTask(url: url, defaultEncoding: .shiftJIS)
        api.execute { response in
            XCTAssertTrue(false)
            expect.fulfill()
        }.onError { _, errorInfo in
            XCTAssertTrue(true)
            expect.fulfill()
            return .finish
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
