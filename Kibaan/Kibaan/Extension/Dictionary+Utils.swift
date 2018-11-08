import Foundation

public extension Dictionary {
    /// キーを指定して要素を取得する。
    /// キーはnilを許容し、nilをキーにした場合はnilを返す
    subscript (key: Key?) -> Value? {
        if let key = key {
            return self[key]
        }
        return nil
    }
}
