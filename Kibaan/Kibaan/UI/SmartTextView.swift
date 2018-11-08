import UIKit

/// UITextView共通クラス
/// 共通フォントを使用可能
open class SmartTextView: UITextView, SmartFontProtocol {
    
    override open var font: UIFont! {
        get { return super.font }
        set(font) { super.font = adjustsFontSizeForDevice ? makeAdjustedFont(font) : font }
    }
    
    @IBInspectable open var adjustsFontSizeForDevice: Bool = false
    @IBInspectable open var useGlobalFont: Bool = true { didSet { updateFont() } }
    
    private var baseFontSize: CGFloat { return defaultFont?.pointSize ?? UIFont.labelFontSize }
    private var defaultFont: UIFont?
    
    // MARK: - Methods
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    private func commonInit() {
        defaultFont = super.font
        updateFont()
    }
    
    private func updateFont() {
        let fontManager = SmartContext.shared
        let isBold = (defaultFont?.isBold).isTrue
        if useGlobalFont, let font = fontManager.getFont(size: baseFontSize, type: isBold ? .bold : .regular) {
            self.font = font
        } else {
            font = defaultFont
        }
    }
    
    private func makeAdjustedFont(_ font: UIFont?) -> UIFont? {
        guard let font = font else { return nil }
        return UIFont(descriptor: font.fontDescriptor, size: baseFontSize * SmartContext.shared.screenScale)
    }

    /// トップにスクロールする
    open func scrollToTop(animated: Bool = false) {
        setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: animated)
    }

}
