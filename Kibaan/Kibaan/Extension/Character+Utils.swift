//
//  Character+Utils.swift
//  iOSTemplate
//
//  Created by Akira Nakajima on 2018/08/29.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Foundation

public extension Character {
    func isUpperCase() -> Bool {
        let set = CharacterSet.uppercaseLetters
        if let scala = UnicodeScalar(String(self)) {
            return set.contains(scala)
        } else {
            return false
        }
    }
    
    func isLowerCase() -> Bool {
        let set = CharacterSet.lowercaseLetters
        if let scala = UnicodeScalar(String(self)) {
            return set.contains(scala)
        } else {
            return false
        }
    }
    
    func toLowerCase() -> String {
        return String(self).lowercased()
    }
    
    func toUpperCase() -> String {
        return String(self).uppercased()
    }
}
