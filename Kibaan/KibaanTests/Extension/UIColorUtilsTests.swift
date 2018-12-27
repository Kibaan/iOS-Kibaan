//  Created by Akira Nakajima on 2018/08/07.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class UIColorUtilsTests: XCTestCase {
    
    func testWhiteAdded() {
        let color: UIColor = UIColor.init(rgbValue: 000000)
        XCTAssertEqual(color.whiteAdded(1 / 255), UIColor(rgbValue: 0x010101))
        XCTAssertEqual(color.whiteAdded(2 / 255), UIColor(rgbValue: 0x020202))
        XCTAssertEqual(color.whiteAdded(1), UIColor(rgbValue: 0xFFFFFF))
    }
    
    func testMaxWhiteAdded() {
        let color: UIColor = UIColor.init(rgbValue: 0xFFFFFF)
        XCTAssertEqual(color.whiteAdded(1 / 255), UIColor(rgbValue: 0xFFFFFF))
    }
    
    func testColorCode() {
        XCTAssertEqual(UIColor.red.colorCode, "FF0000")
        XCTAssertEqual(UIColor(rgbValue: 0x556677).colorCode, "556677")
    }
}
