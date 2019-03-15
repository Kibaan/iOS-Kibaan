//
//  ListDictionary.swift
//  Kibaan
//
//  Created by altonotes on 2019/03/15.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import Foundation

public class ListDictionary<Key, Value>: ExpressibleByDictionaryLiteral where Key: Hashable {
    var keyList = [Key]()
    var dictionary = [Key: Value]()
    var keys: [Key] { return keyList }
    
    public required init(dictionaryLiteral elements: (String, String)...) {
        for (key, value) in elements {
            append(key: key, value: value)
        }
    }
    
    public init() {}
    
    public subscript(key: Key) -> Value? {
        get { return dictionary[key] }
        set(value) { append(key: key, value: value) }
    }
    
    public subscript(index: Int) -> Value? {
        get { return dictionary[keyList[index]] }
        set(value) { append(key: keyList[index], value: value) }
    }
    
    public func append(key: Key, value: Value?) {
        keyList.append(key)
        dictionary[key] = value
    }
    
    public func removeAll() {
        keyList.removeAll()
        dictionary.removeAll()
    }
}
