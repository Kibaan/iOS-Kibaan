//
//  OSUtils.swift
//
//  Created by cross-c on 2018/01/24.
//

import UIKit

public class OSUtils: NSObject {
    /// URLをSafariで開く
    static public func openUrlInSafari(urlStr: String, onError: (() -> Void)? = nil) {
        guard let url = URL(string: urlStr) else { return }
        if #available(iOS 10.0, *) {
            // iOS10以降
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { canOpened in
                if !canOpened {
                    onError?()
                }
            })
        } else {
            // iOS9
            if !UIApplication.shared.openURL(url) {
                onError?()
            }
        }
    }
    
    /// 外部アプリを起動する
    @available(iOS, deprecated: 10.0)
    static public func openExternalApp(applicationId: String?, scheme: String?) {
        guard let applicationId = applicationId, let scheme = scheme else { return }
        guard let url = URL(string: scheme + "://") else { return }
        // UIApplication#openURLはiOS10からdeprecatedだが、open(url:options:completionHandler:)だと、
        // アプリ起動確認ダイアログでキャンセルを押したときもcompletionHandlerが呼ばれてしまい、
        // 起動できなかったときだけストアを開くことができないため、openURLを使用している。
        if !UIApplication.shared.openURL(url) {
            openUrlInSafari(urlStr: "itms-apps://itunes.apple.com/app/" + applicationId)
        }
    }
    
    /// アプリのバージョンを取得する
    static public func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// BundleIDを取得する
    static public var applicationId: String {
        return Bundle.main.bundleIdentifier ?? ""
    }

    /// 画面の向きがポートレイト（縦）か
    static public var isPortrait: Bool {
        return UIApplication.shared.statusBarOrientation.isPortrait
    }
    
    /// 画面の向きがランドスケープ（横）か
    static public var isLandscape: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    /// PUSH通知が有効か
    static public var isPushNotificationEnable: Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }

}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value) })
}
