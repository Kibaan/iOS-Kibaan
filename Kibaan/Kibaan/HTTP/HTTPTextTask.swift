//
//  HTTPTextTask.swift
//  Kibaan
//
//  Created by altonotes on 2018/12/28.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Foundation

open class HTTPTextTask: HTTPDataTask<String> {
    
    private let url: String
    private var defaultEncoding: String.Encoding
    
    public init(url: String, defaultEncoding: String.Encoding = .utf8) {
        self.url = url
        self.defaultEncoding = defaultEncoding
        super.init()
    }
    
    override open var requestURL: String {
        return url
    }
    
    override open var httpMethod: String {
        return "GET"
    }
    
    override open func parseResponse(_ data: Data, response: HTTPURLResponse) throws -> String {
        var stringEncoding: String.Encoding = defaultEncoding
        if let textEncodingName = response.textEncodingName as CFString? {
            let responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(textEncodingName))
            let encoding: String.Encoding? = String.Encoding(rawValue: responseEncoding)
            if let encoding = encoding {
                stringEncoding = encoding
            }
        }
        if let string = String(data: data, encoding: stringEncoding) {
            return string
        }
        throw HTTPTaskError.parse
    }
}
