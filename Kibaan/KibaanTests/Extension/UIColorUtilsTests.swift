//  Created by Akira Nakajima on 2018/08/07.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class UIColorUtilsTests: XCTestCase {
    
    func testColorCode() {
        XCTAssertEqual(UIColor.red.colorCode, "FF0000")
        XCTAssertEqual(UIColor(rgbValue: 0x556677).colorCode, "556677")
    }
}
