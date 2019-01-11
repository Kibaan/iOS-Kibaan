//
//  UITableCellUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2019/01/07.
//  Copyright © 2019年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class UITableCellUtilsTests: XCTestCase {
    
    func testSelectedBackgroundColor() {
        let cell = UITableViewCell(frame: .zero)
        cell.selectedBackgroundColor = UIColor.red
        XCTAssertEqual(cell.selectedBackgroundColor?.colorCode, UIColor.red.colorCode)
    }
}

