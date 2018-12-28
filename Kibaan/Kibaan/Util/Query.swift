//
//  Query.swift
//  Kibaan
//
//  Created by Keita Yamamoto on 2018/12/28.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Foundation

open class Query {
    
    open var stringValue: String {
        return ""
    }
    
    open var keyValues: [KeyValue] {
        return []
    }

    public init() {
    }

    public init(string: String) {
    }
    
    public init(keyValues: [KeyValue]) {
        
    }
    
    open subscript (key: String) -> String? {
        get {
            return nil
        }
        set(value) {
        }
    }
}
