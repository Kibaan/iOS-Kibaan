//  Created by Akira Nakajima on 2018/09/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
import Kibaan
@testable import KibaanSample

class SecureStorageTests: XCTestCase {
    
    func testSaveAndLoad() {
        let secureStorage = SecureStorage()
        let value = "1fndaiufjdaifoi4129"
        let key = "password"
        XCTAssertTrue(secureStorage.save(value, key: key))
        let loadValue = secureStorage.load(key: key)
        XCTAssertEqual(value, loadValue)
    }
    
    func testDelete() {
        let secureStorage = SecureStorage()
        let value = "1fndaiufjdaifoi4129"
        let key = "password"
        XCTAssertTrue(secureStorage.save(value, key: key))
        let loadValue = secureStorage.load(key: key)
        XCTAssertEqual(value, loadValue)
        XCTAssertTrue(secureStorage.delete(key: key))
        let deletedValue = secureStorage.load(key: key)
        XCTAssertNil(deletedValue)
        XCTAssertNotEqual(loadValue, deletedValue)
    }
    
    func testClear() {
        let secureStorage = SecureStorage()
        let keys = ["pass1", "pass2", "passe"]
        keys.forEach {
            secureStorage.save("delete target.", key: $0)
            XCTAssertNotNil(secureStorage.load(key: $0))
        }
        secureStorage.clear()
        keys.forEach {
            XCTAssertNil(secureStorage.load(key: $0))
        }
    }
}
