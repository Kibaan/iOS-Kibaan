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
    public var keys: [Key] { return keyList }
    
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            append(key: key, value: value)
        }
    }
    
    public init() {}
    
    public subscript(key: Key) -> Value? {
        get { return dictionary[key] }
        set(value) {
            guard let value = value else {
                remove(key: key)
                return
            }
            append(key: key, value: value)
        }
    }
    
    public subscript(index: Int) -> Value? {
        get {
            if index < 0 || keyList.count <= index {
                return nil
            }
            return dictionary[keyList[index]]
        }
        set(value) {
            guard let value = value else {
                remove(index: index)
                return
            }
            append(key: keyList[index], value: value)
        }
    }
    
    public func append(key: Key, value: Value) {
        if dictionary[key] == nil {
            keyList.append(key)
        }
        dictionary[key] = value
    }

    public func remove(key: Key) {
        keyList.remove(equatable: key)
        dictionary[key] = nil
    }

    public func remove(index: Int) {
        if index < 0 || keyList.count <= index {
            return
        }
        let key = keyList.remove(at: index)
        dictionary[key] = nil
    }
    
    public func removeAll() {
        keyList.removeAll()
        dictionary.removeAll()
    }
}
