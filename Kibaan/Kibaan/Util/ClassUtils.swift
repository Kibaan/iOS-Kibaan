//
//  ClassUtils.swift
//  iOSTemplate
//
//  Created by Akira Nakajima on 2018/09/26.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Foundation

public class ClassUtils {
    
    /// 指定されたオブジェクトのクラス名称を取得する
    static public func className(_ object: AnyObject) -> String {
        return NSStringFromClass(type(of: object))
    }
}
