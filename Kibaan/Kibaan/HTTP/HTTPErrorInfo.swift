//
//  HTTPErrorInfo.swift
//  Kibaan
//
//  Created by Keita Yamamoto on 2018/11/15.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Foundation

public struct HTTPErrorInfo {
    public var error: Error?
    public var response: HTTPURLResponse?
    public var data: Data?
    
    public init(error: Error?, response: HTTPURLResponse?, data: Data?) {
        self.error = error
        self.response = response
        self.data = data
    }
}
