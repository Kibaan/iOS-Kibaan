//
//  ListDictionaryTests.swift
//  KibaanTests
//
//  Created by Keita Yamamoto on 2019/05/07.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import Foundation

import XCTest
@testable import Kibaan

class ListDictionaryTests: XCTestCase {

    func testKeys() {
        let dict: ListDictionary = ["1": "AAA", "2": "BBB", "3": "CCC"]
        XCTAssertEqual(["1", "2", "3"], dict.keys)
    }

    func testKeyAccess() {
        let dict: ListDictionary = ["1": "AAA", "2": "BBB", "3": "CCC"]
        XCTAssertEqual("AAA", dict["1"])
        XCTAssertEqual("BBB", dict["2"])
        XCTAssertEqual("CCC", dict["3"])
    }

    func testInvalidKeyAccess() {
        let dict: ListDictionary = ["1": "AAA", "2": "BBB", "3": "CCC"]
        XCTAssertNil(dict["4"])
    }

    func testIndexAccess() {
        let dict: ListDictionary = ["1": "AAA", "2": "BBB", "3": "CCC"]
        XCTAssertEqual("AAA", dict[0])
        XCTAssertEqual("BBB", dict[1])
        XCTAssertEqual("CCC", dict[2])
        XCTAssertNil(dict[3])
        XCTAssertNil(dict[-1])
    }

    func testInvalidIndexAccess() {
        let dict: ListDictionary = ["1": "AAA", "2": "BBB", "3": "CCC"]
        XCTAssertNil(dict[3])
        XCTAssertNil(dict[-1])
    }

    func testSetNil() {
        let dict: ListDictionary = ["1": "AAA", "2": "BBB", "3": "CCC"]
        dict["2"] = nil
        XCTAssertNil(dict["2"])
    }

    func testAppend() {
        let dict: ListDictionary = ["1": "AAA", "2": "BBB", "3": "CCC"]
        dict.append(key: "4", value: "DDD")
        XCTAssertEqual(["1", "2", "3", "4"], dict.keys)
        XCTAssertEqual("AAA", dict["1"])
        XCTAssertEqual("BBB", dict["2"])
        XCTAssertEqual("CCC", dict["3"])
        XCTAssertEqual("DDD", dict["4"])
    }

    func testAppendSameKey() {
        let dict: ListDictionary = ["1": "AAA", "2": "BBB", "3": "CCC"]
        dict.append(key: "2", value: "DDD")
        XCTAssertEqual(["1", "2", "3"], dict.keys)
        XCTAssertEqual("AAA", dict["1"])
        XCTAssertEqual("DDD", dict["2"])
        XCTAssertEqual("CCC", dict["3"])
    }
}
