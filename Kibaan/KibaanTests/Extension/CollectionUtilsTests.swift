//  Created by Akira Nakajima on 2018/08/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class CollectionUtilsTests: XCTestCase {
    
    // MARK: - Safe Index
    
    func testSafeIndex_先頭() {
        let array = [0, 1, 2, 3, 4]
        XCTAssertEqual(array[safe: 0], 0)
    }
    
    func testSafeIndex_中間() {
        let array = [0, 1, 2, 3, 4]
        XCTAssertEqual(array[safe: 2], 2)
    }
    
    func testSafeIndex_末尾() {
        let array = [0, 1, 2, 3, 4]
        XCTAssertEqual(array[safe: 4], 4)
    }
    
    func testSafeIndex_マイナス参照() {
        let array = [0, 1, 2, 3, 4]
        XCTAssertEqual(array[safe: -1], nil)
    }
    
    func testSafeIndex_範囲外() {
        let array = [0, 1, 2, 3, 4]
        XCTAssertEqual(array[safe: 5], nil)
    }
    
    // MARK: - Contains(AnyObject)
    
    func testContainsAnyObject_ある場合() {
        let bar1 = Bar(num: 1)
        let bar2 = Bar(num: 2)
        let bar3 = Bar(num: 3)
        let array = [bar1, bar2, bar3]
        XCTAssertTrue(array.contains(element: bar1))
    }
    
    func testContainsAnyObject_ない場合() {
        let bar1 = Bar(num: 1)
        let bar2 = Bar(num: 2)
        let bar3 = Bar(num: 3)
        let array = [bar1, bar2]
        XCTAssertFalse(array.contains(element: bar3))
    }
    
    func testContainsAnyObject_引数がnil() {
        let bar1 = Bar(num: 1)
        let bar2 = Bar(num: 2)
        let bar3 = Bar(num: 3)
        let array = [bar1, bar2, bar3]
        XCTAssertFalse(array.contains(element: nil))
    }
    
    // MARK: - Contains(Equatable)
    
    func testContainsEquatable_ある場合() {
        let foo1 = Foo(num: 1)
        let foo2 = Foo(num: 1)
        let foo3 = Foo(num: 2)
        let array = [foo1, foo3]
        XCTAssertTrue(array.contains(equatable: foo2))
    }
    
    func testContainsEquatable_ない場合() {
        let foo1: Foo? = Foo(num: 1)
        let foo2: Foo? = Foo(num: 1)
        let foo3: Foo? = Foo(num: 2)
        let array = [foo1, foo2]
        XCTAssertFalse(array.contains(equatable: foo3))
    }
    
    func testContainsEquatable_引数がnil() {
        let foo1 = Foo(num: 1)
        let foo2 = Foo(num: 1)
        let foo3 = Foo(num: 2)
        let array = [foo1, foo2, foo3]
        XCTAssertFalse(array.contains(equatable: nil))
    }
    
    // MARK: - Test Class
    
    class Bar {
        var num: Int

        init(num: Int) {
            self.num = num
        }
    }

    class Foo: Equatable {
        var num: Int

        init(num: Int) {
            self.num = num
        }

        static func == (lhs: CollectionUtilsTests.Foo, rhs: CollectionUtilsTests.Foo) -> Bool {
            return lhs.num == rhs.num
        }
    }
}
