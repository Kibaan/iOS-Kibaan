//
//  Created by 山本 敬太 on 2017/10/24.
//

import UIKit

/// アラートダイアログを表示する
public class AlertUtils {
    
    static public var isEnabled = true
    static public var defaultErrorTitle = "エラー"
    static public var defaultCloseLabel = "閉じる"
    
    /// 閉じるだけのアラートを表示する
    static public func showNotice(title: String, message: String, handler:(() -> Void)? = nil) {
        show(title: title, message: message, handler: handler)
    }
    
    /// 閉じるだけのエラーアラートを表示する
    static public func showErrorNotice(message: String, handler:(() -> Void)? = nil) {
        show(title: defaultErrorTitle, message: message, handler: handler)
    }
    
    /// アラートを表示する
    @discardableResult
    static public func show(title: String,
                            message: String,
                            okLabel: String = defaultCloseLabel,
                            handler:(() -> Void)? = nil,
                            cancelLabel: String? = nil,
                            cancelHandler: (() -> Void)? = nil) -> UIAlertController? {
        if !isEnabled { return nil }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: okLabel, style: .default, handler: { action in
            handler?()
        })
        alert.addAction(action)

        if let cancelLabel = cancelLabel {
            let action = UIAlertAction(title: cancelLabel, style: .cancel, handler: { action in
                cancelHandler?()
            })
            alert.addAction(action)
        }
        
        if let viewController = UIApplication.shared.keyWindow?.foregroundViewController {
            viewController.present(alert, animated: true)
        } else {
            print("No root viewcontroller to show alert. \(message)")
        }
        return alert
    }
}
