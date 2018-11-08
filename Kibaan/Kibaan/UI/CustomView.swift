//
//  Created by 山本敬太 on 2016/02/04.
//

import UIKit

/// UIViewカスタムクラスの共通既定クラス
/// 共通の初期化処理 `commonInit` を呼び出すためだけに用意している
open class CustomView: UIView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// 全てのコンストラクターで共通の初期化処理
    open func commonInit() {
        // Override me
    }
}
