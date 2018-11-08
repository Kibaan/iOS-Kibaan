//  Created by Akira Nakajima on 2018/08/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
import Kibaan
@testable import KibaanSample

class DataUtilsTest: XCTestCase {
    
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
