//
//  Double+Util.swift
//  Kibaan
//
//  Created by Keita Yamamoto on 2019/03/20.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import Foundation

public extension Double {
    /// NSDecimalNumberに変換
    var decimalNumber: NSDecimalNumber {
        // NSDecimalNumber(value: Double)を使うと浮動小数点誤差が出るため、NSNumber.stringValueからNSDecimalNumberを作る
        let number = self as NSNumber
        return NSDecimalNumber(string: number.stringValue)
    }
}
