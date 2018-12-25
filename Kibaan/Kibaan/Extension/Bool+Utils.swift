import Foundation

public extension Bool {
    /// ランダムなBool値を取得する
    static func randomValue() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    var stringValue: String {
        return self ? "true" : "false"
    }
}

public extension Optional where Wrapped == Bool {
    var isTrue: Bool {
        return self == true
    }
}
