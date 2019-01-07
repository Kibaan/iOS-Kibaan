//
//  CaseIterableUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/27.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class CaseIterableUtilsTests: XCTestCase {
    
    enum Foo: CaseIterable {
        case aaa
        case bbb
        case ccc
    }
    
    // MARK: - values
    
    func testValues() {
        XCTAssertEqual(Foo.values(), [Foo.aaa, Foo.bbb, Foo.ccc])
    }
}

