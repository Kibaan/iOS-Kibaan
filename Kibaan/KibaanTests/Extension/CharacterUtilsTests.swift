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
        var upperCaseStr: Character = "a"
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
    
    private let kanaMap: [Character: Character] = ["あ": "ア", "い": "イ", "う": "ウ", "え": "エ", "お": "オ",
                           "か": "カ", "が": "ガ",
                           "は": "ハ", "ば": "バ", "ぱ": "パ",
                           "っ": "ッ",
                           "ゃ": "ャ", "ゅ": "ュ", "ょ": "ョ",
                           "ぁ": "ァ", "ぃ": "ィ", "ぅ": "ゥ", "ぇ": "ェ", "ぉ": "ォ",
                           "ん": "ン",
                           "ゔ": "ヴ", "ゐ": "ヰ", "ゑ": "ヱ",
                           "ゕ": "ヵ"
    ]
    
    private let noEffectList: [Character] = ["ヷ", "ヸ", "ヹ", "ヺ", "龍", " ", "・", "ー", "ヽ", "ヾ"]
    
    func testHiraganaToKatakana() {
        for (hiragana, katakana) in kanaMap {
            XCTAssertEqual(katakana, hiragana.toKatakana())
        }
    }
    
    func testKatakanaToKatakana() {
        for (_, katakana) in kanaMap {
            XCTAssertEqual(katakana, katakana.toKatakana())
        }
    }
    
    func testKatakanaToHiragana() {
        for (hiragana, katakana) in kanaMap {
            XCTAssertEqual(hiragana, katakana.toHiragana())
        }
    }
    
    func testHiraganaToHiragana() {
        for (hiragana, _) in kanaMap {
            XCTAssertEqual(hiragana, hiragana.toHiragana())
        }
    }
    
    func testToKatakanaNoEffect() {
        noEffectList.forEach {
            XCTAssertEqual($0, $0.toKatakana())
        }
    }
    
    func testToHiraganaNoEffect() {
        noEffectList.forEach {
            XCTAssertEqual($0, $0.toHiragana())
        }
    }
    
    func testHiraganaToKatakanaMulti() {
        XCTAssertEqual("アカイオシャレ龍", "あかいオシャレ龍".toKatakana())
        XCTAssertEqual("あかいおしゃれ龍", "あかいオシャレ龍".toHiragana())
    }
}


