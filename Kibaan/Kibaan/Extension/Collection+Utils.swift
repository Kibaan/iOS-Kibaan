import Foundation

public extension Collection {
    /// 指定したindexの要素を取得する。
    /// 通常の[]による要素取得と異なり、マイナスや存在しないインデックスを指定してもクラッシュせずnilを返す。
    /// ex. list[safe: 10]
    subscript (safe index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[self.index(startIndex, offsetBy: index)]
        }
        return nil
    }
}

public protocol AnyOptional {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}
extension Optional: AnyOptional {
    public var optional: Wrapped? { return self }
}

public extension Collection where Element: AnyOptional {
    /// nilを除いたコレクションを返す
    func filterNotNull() -> [Element.Wrapped] {
        return compactMap { $0.optional }
    }
}

public extension Collection where Element: Equatable {
    
    /// 指定した要素が含まれるか判定する
    func contains(equatable: Element?) -> Bool {
        guard let obj = equatable else { return false }
        return filter { $0 == obj }.first != nil
    }
}

public extension Collection where Element: AnyObject {
    
    /// 指定した要素が含まれるか判定する
    func contains(element: Element?) -> Bool {
        guard let obj = element else { return false }
        return filter { $0 === obj }.first != nil
    }
}
