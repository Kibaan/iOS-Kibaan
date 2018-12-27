//
//  CharacterUtilsTest.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/25.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class CharacterUtilsTests: XCTestCase {
    
    func testIsUpperCase() {
        var upperStr: Character = "A"
        XCTAssertEqual(upperStr.isUpperCase(), true)

        upperStr = "J"
        XCTAssertEqual(upperStr.isUpperCase(), true)

        upperStr = "Z"
        XCTAssertEqual(upperStr.isUpperCase(), true)
    }
    
    func testIsNotUpperCase() {
        var notUpperStr: Character = "a"
        XCTAssertEqual(notUpperStr.isUpperCase(), false)
        
        notUpperStr = "j"
        XCTAssertEqual(notUpperStr.isUpperCase(), false)
        
        notUpperStr = "z"
        XCTAssertEqual(notUpperStr.isUpperCase(), false)
        
        notUpperStr = "1"
        XCTAssertEqual(notUpperStr.isUpperCase(), false)
    }
    
    func testIsLowerCase() {
        var lowerStr: Character = "a"
        XCTAssertEqual(lowerStr.isLowerCase(), true)
        
        lowerStr = "j"
        XCTAssertEqual(lowerStr.isLowerCase(), true)
        
        lowerStr = "z"
        XCTAssertEqual(lowerStr.isLowerCase(), true)
    }
    
    func testIsNotLowerCase() {
        var notLowerCase: Character = "A"
        XCTAssertEqual(notLowerCase.isLowerCase(), false)
        
        notLowerCase = "J"
        XCTAssertEqual(notLowerCase.isLowerCase(), false)
        
        notLowerCase = "Z"
        XCTAssertEqual(notLowerCase.isLowerCase(), false)
        
        notLowerCase = "1"
        XCTAssertEqual(notLowerCase.isLowerCase(), false)
    }
    
    func testToUpperCase() {
        var upperCaseStr:Character = "a"
        XCTAssertEqual(upperCaseStr.toUpperCase(), "A")
        
        upperCaseStr = "j"
        XCTAssertEqual(upperCaseStr.toUpperCase(), "J")
        
        upperCaseStr = "z"
        XCTAssertEqual(upperCaseStr.toUpperCase(), "Z")
        
        upperCaseStr = "1"
        XCTAssertEqual(upperCaseStr.toUpperCase(), "1")
    }
    
    func testNotToUpperCase() {
        var lowerCaseStr: Character = "A"
        XCTAssertEqual(lowerCaseStr.toUpperCase(), "A")
        
        lowerCaseStr = "J"
        XCTAssertEqual(lowerCaseStr.toUpperCase(), "J")
        
        lowerCaseStr = "Z"
        XCTAssertEqual(lowerCaseStr.toUpperCase(), "Z")
        
        lowerCaseStr = "1"
        XCTAssertEqual(lowerCaseStr.toUpperCase(), "1")
    }
    
    func testToLowerCase() {
        var upperCaseStr:Character = "A"
        XCTAssertEqual(upperCaseStr.toLowerCase(), "a")
        
        upperCaseStr = "J"
        XCTAssertEqual(upperCaseStr.toLowerCase(), "j")
        
        upperCaseStr = "Z"
        XCTAssertEqual(upperCaseStr.toLowerCase(), "z")
        
        upperCaseStr = "1"
        XCTAssertEqual(upperCaseStr.toLowerCase(), "1")
    }
    
    func testNotToLowerCase() {
        var lowerCaseStr: Character = "a"
        XCTAssertEqual(lowerCaseStr.toLowerCase(), "a")
        
        lowerCaseStr = "j"
        XCTAssertEqual(lowerCaseStr.toLowerCase(), "j")
        
        lowerCaseStr = "z"
        XCTAssertEqual(lowerCaseStr.toLowerCase(), "z")
        
        lowerCaseStr = "1"
        XCTAssertEqual(lowerCaseStr.toLowerCase(), "1")
    }
}


