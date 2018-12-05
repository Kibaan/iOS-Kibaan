//
//  Created by 山本敬太 on 2014/12/29.
//

import UIKit

/// 画面遷移や共通的な画面表示機能
open class ScreenService {

    static public let shared = ScreenService()

    public let window = UIWindow(frame: UIScreen.main.bounds)
    
    /// ルートWindowの色
    open var windowColor: UIColor? {
        get { return window.backgroundColor }
        set(value) { window.backgroundColor = value }
    }
    
    /// サブスクリーンのリスト
    private var screenStack: [BaseViewController] = []
    
    /// 画面全体インジケーターの背景
    private var indicatorBackground = UIView()
    
    private var indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)

    /// 一番前面に表示されたViewController
    open var foregroundController: BaseViewController? {
        return screenStack.last
    }
    
    /// 初期化
    private init() {
        window.makeKeyAndVisible()

        indicatorBackground.backgroundColor = UIColor(white: 0, alpha: 0.5)
        indicatorBackground.addSubview(indicatorView)
        indicatorView.startAnimating()
        window.addSubview(indicatorBackground)
        AutoLayoutUtils.fit(indicatorBackground, superView: window)

        AutoLayoutUtils.center(indicatorView, superView: indicatorBackground)
    }
    
    /// クラスからRootのViewControllerを設定する
    @discardableResult
    open func setRoot<T: BaseViewController>(_ type: T.Type, prepare: ((T) -> Void)? = nil) -> T {
        let controller = ViewControllerCache.get(type)
        setRootViewController(controller, prepare: prepare)
        return controller
    }
    
    /// RootのViewControllerを設定する
    open func setRootViewController<T: BaseViewController>(_ controller: T, prepare: ((T) -> Void)? = nil) {
        if window.rootViewController == controller {
            return
        }
        
        screenStack.forEach {
            $0.view.removeFromSuperview()
            $0.removed()
        }
        screenStack.removeAll(keepingCapacity: true)

        let oldRootViewController = window.rootViewController as? BaseViewController
        oldRootViewController?.leave()
        window.rootViewController = controller
        oldRootViewController?.removed()
        prepare?(controller)
        controller.added()
        controller.enter()
        
        screenStack += [controller]
    }
    
    /// 画面を追加する
    @discardableResult
    open func addSubScreen<T: BaseViewController>(_ type: T.Type, nibName: String? = nil, id: String? = nil, cache: Bool = true, prepare: ((T) -> Void)? = nil) -> T? {
        
        foregroundController?.leave()
        
        let controller = ViewControllerCache.get(type, nibName: nibName, id: id, cache: cache)
        screenStack += [controller]
        
        if let parent = window.rootViewController {
            parent.view.addSubview(controller.view)
            AutoLayoutUtils.fit(controller.view, superView: parent.view)
        }
        prepare?(controller)
        controller.added()
        controller.enter()
        
        return controller
    }

    /// 追加した画面を取り除く
    open func removeSubScreen(executeStart: Bool = true, targetType: BaseViewController.Type? = nil) {
        foregroundController?.leave()
        while true {
            var removed: BaseViewController? = nil
            if 1 < screenStack.count {
                removed = screenStack.removeLast()
                removed?.view.removeFromSuperview()
                removed?.removed()
            }
            guard let unwrappedRemoved = removed, targetType != nil else { break }
            if type(of: unwrappedRemoved) == targetType {
                break
            }
        }
        if executeStart {
            screenStack.last?.enter()
        }
    }
    
    /// 全てのサブ画面を取り除く
    open func removeAllSubScreen() {
        foregroundController?.leave()
        while 1 < screenStack.count {
            let removed = screenStack.removeLast()
            removed.view.removeFromSuperview()
            removed.removed()
        }
        screenStack.first?.enter()
    }
    
    /// 画面全体にインジケーターを表示する
    open func showScreenIndicator() -> UIView {
        window.bringSubviewToFront(indicatorBackground)
        return indicatorBackground
    }
    
    /// ViewControllerのSupportedInterfaceOrientationを画面に反映する
    open func reflectSupportedInterfaceOrientation() {
        let rootViewController = window.rootViewController
        window.rootViewController = nil
        window.rootViewController = rootViewController
    }
}
