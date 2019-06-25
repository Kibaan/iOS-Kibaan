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
    
    func testNumberFormat_017() {
        XCTAssertEqual("".signedNumberFormat, "")
    }
    
    func testNumberFormat_018() {
        XCTAssertEqual("".numberFormat, "")
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
    
    func testSplitLeftError() {
        var result1 = "123456".splitFromLeft(length: 0)
        XCTAssertEqual(1, result1.count)
        XCTAssertEqual("", result1[0])
        
        var result2 = "123456".splitFromLeft(length: -1)
        XCTAssertEqual(1, result2.count)
        XCTAssertEqual("", result2[0])
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
    
    func testSplitRightError() {
        var result1 = "123456".splitFromRight(length: 0)
        XCTAssertEqual(1, result1.count)
        XCTAssertEqual("", result1[0])
        
        var result2 = "123456".splitFromRight(length: -1)
        XCTAssertEqual(1, result2.count)
        XCTAssertEqual("", result2[0])
    }
    
    // MARK: - IsNotEmpty
    
    func testIsNotEmpty() {
        XCTAssertEqual("ABC".isNotEmpty, true)
    }
    
    func testIsEmpty() {
        XCTAssertEqual("".isNotEmpty, false)
    }
    
    func testOptionalIsEmptyNil() {
        let str: String? = nil
        XCTAssertEqual(str.isEmpty, true)
    }
    
    func testOptionalIsEmpty空文字() {
        let str: String? = ""
        XCTAssertEqual(str.isEmpty, true)
    }
    
    func testOptionalStringIsEmpty() {
        let str: String? = "ABC"
        XCTAssertEqual(str.isEmpty, false)
    }
    
    func testOptionalIsNotEmpty() {
        let str: String? = "ABC"
        XCTAssertEqual(str.isNotEmpty, true)
    }
    
    func testOptionalIsNotEmpty空文字() {
        let str: String? = ""
        XCTAssertEqual(str.isNotEmpty, false)
    }
    
    func testOptionalisNotEmptyNil() {
        let str: String? = nil
        XCTAssertEqual(str.isNotEmpty, false)
    }
    
    // MARK: - remove
    
    func testRemove() {
        let str: String = "ABCDEFGHIJKLMN"
        XCTAssertEqual(str.remove("A"), "BCDEFGHIJKLMN")
        XCTAssertEqual(str.remove("N"), "ABCDEFGHIJKLM")
        XCTAssertEqual(str.remove("FGH"), "ABCDEIJKLMN")
        XCTAssertEqual(str.remove("ABC"), "DEFGHIJKLMN")
        XCTAssertEqual(str.remove("LMN"), "ABCDEFGHIJK")
        XCTAssertEqual(str.remove("ABCDEFGHIJKLMN"), "")
    }
    
    func testNotRemove() {
        let str: String = "ABC"
        XCTAssertEqual(str.remove("DEFG"), "ABC")
        XCTAssertEqual(str.remove(""), "ABC")
    }
    
    // MARK: - removeAll
    
    func testRemoveAll() {
        let str: String = "ABCDEFGHIJKLMN"
        XCTAssertEqual(str.removeAll(items: ["A", "G", "K", "N"]), "BCDEFHIJLM")
    }
    
    func testNotRemoveAll() {
        let str: String = "ABCD"
        XCTAssertEqual(str.removeAll(items: ["EFGHIJ"]), "ABCD")
        XCTAssertEqual(str.removeAll(items: []), "ABCD")
    }
    
    // MARK: - withPrefix
    
    func testWithPrefix_001() {
        let str: String = "1234"
        XCTAssertEqual("+1234", str.withPrefix("+"))
        XCTAssertEqual("51234", str.withPrefix("5"))
        XCTAssertEqual("1234", str.withPrefix(""))
        XCTAssertEqual("1234", str.withPrefix(nil))
    }
    
    func testWithPrefix_002() {
        let str: String? = "1234"
        XCTAssertEqual("+1234", str?.withPrefix("+"))
        XCTAssertEqual("51234", str?.withPrefix("5"))
        XCTAssertEqual("1234", str?.withPrefix(""))
        XCTAssertEqual("1234", str?.withPrefix(nil))
    }
    
    func testWithPrefix_003() {
        let str: String? = ""
        XCTAssertEqual("+", str?.withPrefix("+"))
        XCTAssertEqual("5", str?.withPrefix("5"))
        XCTAssertEqual("", str?.withPrefix(""))
        XCTAssertEqual("", str?.withPrefix(nil))
    }
    
    func testWithPrefix_004() {
        let str: String? = nil
        XCTAssertEqual(nil, str?.withPrefix("+"))
        XCTAssertEqual(nil, str?.withPrefix("5"))
        XCTAssertEqual(nil, str?.withPrefix(""))
        XCTAssertEqual(nil, str?.withPrefix(nil))
    }
    
    // MARK: - removePrefix
    
    func testRemovePrefix_001() {
        let str: String = "123456789"
        XCTAssertEqual(str.removePrefix("1"), "23456789")
        XCTAssertEqual(str.removePrefix("12"), "3456789")
        XCTAssertEqual(str.removePrefix("123"), "456789")
    }
    
    func testRemovePrefix_002() {
        let str: String = "123456789"
        XCTAssertEqual(str.removePrefix("123456789"), "")
    }
    
    func testNotRemovePrefix_001() {
        let str: String = "123"
        XCTAssertEqual(str.removePrefix("4"), "123")
        XCTAssertEqual(str.removePrefix("45"), "123")
        XCTAssertEqual(str.removePrefix("456"), "123")
    }
    
    // 先頭から完全一致ではない時
    func testNotRemovePrefix_002() {
        let str: String = "123456789"
        XCTAssertEqual(str.removePrefix("1234567890"), "123456789")
        XCTAssertEqual(str.removePrefix("12356789"), "123456789")
    }
    
    // MARK: - withSuffix
    
    func testWithSuffix_001() {
        let str: String = "1234"
        XCTAssertEqual("1234+", str.withSuffix("+"))
        XCTAssertEqual("12345", str.withSuffix("5"))
        XCTAssertEqual("1234", str.withSuffix(""))
        XCTAssertEqual("1234", str.withSuffix(nil))
    }
    
    func testWithSuffix_002() {
        let str: String? = "1234"
        XCTAssertEqual("1234+", str?.withSuffix("+"))
        XCTAssertEqual("12345", str?.withSuffix("5"))
        XCTAssertEqual("1234", str?.withSuffix(""))
        XCTAssertEqual("1234", str?.withSuffix(nil))
    }
    
    func testWithSuffix_003() {
        let str: String? = ""
        XCTAssertEqual("+", str?.withSuffix("+"))
        XCTAssertEqual("5", str?.withSuffix("5"))
        XCTAssertEqual("", str?.withSuffix(""))
        XCTAssertEqual("", str?.withSuffix(nil))
    }
    
    func testWithSuffix_004() {
        let str: String? = nil
        XCTAssertEqual(nil, str?.withSuffix("+"))
        XCTAssertEqual(nil, str?.withSuffix("5"))
        XCTAssertEqual(nil, str?.withSuffix(""))
        XCTAssertEqual(nil, str?.withSuffix(nil))
    }
    
    // MARK: - removeSuffix
    
    func testRemoveSuffix_001() {
        let str: String = "123456789"
        XCTAssertEqual(str.removeSuffix("9"), "12345678")
        XCTAssertEqual(str.removeSuffix("89"), "1234567")
        XCTAssertEqual(str.removeSuffix("789"), "123456")
    }
    
    func testRemoveSuffix_002() {
        let str: String = "123456789"
        XCTAssertEqual(str.removeSuffix("123456789"), "")
    }
    
    func testNotRemoveSuffix_001() {
        let str: String = "123"
        XCTAssertEqual(str.removeSuffix("4"), "123")
        XCTAssertEqual(str.removeSuffix("45"), "123")
        XCTAssertEqual(str.removeSuffix("456"), "123")
    }
    
    // 後ろから完全一致ではない時
    func testNotRemoveSuffix_002() {
        let str: String = "123456789"
        XCTAssertEqual(str.removeSuffix("1234567890"), "123456789")
        XCTAssertEqual(str.removeSuffix("12346789"), "123456789")
    }
    
    func testTrim() {
        let leadBlank: String = "   ABC"
        let backBlank: String = "ABC   "
        let leadBackBlank: String = "    ABC    "
        XCTAssertEqual(leadBlank.trim(), "ABC")
        XCTAssertEqual(backBlank.trim(), "ABC")
        XCTAssertEqual(leadBackBlank.trim(), "ABC")
    }
    
    func testNotTrim() {
        let str: String = "ABC"
        XCTAssertEqual(str.trim(), "ABC")
        
    }
    
    func testBlankTrim() {
        let str: String = "      "
        XCTAssertEqual(str.trim(), "")
    }
    
    // MARK: - doubleValue
    
    func testDoubleValue() {
        let str: String = "20"
        XCTAssertEqual(str.doubleValue, Double(20.0))
        
        XCTAssertEqual(29.94, "29.94.24".doubleValue)
        XCTAssertEqual(31.93, "31.93%".doubleValue)
        XCTAssertEqual(39.79, "39.79%39".doubleValue)
        XCTAssertEqual(0.0, "ー29.01".doubleValue)
        XCTAssertEqual(0.0, "＋39.79".doubleValue)
        XCTAssertEqual(777.2, "   777.2".doubleValue)
        XCTAssertEqual(0.0, "\n\n888.1".doubleValue)
        XCTAssertEqual(999.3, " 999.3 000".doubleValue)
        XCTAssertEqual(111.4, "   +111.4   ".doubleValue)
        XCTAssertEqual(-222.5, "   -222.5   ".doubleValue)
        XCTAssertEqual(300.0, "3E+2".doubleValue)
        XCTAssertEqual(0.0, " ".doubleValue)
        XCTAssertEqual(0.293, ".293".doubleValue)
        XCTAssertEqual(0.293, ".293.5".doubleValue)
    }
    
    func testNotDoubleValue() {
        let str: String = "ABC"
        XCTAssertEqual(str.doubleValue, Double(0))
    }
    
    func testBlankDoubleValue() {
        let str: String = ""
        XCTAssertEqual(str.doubleValue, Double(0))
    }
    
    func testNilDoubleValue() {
        let str: String = String()
        XCTAssertEqual(str.doubleValue, Double(0))
    }
    
    // MARK: - floatValue
    
    func testFloatValue() {
        let str: String = "20"
        XCTAssertEqual(str.floatValue, CGFloat(20.0))
    }
    
    func testNotFloatValue() {
        let str: String = "ABC"
        XCTAssertEqual(str.floatValue, CGFloat(0))
    }
    
    func testBlankFloatValue() {
        let str: String = ""
        XCTAssertEqual(str.floatValue, CGFloat(0))
    }
    
    func testNilFloatValue() {
        let str: String = String()
        XCTAssertEqual(str.floatValue, CGFloat(0))
    }
    
    // MARK: - integerValue
    
    func testIntegerValue() {
        let str: String = "20"
        XCTAssertEqual(str.integerValue, Int(20))
    }
    
    func testNotIntegerValue() {
        let str: String = "ABC"
        XCTAssertEqual(str.integerValue, Int(0))
    }
    
    func testBlankIntegerValue() {
        let str: String = ""
        XCTAssertEqual(str.integerValue, Int(0))
    }
    
    func testNilIntegerValue() {
        let str: String = String()
        XCTAssertEqual(str.integerValue, Int(0))
    }
    
    // MARK: - split
    
    func testSplit() {
        let str: String = "ABCDEFGHI"
        XCTAssertEqual(str.split(length: 3), ["ABC", "DEF", "GHI"])
        XCTAssertEqual(str.split(length: 2), ["AB", "CD", "EF", "GH", "I"])
        XCTAssertEqual(str.split(length: 9), ["ABCDEFGHI"])
    }
    
    func testNotSplit() {
        let str: String = "123"
        XCTAssertEqual(str.split(length: 4), ["123"])
    }
    
    func testBlankSplit() {
        let str: String = ""
        XCTAssertEqual(str.split(length: 2), [""])
    }
    
    func testSplitWithoutEmpty() {
        let word = "東京海上  日本   "
        let words = word.splitWithoutEmpty(separator: " ")
        XCTAssertEqual(2, words.count)
        XCTAssertEqual("東京海上", words[0])
        XCTAssertEqual("日本", words[1])
    }
    
    func testSplitError() {
        var result1 = "123456".split(length: 0)
        XCTAssertEqual(1, result1.count)
        XCTAssertEqual("", result1[0])
        
        var result2 = "123456".split(length: -1)
        XCTAssertEqual(1, result2.count)
        XCTAssertEqual("", result2[0])
    }
    
    // MARK: - hasAnyPrefix
    
    func testHasAnyPrefix() {
        let cafe: String = "Café du Monde"
        let composedCafe = "Café"
        let deComposedCafe = "Cafe\u{0301}"
        XCTAssertEqual(cafe.hasAnyPrefix([composedCafe]), true)
        XCTAssertEqual(cafe.hasAnyPrefix([deComposedCafe]), true)
        XCTAssertEqual(cafe.hasAnyPrefix([""]), true)
    }
    
    func testHasNotAnyPrefix() {
        let cafe: String = "Café du Monde"
        XCTAssertEqual(cafe.hasAnyPrefix(["café"]), false)
        XCTAssertEqual(cafe.hasAnyPrefix(["Cafédu"]), false)
    }
    
    // MARK: - anyPrefix
    
    func testAnyPrefix() {
        let str: String = "ABC"
        XCTAssertEqual(str.anyPrefix(in: ["A"]), "A")
        XCTAssertEqual(str.anyPrefix(in: ["AB"]), "AB")
        XCTAssertEqual(str.anyPrefix(in:  ["ABC"]), "ABC")
        XCTAssertEqual(str.anyPrefix(in: ["A","AB"]), "A")
        XCTAssertEqual(str.anyPrefix(in: ["A", "AB", "ABC"]), "A")
    }
    
    func testNotAnyPrefix() {
        let str: String = "ABC"
        XCTAssertEqual(str.anyPrefix(in: [""]), "")
        XCTAssertEqual(str.anyPrefix(in: ["B", "C"]), nil)
    }
    
    // MARK: - isNumber
    
    func testIsNumber() {
        XCTAssertEqual("123".isNumber, true)
        XCTAssertEqual("1.23".isNumber, true)
        XCTAssertEqual("-123".isNumber, true)
        XCTAssertEqual("-1.23".isNumber, true)
    }
    
    func testIsNotNumber() {
        XCTAssertEqual("ABC".isNumber, false)
        XCTAssertEqual("".isNumber, false)
        XCTAssertEqual("１２３".isNumber, false)
    }
    
    // MARK: - enclosed
    
    func testEnclosed() {
        let str: String = "ABCDEFGHIJK"
        XCTAssertEqual(str.enclosed("A", "K"), "BCDEFGHIJ")
        XCTAssertEqual(str.enclosed("AB", "JK"), "CDEFGHI")
    }
    
    func testNotEnclosed() {
        let str: String = "ABCDEFGHIJK"
        XCTAssertEqual(str.enclosed("AC", "IK"), nil)
        XCTAssertEqual(str.enclosed("", ""), nil)
    }
    
    // MARK: - localizedString
    
    func testLocalizedString() {
        let str: String = "こんにちは"
        XCTAssertEqual(str.localizedString, "こんにちは")
    }
    
    // MARK: - decimalNumber
    
    func testDecimalNumber_01() {
        let value: String? = ""
        XCTAssertEqual(value?.decimalNumber, nil)
    }
    
    func testDecimalNumber_02() {
        let value: String? = nil
        XCTAssertEqual(value?.decimalNumber, nil)
    }
    
    func testDecimalNumber_03() {
        let value: String? = "a"
        XCTAssertEqual(value?.decimalNumber, nil)
    }
    
    func testDecimalNumber_04() {
        let value: String? = "1500"
        XCTAssertEqual(value?.decimalNumber, 1500)
    }
    
    func testDecimalNumber_05() {
        let value: String? = "0.124"
        XCTAssertEqual(value?.decimalNumber, 0.124)
    }
    
    // MARK: - unwrapped
    
    func testUnwrapped() {
        let str: String? = "ABC"
        XCTAssertEqual(str.unwrapped, "ABC")
    }
    
    func testNotUnwrapped() {
        let str: String? = nil
        XCTAssertEqual(str.unwrapped, "")
    }
    
    // MARK: - emptyConverted
    
    func testEmptyConverted() {
        let str: String? = String()
        XCTAssertEqual(str.emptyConverted("ABC"), "ABC")
    }
    
    func testEmptyConvertedNil() {
        let str: String? = nil
        XCTAssertEqual(str.emptyConverted("ABC"), "ABC")
    }
    
    func testNotEmptyConvertedNil() {
        let str: String? = "ABCDE"
        XCTAssertEqual(str.emptyConverted("ABC"), "ABCDE")
    }
    
    func testSHA256() {
        let src = "ABC"
        XCTAssertEqual(src.sha256(), "b5d4045c3f466fa91fe2cc6abe79232a1a57cdf104f7a26e716e0a1e2789df78")
    }
    
    // MARK: - Hiragana, Katakana
    
    private let kanaMap: [String: String] = ["あ": "ア", "い": "イ", "う": "ウ", "え": "エ", "お": "オ",
                                             "か": "カ", "が": "ガ",
                                             "は": "ハ", "ば": "バ", "ぱ": "パ",
                                             "っ": "ッ",
                                             "ゃ": "ャ", "ゅ": "ュ", "ょ": "ョ",
                                             "ぁ": "ァ", "ぃ": "ィ", "ぅ": "ゥ", "ぇ": "ェ", "ぉ": "ォ",
                                             "ん": "ン",
                                             "ゔ": "ヴ", "ゐ": "ヰ", "ゑ": "ヱ",
                                             "ゕ": "ヵ"
    ]
    
    private let noEffectList: [String] = ["ヷ", "ヸ", "ヹ", "ヺ", "龍", " ", "・", "ー", "ヽ", "ヾ", ""]
    
    func testHiraganaToKatakana() {
        for (hiragana, katakana) in kanaMap {
            XCTAssertEqual(katakana, hiragana.toKatakana())
        }
    }
    
    func testKatakanaToKatakana() {
        for (_, katakana) in kanaMap {
            XCTAssertEqual(katakana, katakana.toKatakana())
        }
    }
    
    func testKatakanaToHiragana() {
        for (hiragana, katakana) in kanaMap {
            XCTAssertEqual(hiragana, katakana.toHiragana())
        }
    }
    
    func testHiraganaToHiragana() {
        for (hiragana, _) in kanaMap {
            XCTAssertEqual(hiragana, hiragana.toHiragana())
        }
    }
    
    func testToKatakanaNoEffect() {
        noEffectList.forEach {
            XCTAssertEqual($0, $0.toKatakana())
        }
    }
    
    func testToHiraganaNoEffect() {
        noEffectList.forEach {
            XCTAssertEqual($0, $0.toHiragana())
        }
    }
}
