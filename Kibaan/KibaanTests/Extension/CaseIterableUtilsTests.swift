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
        case AAA
        case BBB
        case CCC
    }
    
    enum Bar: CaseIterable {
        
    }
    
    // MARK: - values
    
    func testValues() {
        XCTAssertEqual(Foo.values(), [CaseIterableUtilsTests.Foo.AAA, CaseIterableUtilsTests.Foo.BBB, CaseIterableUtilsTests.Foo.CCC])
    }
}

