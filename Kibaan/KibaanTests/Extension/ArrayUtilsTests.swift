//  Created by Akira Nakajima on 2018/08/03.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class ArrayUtilsTests: XCTestCase {
    
    // MARK: - AnyObject

    func testAnyObjectのRemoveできる() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 0)
        var array = [foo1, foo2]
        array.remove(element: foo2)
        XCTAssertEqual(array.count, 1)
    }
    
    func testAnyObjectのRemoveできない() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 0)
        var array = [foo1]
        array.remove(element: foo2)
        XCTAssertEqual(array.count, 1)
    }
    func testAnyObjectの中間のRemove() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 0)
        let foo3 = Foo(num: 0)
        var array = [foo1, foo2, foo3]
        array.remove(element: foo2)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([foo1, foo3], array)
    }
    
    func testAnyObjectの末尾のRemove() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 0)
        let foo3 = Foo(num: 0)
        var array = [foo1, foo2, foo3]
        array.remove(element: foo3)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([foo1, foo2], array)
    }
    
    func testAnyObjectNotEquatableのRemoveできる() {
        let bar1 = Bar(num: 0)
        let bar2 = Bar(num: 0)
        var array = [bar1, bar2]
        array.remove(element: bar2)
        XCTAssertEqual(array.count, 1)
    }
    
    func testAnyObjectNotEquatableのRemoveできない() {
        let bar1 = Bar(num: 0)
        let bar2 = Bar(num: 0)
        var array = [bar1]
        array.remove(element: bar2)
        XCTAssertEqual(array.count, 1)
    }
    func testAnyObjectNotEquatableの中間のRemove() {
        let bar1 = Bar(num: 0)
        let bar2 = Bar(num: 0)
        let bar3 = Bar(num: 0)
        var array = [bar1, bar2, bar3]
        array.remove(element: bar2)
        XCTAssertEqual(array.count, 2)
        XCTAssertTrue(array[0] === bar1)
        XCTAssertTrue(array[1] === bar3)
    }
    
    func testAnyObjectNotEquatableの末尾のRemove() {
        let bar1 = Bar(num: 0)
        let bar2 = Bar(num: 0)
        let bar3 = Bar(num: 0)
        var array = [bar1, bar2, bar3]
        array.remove(element: bar3)
        XCTAssertEqual(array.count, 2)
        XCTAssertTrue(array[0] === bar1)
        XCTAssertTrue(array[1] === bar2)
    }
    
    // MARK: - Equatable
    func testEquatableのRemoveできる() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 0)
        var array = [foo1]
        array.remove(equatable: foo2)
        XCTAssertEqual(array.count, 0)
    }
    
    func testEquatableのRemoveできない() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 1)
        let foo3 = Foo(num: 2)
        var array = [foo1, foo2]
        array.remove(equatable: foo3)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([foo1, foo2], array)
    }
    
    func testEquatableの中間のRemove() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 1)
        let foo3 = Foo(num: 2)
        var array = [foo1, foo2, foo3]
        array.remove(equatable: foo2)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([foo1, foo3], array)
    }
    
    func testEquatableの末尾のRemove() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 1)
        let foo3 = Foo(num: 2)
        var array = [foo1, foo2, foo3]
        array.remove(equatable: foo3)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([foo1, foo2], array)
    }
    
    func testEquatableの同一内容ありのRemove() {
        let foo1 = Foo(num: 0)
        let foo2 = Foo(num: 0)
        let foo3 = Foo(num: 0)
        var array = [foo1, foo2, foo3]
        array.remove(equatable: foo3)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([foo1, foo2], array)
    }
    
    // MARK: - Int
    
    func testIntのRemoveできる() {
        let int1 = 1
        let int2 = 2
        var array = [int1, int2]
        array.remove(equatable: int2)
        XCTAssertEqual(array.count, 1)
        XCTAssertEqual([int1], array)
    }
    
    func testIntのRemoveできない() {
        let int1 = 1
        let int2 = 2
        let int3 = 3
        var array = [int1, int2]
        array.remove(equatable: int3)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([int1, int2], array)
    }
    
    func testIntの中間のRemove() {
        let int1 = 1
        let int2 = 2
        let int3 = 3
        var array = [int1, int2, int3]
        array.remove(equatable: int2)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([int1, int3], array)
    }
    
    func testIntの末尾のRemove() {
        let int1 = 1
        let int2 = 2
        let int3 = 3
        var array = [int1, int2, int3]
        array.remove(equatable: int3)
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual([int1, int2], array)
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
        
        static func == (lhs: ArrayUtilsTests.Foo, rhs: ArrayUtilsTests.Foo) -> Bool {
            return lhs.num == rhs.num
        }
    }
}
