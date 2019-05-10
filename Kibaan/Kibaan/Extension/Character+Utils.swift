//
//  Character+Utils.swift
//  iOSTemplate
//
//  Created by Akira Nakajima on 2018/08/29.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Foundation

public extension Character {
    
    /// 大文字かどうかを返す
    func isUpperCase() -> Bool {
        let set = CharacterSet.uppercaseLetters
        if let scala = UnicodeScalar(String(self)) {
            return set.contains(scala)
        } else {
            return false
        }
    }
    
    /// 小文字かどうかを返す
    func isLowerCase() -> Bool {
        let set = CharacterSet.lowercaseLetters
        if let scala = UnicodeScalar(String(self)) {
            return set.contains(scala)
        } else {
            return false
        }
    }
    
    /// 小文字に変換する
    func toLowerCase() -> String {
        return String(self).lowercased()
    }
    
    /// 大文字に変換する
    func toUpperCase() -> String {
        return String(self).uppercased()
    }
    
    func toHiragana() -> Character {
        guard let code = unicodeScalars.first?.value, (0x30A1...0x30F6).contains(code) else { return self }
        guard let unicodeScalar = UnicodeScalar(code - 0x60) else { return self }
        return Character(unicodeScalar)
    }
    
    func toKatakana() -> Character {
        guard let code = unicodeScalars.first?.value, (0x3041...0x3096).contains(code) else { return self }
        guard let unicodeScalar = UnicodeScalar(code + 0x60) else { return self }
        return Character(unicodeScalar)
    }
}
