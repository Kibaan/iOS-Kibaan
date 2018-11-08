//  Created by Akira Nakajima on 2018/08/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class DataUtilsTest: XCTestCase {
    
    // MARK: - Hex String
    
    func testHexString_Text() {
        let testText = "テスト"
        let testData = testText.data(using: .utf8)
        XCTAssertEqual(testData?.hexString, "E3 83 86 E3 82 B9 E3 83 88")
    }
    
    func testHexString_Number() {
        let testText = "123456789"
        let testData = testText.data(using: .utf8)
        XCTAssertEqual(testData?.hexString, "31 32 33 34 35 36 37 38 39")
    }
    
    // MARK: - Hex Array
    
    func testHexArrayUpper() {
        let testText = "テスト"
        let testData = testText.data(using: .utf8)
        XCTAssertEqual(testData?.hexArray(charCase: .upper), ["E3", "83", "86", "E3", "82", "B9", "E3", "83", "88"])
    }
    
    func testHexArrayLower() {
        let testText = "テスト"
        let testData = testText.data(using: .utf8)
        XCTAssertEqual(testData?.hexArray(charCase: .lower), ["e3", "83", "86", "e3", "82", "b9", "e3", "83", "88"])
    }

    // MARK: - Init
    
    func testInit_FileNotFound() {
        let data = Data(fileName: "NotFound.txt")
        XCTAssertNil(data)
    }
    
    func testInit_FileFound() {
        let testFileName = "Found.txt"
        let testText = "This is Test Data."
        let testData = testText.data(using: .utf8)
        testData?.writeTo(fileName: testFileName)
        let loadData = Data(fileName: testFileName)
        XCTAssertNotNil(loadData)
        XCTAssertEqual(testData, loadData)
    }
    
    // MARK: - WriteTo
    
    func testWritTo_Success() {
        let testFileName = "TestData.txt"
        let testText = "This is Test Data."
        let testData = testText.data(using: .utf8)
        testData?.writeTo(fileName: testFileName)
        let loadData = Data(fileName: testFileName)
        XCTAssertNotNil(loadData)
        XCTAssertEqual(testData, loadData)
    }
    
    func testWritTo_Failure() {
        let testFileName = ""
        let testText = "This is Test Data."
        let testData = testText.data(using: .utf8)
        testData?.writeTo(fileName: testFileName)
        let loadData = Data(fileName: testFileName)
        XCTAssertNil(loadData)
    }
}
