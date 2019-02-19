import UIKit

public protocol SmartFontProtocol {
    /// 端末のサイズに合わせてフォントサイズを自動で調整するか（4.7inch端末を基準とする）
    var adjustsFontSizeForDevice: Bool { get set }
    /// SmartContextに設定した共通フォントを使用するか
    var useGlobalFont: Bool { get set }
    /// 指定されたフォントの文字サイズとフォントを変換して返す
    func convertFont(_ font: UIFont?) -> UIFont?
}

extension SmartFontProtocol {
    public func convertFont(_ font: UIFont?) -> UIFont? {
        guard let font = font else { return nil }
        let context = SmartContext.shared
        let size = font.pointSize * (adjustsFontSizeForDevice ? context.screenScale : 1)
        if context.isGlobalFontEnabled && useGlobalFont,
            let font = context.getFont(size: size, type: font.isBold ? .bold : .regular) {
            return font
        } else {
            return font.withSize(size)
        }
    }
}

/// アプリケーション全体で共有するコンテキスト情報
/// 共通のフォント情報を管理する
open class SmartContext {
    
    // MARK: - Constants
    
    public enum FontType {
        case regular
        case bold
    }
    
    // 基準となる横幅（iPhone6,7,8サイズ）
    private let baseWidth: CGFloat = 375.0
    
    // MARK: - Variables
    
    static public var shared = SmartContext()
    
    public var isGlobalFontEnabled = false
    
    private var descriptorMap: [FontType: UIFontDescriptor] = [:]
    lazy open var screenScale: CGFloat = {
        return UIScreen.main.bounds.shortLength / baseWidth
    }()
    open var defaultRegularFontName = "HelveticaNeue"
    open var defaultBoldFontName = "HelveticaNeue-Medium"
    
    // MARK: - Methods
    
    /// FontTypeに対応するフォント名とフェイスを設定する
    /// フォント名とフェイスは複数指定可能
    open func setFonts(_ fontAttributesList: [[UIFontDescriptor.AttributeName: Any]], type: FontType = .regular) {
        guard let fontAttributes = fontAttributesList.first else {
            return
        }
        var fontDescriptor = UIFontDescriptor(fontAttributes: fontAttributes)
        
        fontAttributesList.enumerated().filter { 0 < $0.offset }.forEach {
            let descriptor = UIFontDescriptor(fontAttributes: $0.element)
            fontDescriptor = fontDescriptor.addingAttributes([.cascadeList: [descriptor]])
        }
        
        descriptorMap[type] = fontDescriptor
        isGlobalFontEnabled = true
    }
    
    /// サイズとフォントタイプを指定して、フォントを取得する
    open func getFont(size: CGFloat, type: FontType) -> UIFont? {
        if let fontDescriptor = descriptorMap[type] {
            return UIFont(descriptor: fontDescriptor, size: size)
        }
        return defaultFont(size: size, type: type)
    }
    
    /// デフォルトのフォントを取得する
    private func defaultFont(size: CGFloat, type: FontType) -> UIFont? {
        switch type {
        case .regular:
            return UIFont(name: defaultRegularFontName, size: size)
        case .bold:
            return UIFont(name: defaultBoldFontName, size: size)
        }
    }
}
