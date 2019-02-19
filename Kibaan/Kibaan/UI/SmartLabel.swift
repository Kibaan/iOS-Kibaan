//
//  SmartLabel.swift
//
//  Created by 山本 敬太 on 2016/02/22.
//

import UIKit

/*
 ・NSLocalizedStringから文字列設定可能
 ・一括フォント切替ができる
 ・角丸、枠線が設定可能
 */
@IBDesignable
open class SmartLabel: UILabel, SmartFontProtocol {
    
    // MARK: - Variables
    public override var cornerRadius: CGFloat {
        didSet {
            // UILabelはクリップしないと角丸が表示されないため、角丸が設定されている場合はクリップする
            // 他のViewクラスはクリップなしで角丸表示できるのでSmartLabelのみの独自処理
            // クリップするとドロップシャドウは表示できなくなる
            if 0 < cornerRadius {
                clipsToBounds = true
            }
        }
    }
    
    @IBInspectable open var paddintLeft: CGFloat {
        get { return padding.left }
        set(value) { padding.left = value }
    }
    @IBInspectable open var paddintTop: CGFloat {
        get { return padding.top }
        set(value) { padding.top = value }
    }
    @IBInspectable open var paddintRight: CGFloat {
        get { return padding.right }
        set(value) { padding.right = value }
    }
    @IBInspectable open var paddintBottom: CGFloat {
        get { return padding.bottom }
        set(value) { padding.bottom = value }
    }
    open var padding: UIEdgeInsets = UIEdgeInsets()
    
    override open var font: UIFont! {
        get {
            return super.font
        }
        set(font) {
            originalFont = font
            isBold = font.isBold
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += padding.left + padding.right
        size.height += padding.top + padding.bottom
        return size
    }
    
    open var isBold: Bool = false {
        didSet {
            if useGlobalFont, let pointSize = originalFont?.pointSize {
                originalFont = isBold ? UIFont.boldSystemFont(ofSize: pointSize) : UIFont.systemFont(ofSize: pointSize)
            }
        }
    }

    @IBInspectable open var textId: String? {
        didSet {
            if let key = textId {
                self.text = NSLocalizedString(key, comment: key)
            } else {
                self.text = ""
            }
        }
    }
    @IBInspectable open var adjustsFontSizeForDevice: Bool = false {
        didSet {
            updateFont()
        }
    }
    @IBInspectable open var useGlobalFont: Bool = true {
        didSet {
            updateFont()
        }
    }
    
    // 端末サイズによるフォントサイズ調整とSmartContextのglobalFontを反映する前のフォント
    private var originalFont: UIFont? {
        didSet {
            updateFont()
        }
    }
    
    // MARK: - Initializer
    
    override public init(frame: CGRect) {
        // super.init(frame:)内でフォントがセットされ、originalFontが設定されるのでsetOriginalFontを呼ぶ必要はない
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setOriginalFont()
        commonInit()
    }
    
    private func setOriginalFont() {
        originalFont = super.font
    }

    private func commonInit() {
    }
    
    // MARK: - Functions
    
    private func updateFont() {
        super.font = convertFont(originalFont)
    }
    
    override open func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: padding)
        // drawTextの引数のnewRectによって、フォント自動縮小される
        super.drawText(in: newRect)
    }
}
