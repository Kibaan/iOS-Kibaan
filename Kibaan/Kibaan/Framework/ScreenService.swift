//
//  Created by 山本敬太 on 2014/12/29.
//

import UIKit

/// 画面遷移や共通的な画面表示機能
open class ScreenService {

    static public var shared = ScreenService()

    public let window = UIWindow(frame: UIScreen.main.bounds)
    public var defaultTransitionAnimation: TransitionAnimation? = .coverVertical
    
    /// ルートWindowの色
    open var windowColor: UIColor? {
        get { return window.backgroundColor }
        set(value) { window.backgroundColor = value }
    }
    
    /// サブスクリーンのリスト
    private var screenStack: [SmartViewController] = []
    
    /// 画面全体インジケーターの背景
    private var indicatorBackground = UIView()
    
    private var indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)

    /// 一番前面に表示されたViewController
    open var foregroundController: SmartViewController? {
        return screenStack.last
    }
    open var rootViewController: SmartViewController? {
        return screenStack.first
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
    open func setRoot<T: SmartViewController>(_ type: T.Type, prepare: ((T) -> Void)? = nil) -> T {
        let controller = ViewControllerCache.shared.get(type)
        setRootViewController(controller, prepare: prepare)
        return controller
    }
    
    /// RootのViewControllerを設定する
    open func setRootViewController<T: SmartViewController>(_ controller: T, prepare: ((T) -> Void)? = nil) {
        if window.rootViewController == controller {
            return
        }
        
        screenStack.forEach {
            $0.view.removeFromSuperview()
            $0.removed()
        }
        screenStack.removeAll(keepingCapacity: true)

        let oldRootViewController = window.rootViewController as? SmartViewController
        oldRootViewController?.leave()
        window.rootViewController = controller
        screenStack += [controller]
        oldRootViewController?.removed()
        prepare?(controller)
        controller.added()
        controller.enter()
    }
    
    /// 画面を追加する
    @discardableResult
    open func addSubScreen<T: SmartViewController>(_ type: T.Type, nibName: String? = nil, id: String? = nil, cache: Bool = true, transitionType: TransitionType = .normal, prepare: ((T) -> Void)? = nil) -> T? {
        foregroundController?.leave()
        
        let controller = ViewControllerCache.shared.get(type, nibName: nibName, id: id, cache: cache)
        screenStack += [controller]
        
        if let parent = window.rootViewController {
            window.isUserInteractionEnabled = false
            parent.view.addSubview(controller.view)
            AutoLayoutUtils.fit(controller.view, superView: parent.view)
            let finish: () -> Void = {
                self.window.isUserInteractionEnabled = true
            }
            let isNormal = transitionType == TransitionType.normal
            controller.transitionAnimation = isNormal ? defaultTransitionAnimation : transitionType.animation
            if controller.transitionAnimation != nil {
                controller.transitionAnimation?.animator.animateIn(view: controller.view, completion: finish)
            } else {
                finish()
            }
        }
        prepare?(controller)
        controller.added()
        controller.enter()
        
        return controller
    }

    /// 追加した画面を取り除く
    open func removeSubScreen(executeStart: Bool = true, completion: (() -> Void)? = nil) {
        guard screenStack.count > 1 else { return }
        window.isUserInteractionEnabled = false
        foregroundController?.leave()
        
        let removed = screenStack.removeLast()
        let finish: () -> Void = {
            removed.view.removeFromSuperview()
            removed.removed()
            completion?()
            self.window.isUserInteractionEnabled = true
        }
        if removed.transitionAnimation != nil {
            removed.transitionAnimation?.animator.animateOut(view: removed.view, completion: finish)
        } else {
            finish()
        }
        if executeStart {
            screenStack.last?.enter()
        }
    }
    
    /// 追加した画面を取り除く
    open func removeSubScreen(executeStart: Bool = true, to: SmartViewController, completion: (() -> Void)? = nil) {
        guard screenStack.count > 1, screenStack.contains(to) else { return }
        guard let lastViewController = screenStack.last else { return }
        if to === lastViewController {
            return
        }
        window.isUserInteractionEnabled = false
        foregroundController?.leave()
        var removedViewControllers: [SmartViewController] = []
        for viewController in screenStack.reversed() {
            if screenStack.last === to {
                break
            }
            let removed = screenStack.removeLast()
            removedViewControllers.append(removed)
            if viewController != lastViewController {
                viewController.view.removeFromSuperview()
            }
        }
        let finish: () -> Void = {
            lastViewController.view.removeFromSuperview()
            removedViewControllers.forEach {
                $0.removed()
            }
            completion?()
            self.window.isUserInteractionEnabled = true
        }
        if lastViewController.transitionAnimation != nil {
            lastViewController.transitionAnimation?.animator.animateOut(view: lastViewController.view, completion: finish)
        } else {
            finish()
        }
        if executeStart {
            screenStack.last?.enter()
        }
    }
    
    /// 全てのサブ画面を取り除く
    open func removeAllSubScreen(completion: (() -> Void)? = nil) {
        guard screenStack.count > 1 else { return }
        guard let lastViewController = screenStack.last else { return }
        window.isUserInteractionEnabled = false
        foregroundController?.leave()
        foregroundController?.removeAllOverlay()
        
        var removedViewControllers: [SmartViewController] = []
        while 1 < screenStack.count {
            let removed = screenStack.removeLast()
            removedViewControllers.append(removed)
            if removed != lastViewController {
                removed.view.removeFromSuperview()
            }
        }
        let finish: () -> Void = {
            lastViewController.view.removeFromSuperview()
            removedViewControllers.forEach {
                $0.removed()
            }
            completion?()
            self.window.isUserInteractionEnabled = true
        }
        if lastViewController.transitionAnimation != nil {
            lastViewController.transitionAnimation?.animator.animateOut(view: lastViewController.view, completion: finish)
        } else {
            finish()
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
