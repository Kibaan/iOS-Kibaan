//
//  Created by Yamamoto Keita on 2018/07/24.
//

import UIKit

/// テキストが横に流れて表示されるラベル
open class TickerLabel: UIView {

    /// 内部テキスト表示用ラベル
    private let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 200))

    /// フォント
    public var font: UIFont {
        get { return label.font }
        set(value) { label.font = value }
    }

    /// テキスト色
    @IBInspectable
    public var textColor: UIColor {
        get { return label.textColor }
        set(value) { label.textColor = value }
    }

    /// テキスト
    open var text: String? {
        get { return label.text }
        set(value) { label.text = value }
    }
    
    /// アニメーション中か
    private var isAnimating = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open func commonInit() {
        clipsToBounds = true
        autoresizesSubviews = false
        addSubview(label)
        
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        label.frame.size.height = frame.height
    }
    
    /// アニメーションを開始する
    open func startAnimation() {
        if !isAnimating {
            animationProcess()
        }
    }
    
    private func animationProcess() {
        initAnimation()
        
        let labelWidth = label.frame.width
        
        // 収まる場合はアニメーションしない
        if labelWidth <= frame.width {
            return
        }
        
        isAnimating = true
        
        let maxScroll = labelWidth + frame.width
        let interval: TimeInterval = TimeInterval(maxScroll * 0.015)
        
        UIView.animate(withDuration: interval, delay: 0, options: .curveLinear,
                       animations: {[weak self] in
                        self?.label.frame.origin.x = -labelWidth
            }, completion: {[weak self] result in
                self?.onCompleteAnimation()
        })
    }
    
    /// アニメーションを停止する
    open func stopAnimation() {
        label.layer.removeAllAnimations()
    }
    
    private func onCompleteAnimation() {
        isAnimating = false
    }
    
    private func initAnimation() {
        if let textWidth = label.text?.size(withAttributes: [.font: label.font as Any]).width {
            label.frame.size.width = textWidth
            label.frame.origin.x = (textWidth <= frame.size.width) ? 0 : frame.width
        }
    }
    
}
