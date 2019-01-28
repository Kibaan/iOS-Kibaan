//
//  Created by 山本敬太 on 2015/04/12.
//

import UIKit

/// SmartFontProtocolに準拠したテキストフィールド
open class SmartTextField: UITextField, SmartFontProtocol {
    
    /// 最大文字数が未制限
    private static let unlimited: Int = -1
    /// プレースホルダーのフォントサイズが未指定
    private static let undefined: CGFloat = -1
    
    // MARK: - IBInspectable

    /// 左パディングサイズ
    @IBInspectable open var paddingLeft: CGFloat = 2
    /// 右パディングサイズ
    @IBInspectable open var paddingRight: CGFloat = 2
    /// 最大文字数
    @IBInspectable open var maxLength: Int = unlimited
    /// プレースホルダーのフォントサイズ
    @IBInspectable open var placeholderFontSize: CGFloat = undefined
    /// フォントサイズを端末サイズに合わせて拡大縮小するか
    @IBInspectable open var adjustsFontSizeForDevice: Bool = false
    /// SmartContextの共通フォントを使用するか
    @IBInspectable open var useGlobalFont: Bool = true { didSet { updateFont() } }
    /// 完了ボタンを表示するか
    @IBInspectable open var showCompleteButton: Bool = true {
        didSet {
            if showCompleteButton {
                addCompleteButton()
            } else {
                inputAccessoryView = nil
            }
        }
    }

    // MARK: - Variables
    
    override open var font: UIFont! {
        get {
            return super.font
        }
        set(font) {
            originalFont = font
        }
    }
    
    /// 端末サイズによるフォントサイズ調整とSmartContextのglobalFontを反映する前のフォント
    private var originalFont: UIFont? {
        didSet {
            updateFont()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var rightView: UIView? {
        didSet {
            rightView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
            rightView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
    
    override open var leftView: UIView? {
        didSet {
            leftView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
            leftView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }

    /// テキストフィールドデリゲート
    private var delegateWrapper = InnerTextFieldDelegate()

    override open var delegate: UITextFieldDelegate? {
        get { return delegateWrapper.delegate }
        set(value) {
            delegateWrapper.delegate = value
        }
    }
    
    // MARK: - Initializer
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(delegateWrapper)
    }
    
    open func commonInit() {
        super.delegate = delegateWrapper
        originalFont = super.font
        if showCompleteButton {
            addCompleteButton()
        }
        NotificationCenter.default.addObserver(delegateWrapper, selector: #selector(delegateWrapper.textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: self)
    }
    
    // MARK: - Action
    
    /// 完了ボタンを押したとき
    @objc private func actionCompleteButton() {
        resignFirstResponder()
    }
    
    // MARK: - Font
    
    private func updateFont() {
        super.font = convertFont(originalFont)
    }
    
    // MARK: - Override function
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return calcRect(forBounds: bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return calcRect(forBounds: bounds)
    }
    
    override open var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    // MARK: - Private
    
    /// CGRectから、LeftView、RightViewおよびパディングの余白を削ったCGRectを返す
    private func calcRect(forBounds bounds: CGRect) -> CGRect {
        let x = paddingLeft + (leftView?.frame.width ?? 0)
        let width = bounds.width - x - paddingRight - (rightView?.frame.width ?? 0)
        return CGRect(x: x, y: 0, width: width, height: bounds.height)
    }
    
    /// キーボードのツールバーに完了ボタンを追加する
    private func addCompleteButton() {
        let toolBar = UIToolbar(frame: .zero)
        toolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.actionCompleteButton))
        toolBar.items = [spacer, commitButton]
        inputAccessoryView = toolBar
    }
    
    /// プレースホルダーのフォントサイズを更新する
    private func updatePlaceholder() {
        if let placeholder = placeholder, placeholderFontSize != SmartTextField.undefined {
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: font.withSize(placeholderFontSize)])
        }
    }
    
    // MARK: - Other
    
    /// TextFieldの内部デリゲート
    private class InnerTextFieldDelegate: NSObject, UITextFieldDelegate {
        
        weak var delegate: UITextFieldDelegate?
        
        private var previousText: String?
        private var lastReplaceRange: NSRange?
        private var lastReplacementString: String?
        
        override func responds(to aSelector: Selector!) -> Bool {
            return super.responds(to: aSelector) || (delegate?.responds(to: aSelector) ?? false)
        }
        
        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            if let delegate = delegate, delegate.responds(to: aSelector) {
                return delegate
            } else {
                return super.forwardingTarget(for: aSelector)
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            previousText = textField.text
            lastReplaceRange = range
            lastReplacementString = string
            return true
        }
        
        @objc func textFieldDidChange(notification: NSNotification) {
            guard let textField = notification.object as? SmartTextField, textField.markedTextRange == nil else { return }
            guard let selectedTextRange = textField.selectedTextRange, textField.maxLength != unlimited, let text = textField.text else { return }
            let maxLength = textField.maxLength
            if maxLength < text.count, let lastReplacementString = lastReplacementString, let previousText = previousText, let range = lastReplaceRange {
                let overCount = text.count - maxLength
                
                // 絵文字を入力した際に"overCount"が"lastReplacementString.count"を超える場合ある為、以下の処理をしている
                let end = max(0, lastReplacementString.count - overCount)
                let replacementString = lastReplacementString[0..<end] ?? ""
                let text = (previousText as NSString).replacingCharacters(in: range, with: replacementString)
                let textFieldOffset = replacementString.utf16.count - lastReplacementString.utf16.count
                if let position = textField.position(from: selectedTextRange.start, offset: textFieldOffset) {
                    let selectedTextRange = textField.textRange(from: position, to: position)
                    // コピー＆ペーストされた場合に、設定したカーソル位置が上書きされてしまう為、以下のように遅延実行している
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        textField.selectedTextRange = selectedTextRange
                    }
                }
                textField.text = text
            }
        }
    }
}
