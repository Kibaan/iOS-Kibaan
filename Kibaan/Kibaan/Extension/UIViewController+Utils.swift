//
//  UIViewController+Utils.swift
//  Kibaan
//
//  Created by altonotes on 2019/01/15.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// フォアグラウンドにあるビューコントローラ
    public var foregroundViewController: UIViewController {
        if let controller = presentedViewController {
            return controller.foregroundViewController
        }
        return self
    }
}
