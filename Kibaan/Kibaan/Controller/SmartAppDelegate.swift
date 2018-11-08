//
//  SmartAppDelegate.swift
//  iOSTemplate
//
//  Created by Keita Yamamoto on 2018/09/12.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import UIKit

open class SmartAppDelegate: UIResponder, UIApplicationDelegate {
    
    // アプリがバックグラウンド状態になった直後に実行される処理
    open func applicationDidEnterBackground(_ application: UIApplication) {
        ScreenService.shared.foregroundController?.leave()
    }
    
    // アプリがバックグラウンドからフォアグラウンドに復帰する際に実行される処理
    open func applicationWillEnterForeground(_ application: UIApplication) {
        ScreenService.shared.foregroundController?.enter()
    }
}
