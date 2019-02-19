//
//  AppDelegate.swift
//  KibaanSample
//
//  Created by Keita Yamamoto on 2018/11/08.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Kibaan

@UIApplicationMain
class AppDelegate: SmartAppDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let regularFonts: [[UIFontDescriptor.AttributeName: Any]] = [
            [.name: "Chalkboard SE", .face: "Regular"]
        ]
        SmartContext.shared.setFonts(regularFonts, type: .regular)

        let boldFonts: [[UIFontDescriptor.AttributeName: Any]] = [
            [.name: "Gill Sans", .face: "UltraBold"]
        ]
        SmartContext.shared.setFonts(boldFonts, type: .bold)

        ScreenService.shared.setRoot(LauncherViewController.self)

        return true
    }
}

