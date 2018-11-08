//  Created by Akira Nakajima on 2018/08/03.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class BoolUtilsTests: XCTestCase {
    
    func testOptionalTrue() {
        let bool: Bool? = true
        XCTAssertTrue(bool.isTrue)
    }
    
    func testOptionalFalse() {
        let bool: Bool? = false
        XCTAssertFalse(bool.isTrue)
    }
    
    func testOptionalNil() {
        let bool: Bool? = nil
        XCTAssertFalse(bool.isTrue)
    }
    
    func testRandom() {
        var hasTrue = false
        var hasFalse = false
        
        for _ in 1...30 {
            let bool = Bool.randomValue()
            if bool {
                hasTrue = true
            } else {
                hasFalse = true
            }
        }
        
        XCTAssert(hasTrue && hasFalse)
    }
}
