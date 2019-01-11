import Foundation

public extension Bool {
    
    /// Bool値を逆転して返す
    func toggled() -> Bool {
        return !self
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
