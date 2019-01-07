import UIKit

// public をつけるとoverride func の open がWarningになるためつけない。
// extensionのアクセスレベルは拡張元のUIScrollViewと同じになるので public がなくてもモジュール外からアクセス可能。
extension UIScrollView {
    // UIScrollViewは`touchesBegan`などのタッチイベントが呼ばれないため、Extensionでoverrideしてイベントを呼び出す

    /// タッチ開始時に呼ばれる処理
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        next?.touchesBegan(touches, with: event)
    }
    
    /// タッチした状態で指を動かした際に呼ばれる処理
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        next?.touchesMoved(touches, with: event)
    }
    
    /// タッチ終了時に呼ばれる処理
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        next?.touchesEnded(touches, with: event)
    }
}
