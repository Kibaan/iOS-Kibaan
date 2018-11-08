//  Created by 山本敬太 on 2018/08/04.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class UIDeviceUtilsTests: XCTestCase {
    
    func testModelName() {
        XCTAssertTrue(0 < UIDevice.current.detailedModel.count)
    }
}
