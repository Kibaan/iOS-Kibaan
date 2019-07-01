//
//  Created by NakajimaAkira on 2017/12/26.
//

import UIKit

/// セグメント状のボタン。セグメントの一つのボタンを選択状態にできる
@IBDesignable
open class SegmentedButton: CustomView {
    
    // MARK: - Constants
    
    /// IBInspectable "names" の区切り文字
    private let columnSeparator = ","
    /// 未指定のサイズを表す数値
    private let undefinedSize = -1
    
    // MARK: - Variables

    /// ボタンと紐づく値のマップ
    private var buttonGroup = ButtonGroup<String>()
    /// タップ時の処理
    private var tapHandler: ((String) -> Void)?
    /// タップ時の処理（タップ前の選択値付き）
    private var tapHandlerWithOldValue: ((String?, String) -> Void)?
    /// 縦のスタックビュー。2行以上になる場合このビューにスタックされる
    private var verticalStackView: UIStackView = UIStackView()
    /// 角丸サイズ
    open var segmentCornerRadius: CGFloat = 6 {
        didSet {
            if style != Style.custom.rawValue {
                verticalStackView.arrangedSubviews.compactMap { $0 as? UIStackView }.forEach {
                    setCornerRadius(stackView: $0)
                }
            }
        }
    }
    /// ボタン間の横スペース
    @IBInspectable open var horizontalSpacing: CGFloat = 1.0 {
        didSet {
            verticalStackView.arrangedSubviews.forEach { view in
                (view as? UIStackView)?.spacing = horizontalSpacing
            }
        }
    }
    /// ボタン間の縦スペース
    @IBInspectable open var verticalSpacing: CGFloat = 1.0 {
        didSet { verticalStackView.spacing = verticalSpacing }
    }

    // MARK: - Inspectable
    /// スタイル
    public var styleType: Style = .custom {
        didSet {
            if style != Style.custom.rawValue {
                verticalStackView.arrangedSubviews.compactMap { $0 as? UIStackView }.forEach {
                    setCornerRadius(stackView: $0)
                }
            }
        }
    }
    /// ボタンの表示スタイル（squareまたはroundedSquare）
    @IBInspectable open var style: String {
        get { return styleType.rawValue }
        set(value) { styleType = Style(rawValue: value) ?? .custom }
    }
    /// テキストのフォントサイズ
    @IBInspectable open var textSize: CGFloat = 14.0 {
        didSet { constructSegments() }
    }
    /// ボタンのテキストラベル。カンマ区切りで複数指定する
    @IBInspectable open var names: String = "" {
        didSet { updateSegmentTitles() }
    }
    /// セグメントの列数
    @IBInspectable open var columnSize: Int = 3 {
        didSet { constructSegments() }
    }
    /// セグメントの行数
    @IBInspectable open var rowSize: Int = 1 {
        didSet { constructSegments() }
    }
    /// 非選択状態のボタン背景色
    @IBInspectable open var normalButtonBackgroundColor: UIColor = .lightGray {
        didSet { constructSegments() }
    }
    /// 選択状態のボタン背景色
    @IBInspectable open var selectedButtonBackgroundColor: UIColor = UIColor(rgbValue: 0x0679FF) {
        didSet { constructSegments() }
    }
    /// 非選択状態のボタン文字色
    @IBInspectable open var normalButtonTextColor: UIColor = .white {
        didSet { constructSegments() }
    }
    /// 選択状態のボタン文字色
    @IBInspectable open var selectedButtonTextColor: UIColor = .white {
        didSet { constructSegments() }
    }
    /// 非活性状態のボタン文字色
    @IBInspectable open var disabledButtonTextColor: UIColor = .lightGray {
        didSet { constructSegments() }
    }
    
    open var buttonCustomizer: ((SmartButton) -> Void)?

    private var buttons: [SmartButton] = []
    
    /// 選択中のボタンに紐づく値
    open var selectedValue: String? {
        return buttonGroup.selectedValue
    }
    
    /// 選択されているインデックス
    open var selectedIndex: Int? {
        return buttons.firstIndex { $0.isSelected } ?? nil
    }
    
    /// 選択されているボタンのタイトル
    var selectedTitle: String? {
        return buttons.first { $0.isSelected }?.currentTitle
    }
    
    /// ボタンに紐づく値の一覧
    open var values: [String] {
        return buttonGroup.values
    }
    
    // MARK: - Initializer
    
    override open func commonInit() {
        super.commonInit()
        
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = verticalSpacing
        addSubview(verticalStackView)
        AutoLayoutUtils.fit(verticalStackView, superView: self)
        
        constructSegments()
    }
    
    // MARK: - Action
    
    @objc func actionSelect(_ button: UIButton) {
        let oldValue = buttonGroup.selectedValue
        buttonGroup.select(button: button)
        setSelectedButtonBold()
        executeCallback(oldValue: oldValue)
    }
    
    // MARK: - Getter
    
    /// Enum型を指定して、選択中の値を取得する
    open func selectedValue<T: RawRepresentable>(_ type: T.Type) -> T? where T.RawValue == String {
        return T(rawValue: (buttonGroup.selectedValue ?? ""))
    }
    
    /// Enum型を指定して、対応するボタンを取得する
    open func getButton<T: RawRepresentable>(_ value: T) -> UIButton? where T.RawValue == String {
        return getButton(value.rawValue)
    }
    
    /// 文字列を指定して、対応するボタンを取得する
    open func getButton(_ value: String) -> UIButton? {
        return buttonGroup.get(value)
    }
    
    // MARK: - Setter
    
    /// ボタン選択時の処理を設定する
    open func onSelected<T: RawRepresentable>(_ callback: @escaping (T, Int) -> Void) where T.RawValue == String {
        tapHandler = {[weak self] value in
            if let enumValue = T(rawValue: value) {
                callback(enumValue, self?.selectedIndex ?? 0)
            }
        }
    }

    /// ボタン選択時の処理を設定する
    open func onSelected(_ callback: @escaping (String, Int) -> Void) {
        tapHandler = {[weak self] value in
            callback(value, self?.selectedIndex ?? 0)
        }
    }
    
    /// ボタン選択時の処理を設定する（選択前の値が取得可能）
    func onSelectedWithOldValue<T: RawRepresentable>(_ callback: @escaping (T?, T, Int) -> Void) where T.RawValue == String {
        tapHandlerWithOldValue = {[weak self] oldValue, newValue in
            if let enumValue = T(rawValue: newValue) {
                var oldEnumValue: T? = nil
                if let oldValue = oldValue {
                    oldEnumValue = T(rawValue: oldValue)
                }
                callback(oldEnumValue, enumValue, self?.selectedIndex ?? 0)
            }
        }
    }

    /// 各ボタンに紐づくEnum値を設定する
    open func setEnumValues<T: RawRepresentable>(_ values: [T]) where T.RawValue == String {
        setValues(values.map { $0.rawValue })
    }
    
    /// 各ボタンに紐づく値を設定する
    open func setValues(_ values: [String]) {
        buttonGroup.clear()
        values.enumerated().forEach {
            buttonGroup.register(buttons[$0.offset], value: $0.element)
        }
    }
    
    /// 各紐づくEnum値と名前のセットを設定する
    open func setEnumAndNames<T: RawRepresentable>(_ values: [(type: T, name: String)]) where T.RawValue == String {
        setValueAndNames(values.map { ($0.type.rawValue, $0.name) })
    }
    
    open func setValueAndNames(_ values: [(type: String, name: String)]) {
        names = values.map { $0.name }.joined(separator: ",")
        setValues(values.map { $0.type })
        layoutIfNeeded()
    }

    /// 紐づくEnum値のリストを取得する
    open func getEnumValues<T: RawRepresentable>(_ type: T.Type) -> [T?] where T.RawValue == String {
        return buttonGroup.values.map { T(rawValue: $0) }
    }
    
    /// 指定した値に紐づくボタンの活性状態を設定する
    open func setEnabled<T: RawRepresentable>(_ value: T, enabled: Bool) where T.RawValue == String {
        setEnabled(value.rawValue, enabled: enabled)
    }
    
    /// 指定した値に紐づくボタンの活性状態を設定する
    open func setEnabled(_ value: String, enabled: Bool) {
        if let button = buttonGroup.get(value) {
            button.isEnabled = enabled
        }
    }
    
    /// 指定したインデックスのボタンの活性状態を設定する
    open func setEnabled(_ index: Int, enabled: Bool) {
        if index < buttons.count {
            buttons[index].isEnabled = enabled
        }
    }
    
    /// 指定した値に紐づくボタンを選択する
    open func select<T: RawRepresentable>(_ value: T, needCallback: Bool = false) where T.RawValue == String {
        select(string: value.rawValue, needCallback: needCallback)
    }
    
    /// 指定した値に紐づくボタンを選択する
    open func select(string: String, needCallback: Bool = false) {
        if let button = buttonGroup.get(string), button.isEnabled {
            let oldValue = buttonGroup.selectedValue
            buttonGroup.select(button: button)
            setSelectedButtonBold()
            if needCallback {
                executeCallback(oldValue: oldValue)
            }
        }
    }
    
    /// 指定したインデックスのボタンを選択する
    open func select(_ index: Int, needCallback: Bool = false) {
        let button = buttons[index]
        if button.isEnabled {
            let oldValue = buttonGroup.selectedValue
            buttonGroup.select(button: button)
            setSelectedButtonBold()
            if needCallback {
                executeCallback(oldValue: oldValue)
            }
        }
    }
    
    /// 指定した値に紐づくボタンのタイトルを設定する
    open func setTitle<T: RawRepresentable>(_ title: String?, value: T) where T.RawValue == String {
        setTitle(title, value: value.rawValue)
    }
    
    /// 指定した値に紐づくボタンのタイトルを設定する
    open func setTitle(_ title: String?, value: String) {
        if let button = buttonGroup.get(value) {
            button.setTitle(title, for: .normal)
        }
    }

    /// 指定した値に紐づくボタンの表示・非表示を切り替える
    open func setHidden<T: RawRepresentable>(_ hidden: Bool, value: T) where T.RawValue == String {
        setHidden(hidden, value: value.rawValue)
    }
    
    /// 指定した値に紐づくボタンの表示・非表示を切り替える
    open func setHidden(_ hidden: Bool, value: String) {
        if let button = buttonGroup.get(value) {
            button.isEnabled = !hidden
            // hiddenにするとStackViewのレイアウトが変わる為アルファ値で表示切り替えをしている
            button.alpha = hidden ? 0.0 : 1.0
        }
    }
    
    /// 選択状態を解除する
    open func clearSelection(needCallback: Bool = false) {
        let oldValue = buttonGroup.selectedValue
        buttonGroup.selectedValue = nil
        setSelectedButtonBold()
        if needCallback {
            executeCallback(oldValue: oldValue)
        }
    }

    // MARK: - Private
    
    /// セグメントを作る
    private func constructSegments() {
        verticalStackView.arrangedSubviews.forEach {
            verticalStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        if columnSize == undefinedSize || rowSize == undefinedSize {
            return
        }
        buttons.removeAll()
        
        for _ in 0..<rowSize {
            let stackView = addHorizontalStackView()
            for _ in 0..<columnSize {
                stackView.addArrangedSubview(createButton())
            }
        }
        if !names.isEmpty {
            updateSegmentTitles()
        }
    }
    
    /// セグメントのボタン名称を更新する
    private func updateSegmentTitles() {
        let nameList = names.components(separatedBy: columnSeparator)
        for i in 0..<buttons.count {
            let button = buttons[i]
            let isEnabled = i < nameList.count
            button.setTitle(isEnabled ? nameList[i] : "", for: .normal)
            button.isUserInteractionEnabled = isEnabled
            button.alpha = isEnabled ? 1.0 : 0.0
        }
    }
    
    /// 行のスタックビューを追加する
    private func addHorizontalStackView() -> UIStackView {
        let stackView = InnerStackView()
        stackView.onLayoutSublayers = { [weak self] in
            // 角丸のマスクのサイズを更新する必要がある為、角丸を設定し直す
            if self?.style != Style.custom.rawValue {
                self?.setCornerRadius(stackView: stackView)
            }
        }
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = horizontalSpacing
        verticalStackView.addArrangedSubview(stackView)
        return stackView
    }
    
    /// 選択中のボタンのフォントをボールドにする
    private func setSelectedButtonBold() {
        buttons.forEach {
            if $0.useGlobalFont {
                $0.isBold = $0.isSelected
            }
        }
    }
    
    /// ボタンを作成する
    private func createButton() -> SmartButton {
        let button = makeButton()
        buttons.append(button)
        
        button.setBackgroundColor(color: normalButtonBackgroundColor, for: .normal)
        button.setBackgroundColor(color: selectedButtonBackgroundColor, for: .selected)
        button.setTitleColor(normalButtonTextColor, for: .normal)
        button.setTitleColor(selectedButtonTextColor, for: .selected)
        button.setTitleColor(disabledButtonTextColor, for: .disabled)
        button.titleFont = UIFont.systemFont(ofSize: textSize)
        button.adjustsFontSizeToFitWidth = true
        button.miniumScaleFactor = 0.5
        button.addTarget(self, action: #selector(actionSelect(_:)), for: .touchUpInside)
        buttonCustomizer?(button)
        return button
    }
    
    open func customizeButton(customizer: ((SmartButton) -> Void)?) {
        buttonCustomizer = customizer
        buttons.forEach {
            customizer?($0)
        }
    }
    
    /// ボタンを作成する
    open func makeButton() -> SmartButton {
        return SmartButton()
    }
    
    /// コールバックを実行する
    private func executeCallback(oldValue: String?) {
        if let newValue = buttonGroup.selectedValue {
            tapHandler?(newValue)
            tapHandlerWithOldValue?(oldValue, newValue)
        }
    }
    
    /// 角丸を設定する
    private func setCornerRadius(stackView: UIStackView) {
        stackView.arrangedSubviews.forEach { $0.layer.mask = nil }
        let visibleButtons = stackView.arrangedSubviews.filter { $0.alpha != 0.0 }
        let firstButton = visibleButtons.first as? UIButton
        let lastButton = visibleButtons.last as? UIButton
        if styleType == .roundedSquare {
            firstButton?.setCornerRadius(corners: [.topLeft, .bottomLeft], radius: segmentCornerRadius)
            lastButton?.setCornerRadius(corners: [.topRight, .bottomRight], radius: segmentCornerRadius)
        }
    }
    
    /// セグメントボタンのスタイル
    public enum Style: String {
        /// カスタム
        case custom
        /// 標準
        case square
        /// 両端が角丸
        case roundedSquare
    }
    
    class InnerStackView: UIStackView {
        
        var onLayoutSublayers: (() -> Void)?
        
        override func layoutSublayers(of layer: CALayer) {
            super.layoutSublayers(of: layer)
            onLayoutSublayers?()
        }
    }
}
