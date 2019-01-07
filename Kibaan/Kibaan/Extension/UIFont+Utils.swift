//
//  UIFont+Utils.swift
//  iOSTemplate
//
//  Created by Akira Nakajima on 2018/08/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import UIKit

public extension UIFont {

    /// 太字かどうかを返す
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
}
