//
//  SecureStorage.swift
//  iOSTemplate
//
//  Created by Akira Nakajima on 2018/09/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Foundation

open class SecureStorage {
    
    public init() {
    }
    
    // MARK: - Save
    
    @discardableResult
    open func save(_ value: String?, key: String) -> Bool {
        return saveData(key: key, data: value?.data(using: .utf8))
    }
    
    // MARK: - Load
    
    open func load(key: String) -> String? {
        guard let data = loadData(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Delete
    
    @discardableResult
    open func delete(key: String) -> Bool {
        let query = createQuery(key: key)
        return SecItemDelete(query as CFDictionary) == noErr
    }
    
    @discardableResult
    open func clear() -> Bool {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword]
        return SecItemDelete(query as CFDictionary) == noErr
    }
    
    // MARK: - Support
    
    open func loadData(key: String) -> Data? {
        let query = createQuery(key: key, addQuery: [kSecReturnData: kCFBooleanTrue])
        var dataTypeRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }
    
    open func saveData(key: String, data: Data?) -> Bool {
        guard let data = data else {
            return delete(key: key)
        }
        var query = createQuery(key: key)
        if contains(query: query) {
            return SecItemUpdate(query as CFDictionary, [kSecValueData: data] as CFDictionary) == noErr
        } else {
            query[kSecValueData] = data
            return SecItemAdd(query as CFDictionary, nil) == noErr
        }
    }
    
    private func contains(query: [CFString: Any]) -> Bool {
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == noErr
    }
    
    private func createQuery(key: String, addQuery: [CFString: Any]? = nil) -> [CFString: Any] {
        var query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: OSUtils.applicationId,
            kSecAttrAccount: key,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ]
        addQuery?.forEach {
            query[$0.key] = $0.value
        }
        return query
    }
}
