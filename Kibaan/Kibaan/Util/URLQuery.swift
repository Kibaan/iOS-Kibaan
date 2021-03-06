//
//  Query.swift
//  Kibaan
//
//  Created by Keita Yamamoto on 2018/12/28.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Foundation

/// key=valueの&つなぎ形式のクエリ
open class URLQuery: ExpressibleByDictionaryLiteral {
    
    open var stringValue: String {
        return keyValues.map {
            var item = $0.key.urlEncoded
            if let value = $0.value?.urlEncoded {
                item += "=\(value)"
            }
            return item
        }.joined(separator: "&")
    }
    
    open var keyValues: [KeyValue] = []

    public init() {}

    public init(string: String?) {
        guard let string = string?.trim() else { return }
        
        keyValues = string
            .components(separatedBy: "&")
            .filter { 0 < $0.count }
            .map {
                let pairs = $0.components(separatedBy: "=")
                let key = pairs[0].removingPercentEncoding ?? ""
                let value = 1 < pairs.count ? pairs[1].removingPercentEncoding : nil
                return KeyValue(key: key, value: value)
            }
    }
    
    public required init(dictionaryLiteral elements: (String, String?)...) {
        keyValues = elements.map { KeyValue(key: $0.0, value: $0.1) }
    }
    
    public init(keyValues: [KeyValue]) {
        self.keyValues = keyValues
    }
    
    open subscript (key: String) -> String? {
        get {
            return keyValues.first { $0.key == key }?.value
        }
        set(value) {
            let keyValue = KeyValue(key: key, value: value)
            let offset = keyValues.enumerated().first { $0.element.key == key }?.offset
            
            if let offset = offset {
                keyValues[offset] = keyValue
            } else {
                keyValues.append(keyValue)
            }
        }
    }
    
    open func stringValueCustomEncoded(encoder: (String) -> (String)) -> String {
        return keyValues.map {
            var item = encoder($0.key)
            if let value = $0.value {
                item += "=\(encoder(value))"
            }
            return item
        }.joined(separator: "&")
    }
}
