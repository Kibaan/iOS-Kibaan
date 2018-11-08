import Foundation

public extension Optional where Wrapped == Int {
    /// 数値を文字列に変換して返す
    var stringValue: String {
        return self?.stringValue ?? ""
    }
}

public extension Int {
    /// 数値を文字列に変換して返す
    var stringValue: String {
         return String(self)
    }
    
    /// ランダムな数値を取得する
    static func random(min: Int, max: Int) -> Int {
        let range = max - min + 1
        assert(range < UInt32.max)
        
        let random = arc4random_uniform(UInt32(range))
        
        return min + Int(random)
    }
}
