//
//  NSLayoutConstraintUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2019/01/07.
//  Copyright © 2019年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class NSLayoutConstraintUtilsTests: XCTestCase {
    
    func testSetMultiplier() {
        let view1 = UIView(frame: .zero)
        let view2 = UIView(frame: .zero)
        view1.addSubview(view2)
        
        let testMultipiler: CGFloat = 4.0
        let constraint: NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1.0, constant: 2.0)
        let convertedConstraint = constraint.setMultiplier(testMultipiler)
        
        XCTAssertEqual(convertedConstraint.multiplier, testMultipiler)
        XCTAssertEqual(convertedConstraint.firstItem as? UIView, view1)
        XCTAssertEqual(convertedConstraint.relation, .equal)
        XCTAssertEqual(convertedConstraint.secondItem as? UIView, view2)
        XCTAssertEqual(convertedConstraint.secondAttribute, .bottom)
        XCTAssertEqual(convertedConstraint.constant, 2.0)
    }
    
    func testActivate() {
        let view1 = UIView(frame: .zero)
        let view2 = UIView(frame: .zero)
        view1.addSubview(view2)
        
        let constraint: NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1.0, constant: 2.0)
        let convertedConstraint = constraint.activate(priority: UILayoutPriority(60))
        
        XCTAssertEqual(convertedConstraint.priority, UILayoutPriority(60))
        XCTAssertEqual(convertedConstraint.isActive, true)
    }
}
