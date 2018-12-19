//  Created by Akira Nakajima on 2018/08/01.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class StringUtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Subscript(X...Y)
    
    func testSubscript_001() {
        XCTAssertEqual("12345"[0...0], "1")
    }
    
    func testSubscript_002() {
        XCTAssertEqual("12345"[0...3], "1234")
    }

    func testSubscript_003() {
        XCTAssertEqual("12345"[0...4], "12345")
    }
    
    func testSubscript_004() {
        XCTAssertEqual("12345"[0...5], nil)
    }
    
    func testSubscript_005() {
        XCTAssertEqual("12345"[1...2], "23")
    }
    
    // MARK: - Subscript(X..<Y)
    
    func testSubscript_011() {
        XCTAssertEqual("12345"[0..<0], "")
    }
    
    func testSubscript_012() {
        XCTAssertEqual("12345"[0..<3], "123")
    }
    
    func testSubscript_013() {
        XCTAssertEqual("12345"[0..<4], "1234")
    }
    
    func testSubscript_014() {
        XCTAssertEqual("12345"[0..<5], "12345")
    }
    
    func testSubscript_015() {
        XCTAssertEqual("12345"[0..<6], nil)
    }
    
    func testSubscript_016() {
        XCTAssertEqual("12345"[1..<2], "2")
    }
    
    func testSubscript_017() {
        XCTAssertEqual("12345"[1..<5], "2345")
    }
    
    // MARK: - Substring(from)
    
    func testSubstringFrom_001() {
        XCTAssertEqual("12345".substring(from: 0), "12345")
    }
    
    func testSubstringFrom_002() {
        XCTAssertEqual("12345".substring(from: 1), "2345")
    }
    
    func testSubstringFrom_003() {
        XCTAssertEqual("12345".substring(from: 4), "5")
    }
    
    func testSubstringFrom_004() {
        XCTAssertEqual("12345".substring(from: 5), "")
    }
    
    func testSubstringFrom_005() {
        XCTAssertEqual("12345".substring(from: 6), nil)
    }
    
    func testSubstringFrom_006() {
        XCTAssertEqual("12345".substring(from: -1), nil)
    }
    
    // MARK: - Substring(to)
    
    func testSubstringTo_001() {
        XCTAssertEqual("12345".substring(to: 0), "")
    }
    
    func testSubstringTo_002() {
        XCTAssertEqual("12345".substring(to: 2), "12")
    }
    
    func testSubstringTo_003() {
        XCTAssertEqual("12345".substring(to: 5), "12345")
    }
    
    func testSubstringTo_004() {
        XCTAssertEqual("12345".substring(to: 6), nil)
    }
    
    func testSubstringTo_005() {
        XCTAssertEqual("12345".substring(to: -1), nil)
    }
    
    // MARK: - Substring(from, length)
    
    func testSubstringFromLength_001() {
        XCTAssertEqual("12345".substring(from: 0, length: 0), "")
    }
    
    func testSubstringFromLength_002() {
        XCTAssertEqual("12345".substring(from: 0, length: 1), "1")
    }
    
    func testSubstringFromLength_003() {
        XCTAssertEqual("12345".substring(from: 0, length: 5), "12345")
    }
    
    func testSubstringFromLength_004() {
        XCTAssertEqual("12345".substring(from: 0, length: 6), nil)
    }
    
    func testSubstringFromLength_005() {
        XCTAssertEqual("12345".substring(from: 1, length: 1), "2")
    }
    
    func testSubstringFromLength_006() {
        XCTAssertEqual("12345".substring(from: 4, length: 1), "5")
    }
    
    func testSubstringFromLength_007() {
        XCTAssertEqual("12345".substring(from: 4, length: 2), nil)
    }
    
    func testSubstringFromLength_008() {
        XCTAssertEqual("12345".substring(from: 5, length: 2), nil)
    }
    
    func testSubstringFromLength_009() {
        XCTAssertEqual("12345".substring(from: -1, length: 1), nil)
    }
    
    func testSubstringFromLength_010() {
        XCTAssertEqual("12345".substring(from: 0, length: -1), nil)
    }
    
    // MARK: - Format
    
    func testNumberFormat_001() {
        XCTAssertEqual("123".numberFormat, "123")
    }
    
    func testNumberFormat_002() {
        XCTAssertEqual("1234".numberFormat, "1,234")
    }
    
    func testNumberFormat_003() {
        XCTAssertEqual("1234567".numberFormat, "1,234,567")
    }
    
    func testNumberFormat_Decimal() {
        XCTAssertEqual("1234.5678901".numberFormat, "1,234.5678901")
    }

    func testNumberFormat_004() {
        XCTAssertEqual("AAA(1234)BBB(5678)".numberFormat, "AAA(1,234)BBB(5,678)")
    }
    
    func testNumberFormat_005() {
        XCTAssertEqual("+1234".numberFormat, "+1,234")
    }
    
    func testNumberFormat_006() {
        XCTAssertEqual("-1234".numberFormat, "-1,234")
    }
    
    func testNumberFormat_007() {
        XCTAssertEqual("+123456.789012".signedNumberFormat, "+123,456.789012")
    }
    
    func testNumberFormat_008() {
        XCTAssertEqual("-123456.789012".signedNumberFormat, "-123,456.789012")
    }
    
    func testNumberFormat_009() {
        XCTAssertEqual("-0.00".signedNumberFormat, "0.00")
    }
    
    func testNumberFormat_010() {
        XCTAssertEqual("+0.00".signedNumberFormat, "0.00")
    }
    
    func testNumberFormat_011() {
        XCTAssertEqual("-0".signedNumberFormat, "0")
    }
    
    func testNumberFormat_012() {
        XCTAssertEqual("+0".signedNumberFormat, "0")
    }
    
    func testNumberFormat_013() {
        XCTAssertEqual("123".signedNumberFormat, "+123")
    }
    
    func testNumberFormat_014() {
        XCTAssertEqual("1234".signedNumberFormat, "+1,234")
    }
    
    func testNumberFormat_015() {
        XCTAssertEqual("-123".signedNumberFormat, "-123")
    }
    
    func testNumberFormat_016() {
        XCTAssertEqual("-1234".signedNumberFormat, "-1,234")
    }
    
    func testPadLeft() {
        XCTAssertEqual("123".leftPadded(size: 6), "   123")
        XCTAssertEqual("123".leftPadded(size: 6, spacer: "0"), "000123")
        XCTAssertEqual("1234567".leftPadded(size: 6), "1234567")
    }
    
    func testPadRight() {
        XCTAssertEqual("123".rightPadded(size: 6), "123   ")
        XCTAssertEqual("123".rightPadded(size: 6, spacer: "0"), "123000")
        XCTAssertEqual("1234567".rightPadded(size: 6), "1234567")
    }

    // MARK: - SnakeCase
    
    func testSnakeCase() {
        XCTAssertEqual("StringUtilsTests".toSnakeCase(), "string_utils_tests")
        XCTAssertEqual("AAABBBCCC".toSnakeCase(), "aaabbbccc")
        XCTAssertEqual("abcDefGhiJk123".toSnakeCase(), "abc_def_ghi_jk123")
    }
    
    func testLiteralEscaped() {
        XCTAssertEqual("ABC".literalEscaped, "ABC")
        XCTAssertEqual("\r".literalEscaped, "")
        XCTAssertEqual("\n".literalEscaped, "\\n")
        XCTAssertEqual("\t".literalEscaped, "\\t")
        XCTAssertEqual("\"".literalEscaped, "\\\"")
        XCTAssertEqual("\'".literalEscaped, "\\\'")
        XCTAssertEqual("\r\n\t\"\'".literalEscaped, "\\n\\t\\\"\\\'")
    }
    
    // MARK: - Split(Left)
    
    func testSplitLeftSimple() {
        var result = "123456789".splitFromLeft(length: 3)
        XCTAssertEqual(3, result.count)
        XCTAssertEqual("123", result[0])
        XCTAssertEqual("456", result[1])
        XCTAssertEqual("789", result[2])
    }
    
    func testSplitLeftShortOne() {
        var result = "12".splitFromLeft(length: 3)
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("12", result[0])
    }
    
    func testSplitLeftShortMulti() {
        var result = "AAAABBBBCC".splitFromLeft(length: 4)
        XCTAssertEqual(3, result.count)
        XCTAssertEqual("AAAA", result[0])
        XCTAssertEqual("BBBB", result[1])
        XCTAssertEqual("CC", result[2])
    }
    
    func testSplitLeftBlank() {
        var result = "".splitFromLeft(length: 4)
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("", result[0])
    }

    // MARK: - Split(Right)
    
    func testSplitRightSimple() {
        var result = "123456789".splitFromRight(length: 3)
        XCTAssertEqual(3, result.count)
        XCTAssertEqual("123", result[0])
        XCTAssertEqual("456", result[1])
        XCTAssertEqual("789", result[2])
    }
    
    func testSplitRightShortOne() {
        var result = "12".splitFromRight(length: 3)
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("12", result[0])
    }
    
    func testSplitRightShortMulti() {
        var result = "AAAABBBBCC".splitFromRight(length: 4)
        XCTAssertEqual(3, result.count)
        XCTAssertEqual("AA", result[0])
        XCTAssertEqual("AABB", result[1])
        XCTAssertEqual("BBCC", result[2])
    }
    
    func testSplitRightBlank() {
        var result = "".splitFromRight(length: 4)
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("", result[0])
    }
}
