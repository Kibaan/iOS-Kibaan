//
//  Created by altonotes on 2019/04/22.
//

import UIKit

/// 無限スクロールするセグメントボタン群
/// - 全ボタンが横幅に収まりきる場合は、隙間が空かないよう全ボタンを均等配置して、スクロールを無効にする
/// - ループを考慮して1つダミーのボタンを作る（左右端どちらにも同じボタンが見える場合があるため）
open class ScrollSegmentedButton: UIScrollView, UIScrollViewDelegate {
    
    // MARK: - Variables
    
    @IBInspectable open var textSize: CGFloat = 14.0
    @IBInspectable open var scrollButtonWidth: CGFloat = 100
    @IBInspectable open var titlesText: String {
        get { return titles.joined(separator: ",") }
        set(value) {
            titles = value.components(separatedBy: ",")
        }
    }
    @IBInspectable open var buttonCount: Int = 0 {
        didSet {
            setup(buttonCount: buttonCount)
        }
    }
    
    /// 実際に表示するボタンの横幅
    open var buttonWidth: CGFloat {
        return isFitButtons ? (frame.width / CGFloat(titles.count)) : scrollButtonWidth
    }
    
    /// 選択中のインデックス
    open var selectedIndex: Int? {
        get {
            if titles.count <= buttons.count {
                return buttons[0..<titles.count].enumerated().first(where: { $0.element.isSelected })?.offset
            }
            return 0
        }
        set(value) {
            select(value, needsCallback: true)
        }
    }
    open var titles: [String] = [] {
        didSet {
            updateButtonTitles()
        }
    }
    open var buttons: [UIButton] = []
    
    open var onSelected: ((_ oldIndex: Int?, _ index: Int) -> Void)?
    
    // MARK: - Private Variables
    
    /// ダミーボタン
    private var dummyButton: UIButton = UIButton()
    
    /// 直前のサイズ
    /// サイズが変わった場合にページサイズや位置の調整が必要なため、サイズ変更が分かるよう直前のサイズを保存している
    private var previousSize: CGSize?
    
    /// 余白部分に移動するボタン個数
    private var marginCount: Int {
        return Int(frame.width / scrollButtonWidth)
    }
    
    /// ボタンが端末の横幅に収まるか
    private var isFitButtons: Bool {
        return CGFloat(titles.count) * scrollButtonWidth <= frame.width
    }
    
    /// 左端に表示しているボタン
    private var leftEndButton: UIButton? {
        return buttons.sorted(by: { (lhs, rhs) in lhs.frame.minX < rhs.frame.minX }).first
    }
    
    /// ボタンの見た目を更新する為の処理
    private var buttonUpdater: ((UIButton, ButtonState) -> Void)?
    
    // MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open func commonInit() {
        delegate = self
        showsHorizontalScrollIndicator = false
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // サイズが変わった場合
        if previousSize == nil || previousSize != frame.size {
            isScrollEnabled = !isFitButtons
            updateScrollSize()
            updateButtonSize()
            moveToCenter(animated: false)
            updateButtonPosition()
            previousSize = frame.size
        }
    }
    
    // MARK: - Initializer
    
    open func setup(buttonCount: Int, buttonMaker: (() -> UIButton)? = nil, buttonUpdater: ((UIButton, ButtonState) -> Void)? = nil) {
        self.buttonUpdater = buttonUpdater
        makeButtons(buttonCount: buttonCount, buttonMaker: buttonMaker ?? makeDefaultButton)
    }
    
    open func setup(titles: [String], buttonMaker: (() -> UIButton)? = nil, buttonUpdater: ((UIButton, ButtonState) -> Void)? = nil) {
        self.titles = titles
        self.buttonUpdater = buttonUpdater
        makeButtons(buttonCount: titles.count, buttonMaker: buttonMaker ?? makeDefaultButton)
    }
    
    open func makeDefaultButton() -> UIButton {
        let button = SmartButton(frame: .zero)
        button.titleFont = UIFont.systemFont(ofSize: textSize)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.adjustsFontSizeToFitWidth = true
        button.miniumScaleFactor = 0.5
        return button
    }
    
    open func defaultButtonStateUpdater(button: UIButton, buttonState: ButtonState) {
        guard let pointSize = button.titleLabel?.font.pointSize else { return }
        switch buttonState {
        case .unselected:
            button.titleLabel?.font = UIFont.systemFont(ofSize: pointSize)
        case .selected:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: pointSize)
        }
    }
    
    open func makeButtons(buttonCount: Int, buttonMaker: (() -> UIButton)) {
        clearView()
        buttons = (0..<buttonCount).map { _ in
            let button = buttonMaker()
            addSubview(button)
            button.addTarget(self, action: #selector(self.actionSelect(_:)), for: .touchUpInside)
            return button
        }
        dummyButton = buttonMaker()
        addSubview(dummyButton)
        updateButtonTitles()
        updateButtonPosition()
        isScrollEnabled = !isFitButtons
    }
    
    // MARK: - Others
    
    open func select(_ index: Int?, animated: Bool = true, needsCallback: Bool = true) {
        guard let index = index else { return }
        buttons.forEach { $0.isSelected = false }
        buttons[safe: index]?.isSelected = true
        updateButton()
        if isScrollEnabled {
            moveToCenter(animated: animated)
        }
    }
    
    open func clear() {
        buttonCount = 0
        titles.removeAll()
        clearView()
    }
    
    open func clearView() {
        previousSize = nil
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    // MARK: - Action
    
    @objc private func actionSelect(_ button: SmartButton) {
        let oldIndex = selectedIndex
        buttons.forEach { $0.isSelected = false }
        if isDummyButton(button) {
            leftEndButton?.isSelected = true
        } else {
            button.isSelected = true
        }
        updateButton()
        if isScrollEnabled {
            moveToCenter(animated: true)
        }
        if let index = selectedIndex {
            onSelected?(oldIndex, index)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    /// スクロール時の処理
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let fullWidth = contentSize.width
        let maxScrollOffset = fullWidth - frame.size.width
        if contentOffset.x < 0 {
            // 左端を超える場合は右端に移動する
            contentOffset.x = maxScrollOffset
        } else if maxScrollOffset < contentOffset.x {
            // 右端を超える場合は左端に移動する
            contentOffset.x -= maxScrollOffset
        }
        updateButtonPosition()
    }
    
    // MARK: - Update
    
    /// 各ボタンのX座標を調整する
    private func updateButtonPosition() {
        if titles.isEmpty {
            return
        }
        // まずはページ順に横並び
        buttons.enumerated().forEach {
            $0.element.frame.origin.x = buttonWidth * CGFloat($0.offset)
        }
        // 右端のさらに右が見える場合、ボタンをさらに右にもってくる
        if isScrollEnabled {
            let marginCount = self.marginCount
            (0...marginCount).forEach { index in
                if buttonWidth * CGFloat(buttons.count - (marginCount - index)) < contentOffset.x {
                    buttons[safe: index]?.frame.origin.x = buttonWidth * CGFloat(buttons.count + index)
                }
            }
            updateDummyButton()
        }
    }
    
    private func updateDummyButton() {
        // ダミーボタンは常に右端に表示する
        if let maxX = buttons.map({ $0.frame.maxX }).sorted().last {
            dummyButton.frame.origin.x = maxX
        }
        // 左端のボタンを取得してダミーボタンに反映
        if let targetButton = leftEndButton {
            dummyButton.setTitle(targetButton.title(for: .normal), for: .normal)
            dummyButton.isSelected = targetButton.isSelected
        }
    }
    
    /// スクロールコンテンツのサイズを設定する
    private func updateScrollSize() {
        if isFitButtons {
            // 横幅一杯とする
            contentSize = CGSize(width: frame.width, height: frame.height)
        } else {
            // ボタン数 + 余白1ページ分のサイズをとる
            contentSize = CGSize(width: scrollButtonWidth * CGFloat(titles.count) + frame.width, height: frame.height)
        }
    }
    
    /// ボタンの横幅を更新設定する
    private func updateButtonSize() {
        if titles.isEmpty { return }
        buttons.forEach {
            $0.frame.size.width = buttonWidth
            $0.frame.size.height = frame.height
        }
        dummyButton.frame.size.width = buttonWidth
        dummyButton.frame.size.height = frame.height
    }
    
    /// ボタンのタイトルを設定する
    private func updateButtonTitles() {
        zip(buttons, titles).forEach { button, title in
            button.setTitle(title, for: .normal)
        }
    }
    
    /// ボタンの見た目を更新する
    private func updateButton() {
        let updater = buttonUpdater ?? defaultButtonStateUpdater
        buttons.forEach {
            let buttonState = $0.isSelected ? ButtonState.selected : ButtonState.unselected
            updater($0, buttonState)
        }
    }
    
    // MARK: - Other
    
    /// ダミーボタンかどうか
    private func isDummyButton(_ button: SmartButton) -> Bool {
        return button == dummyButton
    }
    
    /// 選択中のボタンが中心に表示されるように位置を調整する
    private func moveToCenter(animated: Bool) {
        if !isScrollEnabled || contentSize == .zero {
            contentOffset.x = 0
            return
        }
        guard let index = selectedIndex else { return }
        let x1 = scrollButtonWidth * CGFloat(index) - (frame.width / 2) + (scrollButtonWidth / 2)
        let x2 = x1 + (scrollButtonWidth * CGFloat(titles.count))
        if abs(contentOffset.x - x1) < abs(contentOffset.x - x2) && animated {
            setContentOffset(CGPoint(x: x1, y: 0), animated: animated)
        } else {
            setContentOffset(CGPoint(x: x2, y: 0), animated: animated)
        }
    }
    
    public enum ButtonState {
        case unselected
        case selected
    }
}
