//
//  ConnectionHolder.swift
//  iOSTemplate
//
//  Created by Yamamoto Keita on 2018/07/09.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import UIKit

public class ConnectionHolder {
    static public var connections: [HTTPTask] = []
    
    static public func add(_ task: HTTPTask) {
        connections.append(task)
    }
    
    static public func remove(_ task: HTTPTask) {
        let index = connections.firstIndex(where: {target in
            return target === task
        })
        
        if let index = index {
            connections.remove(at: index)
        }
    }
}
