//
//  DoubleUtilsTests.swift
//  KibaanTests
//
//  Created by Keita Yamamoto on 2019/05/09.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class DoubleUtilsTests: XCTestCase {

    func testOptionalTrue() {
        var d: Double = 0
        XCTAssertEqual("0", d.decimalNumber.stringValue)

        d = 15.97
        XCTAssertEqual("15.97", d.decimalNumber.stringValue)

        d = 0.09999999999999986 // Double でこの値は表現できないため、少しずれるがどうしようもない
        XCTAssertEqual("0.09999999999999987", d.decimalNumber.stringValue)

        d = 0.09999999999999987
        XCTAssertEqual("0.09999999999999987", d.decimalNumber.stringValue)

        d = 0.1 * 10
        XCTAssertEqual("1", d.decimalNumber.stringValue)
    }
}
