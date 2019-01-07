import Foundation

public extension Bool {
    /// ランダムなBool値を取得する
    static func randomValue() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    /// Bool値を文字列に変換して返す
    var stringValue: String {
        return self ? "true" : "false"
    }
}

public extension Optional where Wrapped == Bool {
    /// Bool値がTrueかどうかを返す
    var isTrue: Bool {
        return self == true
    }
}
