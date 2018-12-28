//
//  HTTPTextTask.swift
//  Kibaan
//
//  Created by altonotes on 2018/12/28.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Foundation

class HTTPTextTask: HTTPDataTask<String> {
    
    private let url: String
    
    init(url: String) {
        self.url = url
        super.init()
    }
    
    override var requestURL: String {
        return url
    }
    
    override var httpMethod: String {
        return "GET"
    }
}
