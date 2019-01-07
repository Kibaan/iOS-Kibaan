//
//  QueryTests.swift
//  KibaanTests
//
//  Created by Keita Yamamoto on 2018/12/28.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class QueryTests: XCTestCase {

    func testParseSingle() {
        let query = Query(string: "key=value")
        XCTAssertEqual(1, query.keyValues.count)
        XCTAssertEqual("key=value", query.keyValues.first?.stringValue)
    }

    func testParse() {
        let query = Query(string: "aaa=111&bbb=222&ccc=333")
        let keyValues = query.keyValues
        
        XCTAssertEqual(3, keyValues.count)
        XCTAssertEqual("aaa=111", keyValues[0].stringValue)
        XCTAssertEqual("bbb=222", keyValues[1].stringValue)
        XCTAssertEqual("ccc=333", keyValues[2].stringValue)
    }
    
    func testParseNone() {
        let query = Query(string: "")
        XCTAssertEqual(0, query.keyValues.count)
    }
    
    func testURLDecode() {
        let query = Query(string: "aaa=111&bbb=%e3%81%82%e3%81%84%e3%81%86%26&ccc=333")
        let keyValues = query.keyValues
        
        XCTAssertEqual(3, keyValues.count)
        XCTAssertEqual("aaa=111", keyValues[0].stringValue)
        XCTAssertEqual("bbb=あいう&", keyValues[1].stringValue)
        XCTAssertEqual("ccc=333", keyValues[2].stringValue)
    }
    
    func testString() {
        let srcKeyValues = [
            KeyValue(key: "aaa", value: "111"),
            KeyValue(key: "bbb", value: "222"),
            KeyValue(key: "ccc", value: "333"),
        ]
        
        let query = Query(keyValues: srcKeyValues)
        XCTAssertEqual("aaa=111&bbb=222&ccc=333", query.stringValue)
    }
    
    func testURLEncode() {
        let srcKeyValues = [
            KeyValue(key: "aaa", value: "111"),
            KeyValue(key: "bbb", value: "あいう&"),
            KeyValue(key: "ccc", value: "333"),
        ]
        
        let query = Query(keyValues: srcKeyValues)
        XCTAssertEqual("aaa=111&bbb=%E3%81%82%E3%81%84%E3%81%86%26&ccc=333", query.stringValue)
    }
    
    func testSubscriptGet() {
        let query = Query(string: "aaa=111&bbb=222&ccc=333")
        XCTAssertEqual("111", query["aaa"])
        XCTAssertEqual("222", query["bbb"])
        XCTAssertEqual("333", query["ccc"])
    }
    
    func testSubscriptGetURLDecode() {
        let query = Query(string: "aaa=111&bbb=%E3%81%82%E3%81%84%E3%81%86%26&ccc=333")
        XCTAssertEqual("111", query["aaa"])
        XCTAssertEqual("あいう&", query["bbb"])
        XCTAssertEqual("333", query["ccc"])
    }
    
    func testSubscriptSet() {
        let query = Query()
        query["aaa"] = "111"
        query["bbb"] = "222"
        XCTAssertEqual("aaa=111&bbb=222", query.stringValue)
    }

    func testSubscriptSetURLEncode() {
        let query = Query()
        query["aaa"] = "あいう&"
        XCTAssertEqual("aaa=%E3%81%82%E3%81%84%E3%81%86%26", query.stringValue)
    }
    
    func testTrim() {
        let query = Query(string: "   aaa=111&bbb=222&ccc=333   ")
        XCTAssertEqual("111", query["aaa"])
        XCTAssertEqual("222", query["bbb"])
        XCTAssertEqual("333", query["ccc"])
    }
    
    func testCustomEncoded() {
        let query = Query(string: "aa#=11#&bb#=22#")
        let string = query.stringValueCustomEncoded {str in
            return str.replacingOccurrences(of: "#", with: "%")
        }
        
        XCTAssertEqual("aa%=11%&bb%=22%", string)
    }
    
    func testDictionary() {
        let query: Query = [
            "aaa": "111",
            "bbb": "222",
            "ccc": "333",
        ]
        XCTAssertEqual("aaa=111&bbb=222&ccc=333", query.stringValue)
    }
    
    func testDictionaryContainsNil() {
        let query: Query = [
            "aaa": "111",
            "bbb": nil,
            "ccc": "333",
        ]
        XCTAssertEqual("aaa=111&bbb&ccc=333", query.stringValue)
    }
}
