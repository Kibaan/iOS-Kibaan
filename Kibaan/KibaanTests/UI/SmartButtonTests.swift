//  Created by Akira Nakajima on 2018/08/07.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class SmartButtonTests: XCTestCase {
    
    func testBackgroundColor() {
        let button = SmartButton(frame: .zero)
        button.setBackgroundColor(color: UIColor.red, for: .normal)
        button.setBackgroundColor(color: UIColor.blue, for: .selected)
        button.setBackgroundColor(color: UIColor.green, for: [.normal, .highlighted])
        button.setBackgroundColor(color: UIColor.yellow, for: [.selected, .highlighted])
        
        XCTAssertEqual(button.backgroundColor(for: .normal), UIColor.red)
        XCTAssertEqual(button.backgroundColor(for: .selected), UIColor.blue)
        XCTAssertEqual(button.backgroundColor(for: [.normal, .highlighted]), UIColor.green)
        XCTAssertEqual(button.backgroundColor(for: [.selected, .highlighted]), UIColor.yellow)
    }
    
    func testBackgroundColorState() {
        let button = SmartButton(frame: .zero)
        button.setBackgroundColor(color: UIColor.red, for: .normal)
        button.setBackgroundColor(color: UIColor.blue, for: .selected)
        button.setBackgroundColor(color: UIColor.green, for: [.normal, .highlighted])
        button.setBackgroundColor(color: UIColor.yellow, for: [.selected, .highlighted])
        
        XCTAssertEqual(button.backgroundColor, UIColor.red)
        button.isHighlighted = true
        XCTAssertEqual(button.backgroundColor, UIColor.green)
        button.isSelected = true
        XCTAssertEqual(button.backgroundColor, UIColor.yellow)
        button.isHighlighted = false
        XCTAssertEqual(button.backgroundColor, UIColor.blue)
    }
    
}
