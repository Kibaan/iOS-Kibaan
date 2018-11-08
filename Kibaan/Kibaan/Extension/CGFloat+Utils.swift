//
//  CGFloat+Utils.swift
//  iOSTemplate
//
//  Created by 山本敬太 on 2018/08/25.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import UIKit

public extension CGFloat {
    var stringValue: String {
        return description
    }
    
    func stringValue(decimalLength: Int) -> String {
        if isNaN {
            return description
        }
        
        return NSDecimalNumber(value: Double(self)).stringValue(decimalLength: decimalLength)
    }
}
