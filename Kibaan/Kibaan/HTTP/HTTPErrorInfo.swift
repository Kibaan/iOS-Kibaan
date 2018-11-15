//
//  HTTPErrorInfo.swift
//  Kibaan
//
//  Created by Keita Yamamoto on 2018/11/15.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Foundation

public struct HTTPErrorInfo {
    var error: Error?
    var response: HTTPURLResponse?
    var data: Data?
}
