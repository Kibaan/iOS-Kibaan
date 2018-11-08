//
//  Created by 山本敬太 on 2018/01/04.
//

import UIKit

/// 裏の View にタッチイベントを貫通させる View
/// サブビューはタッチに反応するので、userInteractionEnabled = NO とは挙動が異なる。
/// 自身はタッチに反応しないが、上に乗ってるボタンなどは反応させたい場合に使う。
open class TouchThroughView: UIView {
    
    open var onTouch: (() -> Void)?
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            onTouch?()
            return nil
        }
        return view
    }
}
