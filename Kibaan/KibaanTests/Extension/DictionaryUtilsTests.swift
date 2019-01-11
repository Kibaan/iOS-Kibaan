//
//  DictionaryUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2019/01/07.
//  Copyright © 2019年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class DictionaryUtilsTests: XCTestCase {
    
    func testSubscriptKeyNotNil() {
        let dictionary: [String: String] = ["Foo": "Bar"]
        var key: String? = "Foo"
        XCTAssertEqual(dictionary[key], "Bar")
        
        key = "Hoge"
        XCTAssertEqual(dictionary[key], nil)
    }
    
    func testSubscriptKeyNil() {
        let dictionary: [String: String] = ["Foo": "Bar"]
        let key: String? = nil
        XCTAssertEqual(dictionary[key], nil)
    }
}


