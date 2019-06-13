//
//  Created by 山本 敬太 on 2015/01/16.
//

import UIKit

@IBDesignable
open class SmartButton: UIButton, SmartFontProtocol {
    
    // MARK: - IBInspectable
    
    /// フォントサイズを横幅に応じて調整するか
    @IBInspectable open var adjustsFontSizeToFitWidth: Bool {
        set(value) {
            titleLabel?.adjustsFontSizeToFitWidth = value
        }
        get {
            return titleLabel?.adjustsFontSizeToFitWidth ?? false
        }
    }
    
    /// フォントサイズの最低縮小率
    @IBInspectable open var miniumScaleFactor: CGFloat {
        set(value) {
            titleLabel?.minimumScaleFactor = value
        }
        get {
            return titleLabel?.minimumScaleFactor ?? 0.5
        }
    }
    
    /// 下線を描画するか
    @IBInspectable open var underline: Bool = false {
        didSet {
            updateUnderline()
        }
    }
    
    /// 選択中の背景色
    @IBInspectable open var selectedBackgroundColor: UIColor? {
        get { return backgroundColor(for: .selected) }
        set(value) {
            setBackgroundColor(color: value, for: [.selected])
            setBackgroundColor(color: value, for: [.selected, .highlighted])
        }
    }
    
    @IBInspectable open var disabledBackgroundColor: UIColor? {
        get { return backgroundColor(for: .disabled) }
        set(value) {
            setBackgroundColor(color: value, for: [.disabled])
        }
    }
    
    /// 通常状態の背景色
    override open var backgroundColor: UIColor? {
        get { return super.backgroundColor }
        set(value) {
            setBackgroundColor(color: value, for: .normal)
            setBackgroundColor(color: value, for: [.normal, .highlighted])
        }
    }
    /// 選択中のアイコン画像
    @IBInspectable open var selectedIconImage: UIImage?
    
    /// アイコン画像
    @IBInspectable open var iconImage: UIImage? {
        didSet {
            setupIconImageView()
            iconImageView?.image = iconImage
        }
    }
    /// アイコンの縮尺
    /// 例)横幅の0.5倍にする場合:"w:0.5"
    /// 例)高さの0.8倍にする場合:"h:0.8"
    @IBInspectable open var iconScale: String? {
        didSet {
            guard let iconScale = iconScale else { return }
            iconBaseSide = iconScale.hasPrefix("w") ? .width : .height
            if let scale = iconScale.components(separatedBy: ":").last, let doubleScale = Double(scale) {
                _iconScale = CGFloat(doubleScale)
                updateIconConstraint()
            }
        }
    }
    /// アイコンの上余白
    @IBInspectable open var iconTopInset: CGFloat = 0
    /// アイコンの下余白
    @IBInspectable open var iconBottomInset: CGFloat = 0
    /// アイコンの左余白
    @IBInspectable open var iconLeftInset: CGFloat = 0
    /// アイコンの右余白
    @IBInspectable open var iconRightInset: CGFloat = 0
    
    @IBInspectable open var adjustsFontSizeForDevice: Bool = false { didSet { updateFont() } }
    @IBInspectable open var useGlobalFont: Bool = true { didSet { updateFont() } }
    
    // MARK: - Variables
    
    /// 各状態のRawValueとそれに紐づく背景色のMap
    private var backgroundColorMap: [UInt: UIColor?] = [:]
    /// アイコンのサイズを決める為の基準の向き
    private var iconBaseSide: IconBaseSide = .height
    /// アイコン表示用のImageView
    private var iconImageView: UIImageView?
    /// アイコンの縮尺
    private var _iconScale: CGFloat = 1
    
    /// アイコン表示用の制約
    private var iconConstraints = [NSLayoutConstraint]()
    
    // 端末サイズによるフォントサイズ調整とSmartContextのglobalFontを反映する前のフォント
    private var originalFont: UIFont? {
        didSet {
            updateFont()
        }
    }

    /// 長押しを有効にするか
    open var isEnableRepeat: Bool = true
    /// 長押しを開始するまでの時間（秒）
    open var repeatDelay: Double = 0.5
    /// 長押しイベントの間隔（秒）
    open var repeatInterval: Double = 0.07
    
    /// タイトルフォント
    open var titleFont: UIFont? {
        get {
            return titleLabel?.font
        }
        set(font) {
            originalFont = font
            isBold = font?.isBold ?? false
        }
    }
    
    open var isBold: Bool = false {
        didSet {
            if useGlobalFont, let pointSize = originalFont?.pointSize {
                originalFont = isBold ? UIFont.boldSystemFont(ofSize: pointSize) : UIFont.systemFont(ofSize: pointSize)
            }
        }
    }
    
    override open var contentEdgeInsets: UIEdgeInsets {
        get {
            return adjustsFontSizeForDevice ? super.contentEdgeInsets.scaled(SmartContext.shared.screenScale)  : super.contentEdgeInsets
        }
        set(insets) {
            super.contentEdgeInsets = insets
        }
    }
    
    override open var titleEdgeInsets: UIEdgeInsets {
        get {
            return adjustsFontSizeForDevice ? super.titleEdgeInsets.scaled(SmartContext.shared.screenScale)  : super.titleEdgeInsets
        }
        set(insets) {
            super.titleEdgeInsets = insets
        }
    }
    
    override open var imageEdgeInsets: UIEdgeInsets {
        get {
            return adjustsFontSizeForDevice ? super.imageEdgeInsets.scaled(SmartContext.shared.screenScale)  : super.imageEdgeInsets
        }
        set(insets) {
            super.imageEdgeInsets = insets
        }
    }
    
    /// タイトルの色
    open var titleColor: UIColor? {
        get { return titleColor(for: .normal) }
        set(value) { setTitleColor(value, for: .normal) }
    }

    override open var isSelected: Bool {
        didSet {
            updateBackgroundColor()
            if let iconImageView = iconImageView, let selectedIconImage = selectedIconImage {
                iconImageView.image = isSelected ? selectedIconImage : iconImage
            }
        }
    }

    override open var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    /// 長押しの繰り返し用タイマー
    private var repeatTimer: Timer?
    /// 長押しの最初のディレイ用タイマー
    private var repeatStartTimer: Timer?
    
    // MARK: - Initializer
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// 初期化
    open func commonInit() {
        isExclusiveTouch = true
        showsTouchWhenHighlighted = true

        setHighlightedTitleColor()
        setHighlightedBackgroundImage()

        addTarget(self, action: #selector(self.touchDownAction), for: .touchDown)
        addTarget(self, action: #selector(self.touchEndAction), for: .touchUpInside)
        addTarget(self, action: #selector(self.touchEndAction), for: .touchUpOutside)
        addTarget(self, action: #selector(self.touchEndAction), for: .touchCancel)
        
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = miniumScaleFactor
        titleLabel?.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        
        updateUnderline()
        
        originalFont = titleLabel?.font
        setBackgroundColor(color: backgroundColor, for: .normal)
        setBackgroundColor(color: backgroundColor, for: [.normal, .highlighted])
    }
    
    // MARK: - Life cycle
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        updateIconConstraint()
    }
    
    // MARK: - Methods
    
    /// 指定したステータスの背景色を返す
    open func backgroundColor(for state: UIControl.State) -> UIColor? {
        return backgroundColorMap[state.rawValue] ?? nil
    }
    
    /// 指定したステータスに背景色を設定する
    open func setBackgroundColor(color: UIColor?, for state: UIControl.State) {
        backgroundColorMap[state.rawValue] = color
        updateBackgroundColor()
    }
    
    /// 下線の状態を更新する
    private func updateUnderline() {
        var attrributeStr: NSMutableAttributedString?  = nil
        if underline, let label = titleLabel {
            attrributeStr = NSMutableAttributedString(string: currentTitle ?? "")
            
            attrributeStr?.addAttributes([.font: label.font as Any,
                                         .underlineStyle: NSUnderlineStyle.single.rawValue],
                                         range: NSRange(location: 0, length: currentTitle?.count ?? 0))
        }
        setAttributedTitle(attrributeStr, for: .normal)
    }

    /// ハイライト時のテキストカラーを設定する
    private func setHighlightedTitleColor() {
        let normalColor = titleColor(for: .normal)
        setTitleColor(normalColor, for: .highlighted)

        let selectedColor = titleColor(for: .selected)
        setTitleColor(selectedColor, for: [.selected, .highlighted])
    }
    
    /// ハイライト時の背景画像を設定する
    private func setHighlightedBackgroundImage() {
        let normalImage = backgroundImage(for: .normal)
        setBackgroundImage(normalImage, for: .highlighted)
        
        let selectedImage = backgroundImage(for: .selected)
        setBackgroundImage(selectedImage, for: [.selected, .highlighted])
    }
    
    /// 文字色を設定する
    override open func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        
        if state == .normal || state == .selected {
            setHighlightedTitleColor()
        }
    }
    
    /// 背景画像を設定する
    override open func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
        super.setBackgroundImage(image, for: state)
        if state == .normal || state == .selected {
            setHighlightedBackgroundImage()
        }
    }
    
    /// リピートボタン押下を開始する
    @objc func startRepeat(_ timer: Timer) {
        timer.invalidate()
        removeTimer()
        repeatTimer = Timer.scheduledTimer(timeInterval: repeatInterval, target: self, selector: #selector(self.repeatAction), userInfo: nil, repeats: true)
    }
    
    /// リピート処理
    @objc func repeatAction() {
        sendActions(for: UIControl.Event.touchDown)
    }
    
    /// ボタン押下
    @objc func touchDownAction() {
        if isEnableRepeat && repeatStartTimer == nil && repeatTimer == nil {
            repeatStartTimer = Timer.scheduledTimer(timeInterval: repeatDelay, target: self, selector: #selector(self.startRepeat(_:)), userInfo: nil, repeats: false)
        }
    }

    /// ボタンを離す
    @objc func touchEndAction() {
        removeTimer()
    }

    /// タイマーを削除する
    private func removeTimer() {
        repeatTimer?.invalidate()
        repeatStartTimer?.invalidate()
        
        repeatTimer = nil
        repeatStartTimer = nil
    }
    
    /// 背景色を更新する
    private func updateBackgroundColor() {
        super.backgroundColor = backgroundColor(for: state) ?? backgroundColor(for: .normal)
    }
    
    /// アイコン表示用の制約を更新する
    private func updateIconConstraint() {
        guard let icon = iconImageView else { return }
        
        removeConstraints(iconConstraints)
        iconConstraints.removeAll()
        
        if iconBaseSide == .width {
            iconConstraints += [icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: _iconScale)]
            iconConstraints += [icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)]
        } else {
            iconConstraints += [icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: _iconScale)]
            iconConstraints += [icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0)]
        }
        iconConstraints += [icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: (iconTopInset - iconBottomInset) * frame.height)]
        iconConstraints += [icon.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: (iconLeftInset - iconRightInset) * self.frame.width)]
        
        iconConstraints.forEach { $0.isActive = true }
    }
    
    /// アイコン用のImageViewを追加する
    private func setupIconImageView() {
        if iconImageView == nil {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            addSubview(imageView)
            iconImageView = imageView
            updateIconConstraint()
        }
    }
    
    private func updateFont() {
        titleLabel?.font = convertFont(originalFont)
    }
    
    /// アイコンのサイズを決める為の基準の向き
    public enum IconBaseSide {
        case height
        case width
    }
 }
