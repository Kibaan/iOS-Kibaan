//
//  TransitionType.swift
//  Kibaan
//
//  Created by altonotes on 2019/01/11.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import Foundation

public enum TransitionType {
    case normal
    case coverVertical
    case notAnimated
    
    var animation: TransitionAnimation? {
        switch self {
        case .coverVertical:
            return .coverVertical
        default:
            return nil
        }
    }
}
