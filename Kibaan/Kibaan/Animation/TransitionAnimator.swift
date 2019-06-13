//
//  TransitionAnimator.swift
//  Kibaan
//
//  Created by altonotes on 2019/01/16.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import UIKit

protocol TransitionAnimator {
    
    func animateIn(view: UIView?, completion: (() -> Void)?)
    
    func animateOut(view: UIView?, completion: (() -> Void)?)
}
