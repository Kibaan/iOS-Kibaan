//
//  ListDictionary.swift
//  Kibaan
//
//  Created by altonotes on 2019/03/15.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import Foundation

class ListDictionary: ExpressibleByDictionaryLiteral {
    var keyList = [String]()
    var dictionary = [String: String]()
    var keys: [String] { return keyList }
    
    required init(dictionaryLiteral elements: (String, String)...) {
        for (key, value) in elements {
            keyList.append(key)
            dictionary[key] = value
        }
    }
    
    subscript(key: String) -> String? {
        get { return dictionary[key] }
    }
    
    subscript(index: Int) -> String? {
        get { return dictionary[keyList[index]] }
    }
}
