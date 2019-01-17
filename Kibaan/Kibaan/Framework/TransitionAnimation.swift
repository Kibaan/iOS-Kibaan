//
//  TransitionAnimation.swift
//  Kibaan
//
//  Created by altonotes on 2019/01/11.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import Foundation

public enum TransitionAnimation {
    case coverVertical
    
    var animator: TransitionAnimator {
        switch self {
        case .coverVertical:
            return CoverVertical()
        }
    }
}
