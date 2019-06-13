//
//  Created by 山本 敬太 on 2017/12/25.
//

import UIKit

/// 基盤ViewController
open class SmartViewController: UIViewController {
    
    /// 同クラスのインスタンスが複数存在する場合に識別するためのID
    open var viewID: String = ""
    /// 子のViewController
    private var subControllers = [SmartViewController]()
    /// 表示中の子ViewControllerの配列
    open var foregroundSubControllers: [SmartViewController] { return [] }
    /// 表示中のViewController
    open var foregroundController: SmartViewController { return nextScreens.last ?? self }
    /// 紐づくタスクのコンテナ
    open var taskHolder = TaskHolder()
    /// 上に乗せたオーバーレイ画面
    private var overlays = [SmartViewController]()
    /// オーバーレイ画面が乗っているか
    open var hasOverlay: Bool { return !overlays.isEmpty }
    /// スライド表示させた画面リスト
    private var nextScreens = [SmartViewController]()
    /// スライド表示させた画面の制約
    private var nextScreenConstraints: [NSLayoutConstraint] = []
    /// スライド表示させる画面を追加する対象のビュー
    open var nextScreenTargetView: UIView { return view }
    /// スライドアニメーション時間
    open var nextScreenAnimationDuration: TimeInterval = 0.3
    /// オーバーレイ画面のオーナー
    open weak var owner: SmartViewController?
    /// スライド表示させた画面の遷移のルート
    open weak var navigationRootController: SmartViewController?
    /// 画面表示中かどうか
    open var isForeground: Bool = false
    /// 画面遷移アニメーション
    open var transitionAnimation: TransitionAnimation?
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Lifecycle
    
    open func commonInit() {
        // override by subclass
    }
    
    /// 画面を追加する
    public func added() {
        onAddedToScreen()
    }
    
    /// 画面表示を開始する
    public func enter() {
        foregroundController.onEnterForeground()
    }

    /// 画面表示を終了する
    public func leave() {
        foregroundController.onLeaveForeground()
    }
    
    /// 画面を取り除く
    public func removed() {
        onRemovedFromScreen()
        navigationRootController = nil
    }
    
    /// 画面がスクリーンに追加されたときの処理
    open func onAddedToScreen() {
        subControllers.forEach { $0.added() }
    }
    
    /// 画面がフォアグラウンド状態になったときの処理
    open func onEnterForeground() {
        isForeground = true
        enterForegroundSubControllers()
    }
    
    /// 画面がフォアグラウンド状態から離脱したときの処理
    open func onLeaveForeground() {
        taskHolder.clearAll()
        leaveForegroundSubControllers()
        isForeground = false
    }
    
    /// 画面がスクリーンから取り除かれたときの処理
    open func onRemovedFromScreen() {
        subControllers.forEach { $0.removed() }
    }
    
    /// 子ViewControllerを追加する
    open func addSubController(_ controller: SmartViewController) {
        controller.owner = self
        subControllers.append(controller)
    }
    
    /// 子ViewControllerを複数追加する
    open func addSubControllers(_ controllers: [SmartViewController]) {
        subControllers.forEach {
            $0.owner = self
        }
        subControllers.append(contentsOf: controllers)
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 画面回転時に制約に設定した"constant"を更新する必要がある
        if !nextScreens.isEmpty {
            let constant = nextScreenTargetView.frame.width
            adjustFirstViewConstraintConstant(parentView: nextScreenTargetView.superview, targetView: nextScreenTargetView, constant: constant)
        }
    }
    
    // MARK: - Next screen
    
    /// "targetView"がrootViewに含まれているかをチェックする
    private func checkTargetView(_ targetView: UIView) {
        assert(targetView.isDescendant(of: view), "The target view must be included in the view")
    }
    
    /// ViewControllerをスライド表示させる
    @discardableResult
    open func addNextScreen<T: SmartViewController>(_ type: T.Type, id: String? = nil, cache: Bool = true, animated: Bool = true, prepare: ((T) -> Void)? = nil) -> T? {
        let targetView = nextScreenTargetView
        checkTargetView(targetView)
        let controller = ViewControllerCache.shared.get(type, id: id, cache: cache)
        guard let parentView = targetView.superview, nextScreens.last != controller else {
            return nil
        }
        controller.navigationRootController = self
        let isFirstScreen = nextScreens.isEmpty
        
        // View追加およびビューのサイズ調整用の制約を適用
        let prevView = nextScreens.last?.view ?? targetView
        parentView.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
        controller.view.widthAnchor.constraint(equalTo: targetView.widthAnchor).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: prevView.trailingAnchor).activate(priority: .defaultHigh)
        parentView.layoutIfNeeded()
        
        leave()
        nextScreens += [controller]
        
        // ビューの表示位置を定める制約を適用
        let viewWidth = parentView.frame.size.width
        nextScreenConstraints.last?.priority = .lowest
        if isFirstScreen {
            adjustFirstViewConstraintConstant(parentView: parentView, targetView: prevView, constant: viewWidth)
        }
        let constraint = prevView.trailingAnchor.constraint(equalTo: parentView.leadingAnchor).activate(priority: .highest)
        nextScreenConstraints.append(constraint)

        if animated {
            UIView.animate(withDuration: nextScreenAnimationDuration, animations: {
                parentView.layoutIfNeeded()
            })
        }
        prepare?(controller)
        controller.added()
        controller.enter()
        return controller
    }
    
    /// 指定されたビューのX軸の表示位置を"constant"を利用して調整する
    private func adjustFirstViewConstraintConstant(parentView: UIView?, targetView: UIView?, constant: CGFloat) {
        // FIXME parentViewのconstraintsを操作しているので、SafeAreaと紐付けた場合に移動できない
        let targetAttribute: [NSLayoutConstraint.Attribute] = [.leading, .left, .trailing, .right, .centerX]
        parentView?.constraints.filter {
            return ($0.firstItem as? UIView) == targetView
                && ($0.secondItem as? UIView) == parentView
                && targetAttribute.contains($0.firstAttribute)
        }.forEach {
            $0.constant = -constant
        }
        parentView?.constraints.filter {
            return ($0.firstItem as? UIView) == parentView
                && ($0.secondItem as? UIView) == targetView
                && targetAttribute.contains($0.secondAttribute)
        }.forEach {
            $0.constant = constant
        }
    }
    
    /// スライド表示させたViewControllerを１つ前に戻す
    open func removeNextScreen(animated: Bool = true) {
        let targetView = nextScreenTargetView
        targetView.superview?.layoutIfNeeded()

        let removedScreen = self.nextScreens.removeLast()
        removedScreen.leave()
        
        enter()
        
        let completion = {
            removedScreen.view.removeFromSuperview()
            removedScreen.removed()
        }
        nextScreenConstraints.removeLast().isActive = false
        nextScreenConstraints.last?.priority = .highest
        if nextScreens.isEmpty {
            adjustFirstViewConstraintConstant(parentView: targetView.superview, targetView: targetView, constant: 0)
        }
        
        if animated {
            UIView.animate(withDuration: nextScreenAnimationDuration, delay: 0, options: .curveEaseIn, animations: {
                targetView.superview?.layoutIfNeeded()
            }, completion: { flag in
                completion()
            })
        } else {
            completion()
        }
    }

    /// スライド表示させたViewControllerを全て閉じる
    open func removeAllNextScreen(executeStart: Bool = false) {
        guard isViewLoaded else { return }
        let targetView = nextScreenTargetView
        leave()
        nextScreens.forEach {
            $0.view.removeFromSuperview()
            $0.removed()
        }
        nextScreens.removeAll()
        nextScreenConstraints.forEach { $0.isActive = false }
        nextScreenConstraints.removeAll()
        adjustFirstViewConstraintConstant(parentView: targetView.superview, targetView: targetView, constant: 0)
        if executeStart {
            enter()
        }
    }
    
    // MARK: - Overlay
    
    /// ViewControllerを上に乗せる
    @discardableResult
    open func addOverlay<T: SmartViewController>(_ type: T.Type, id: String? = nil, cache: Bool = true, prepare: ((T) -> Void)? = nil) -> T? {
        let controller = ViewControllerCache.shared.get(type, id: id, cache: cache)
        controller.owner = self
        overlays += [controller]
        
        view.addSubview(controller.view)
        AutoLayoutUtils.fit(controller.view, superView: self.view)
        
        prepare?(controller)
        controller.added()
        controller.enter()
        return controller
    }
    
    /// 上に乗ったViewControllerを外す
    open func removeOverlay<T: SmartViewController>(_ target: T.Type? = nil) {
        if 0 < overlays.count {
            var removed: SmartViewController?
            if let target = target {
                if let index = overlays.firstIndex(where: { type(of: $0) == target }) {
                    removed = overlays.remove(at: index)
                }
            } else {
                removed = overlays.removeLast()
            }
            
            removed?.owner = nil
            removed?.view.removeFromSuperview()
            removed?.leave()
            removed?.removed()
        }
    }
    
    /// 上に乗ったViewControllerを全て外す
    open func removeAllOverlay() {
        let allOverlays = Array(overlays)
        allOverlays.reversed().forEach {
            $0.owner = nil
            $0.view.removeFromSuperview()
            $0.leave()
            $0.removed()
            self.overlays.remove(element: $0)
        }
    }
    
    // MARK: - Other
    
    open func enterForegroundSubControllers() {
        if isForeground {
            foregroundSubControllers.forEach {
                $0.enter()
            }
        }
    }
    
    open func leaveForegroundSubControllers() {
        if isForeground {
            foregroundSubControllers.forEach {
                $0.leave()
            }
        }
    }
}
