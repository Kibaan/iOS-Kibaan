//
//  IOUtils.swift
//  iOSTemplate
//
//  Created by Yamamoto Keita on 2018/08/09.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Foundation

public class IOUtils {
    
    /// リソースファイルを読み込んでStringを取得する
    static public func readResourceString(name: String, type: String) -> String? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                return try String(contentsOfFile: path)
            } catch {
                print(error)
            }
        }
        return nil
    }
}
