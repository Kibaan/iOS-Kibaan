//
//  CaseIterable+Utils.swift
//  iOSTemplate
//
//  Created by altonotes on 2018/11/07.
//  Copyright © 2018 altonotes. All rights reserved.
//

import Foundation

public extension CaseIterable {
    /// 全ての値のコレクションを返す.
    /// Android版で"allCases"を実装することが出来ない為、本メソッドを追加した
    static func values() -> Self.AllCases {
        return Self.allCases
    }
}
