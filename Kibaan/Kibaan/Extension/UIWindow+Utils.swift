//
//  UIWindow+Utils.swift
//  Kibaan
//
//  Created by altonotes on 2019/01/11.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import UIKit

extension UIWindow {
    
    /// フォアグラウンドにあるビューコントローラ
    public var foregroundViewController: UIViewController? {
        return rootViewController?.foregroundViewController
    }
}
