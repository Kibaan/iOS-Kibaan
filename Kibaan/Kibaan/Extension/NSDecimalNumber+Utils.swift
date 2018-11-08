import Foundation

public extension NSDecimalNumber {
    
    /// 指定した小数桁まで切り捨てる
    func roundDown(_ scale: Int = 0) -> NSDecimalNumber {
        return rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .down, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
    }
    
    /// 指定した小数桁まで切り上げる
    func roundUp(_ scale: Int = 0) -> NSDecimalNumber {
        return rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .up, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
    }
    
    /// 指定した小数桁でまで四捨五入する
    func roundPlain(_ scale: Int = 0) -> NSDecimalNumber {
        return rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .plain, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
    }
    
    /// 指定した小数桁で四捨五入した文字列を返す
    func stringValue(decimalLength: Int) -> String {
        return String(format: "%.\(decimalLength)f", arguments: [roundPlain(decimalLength).doubleValue])
    }
    
}

// MARK: - Comparable

extension NSDecimalNumber: Comparable {
    
    public static func < (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
    
    public static func == (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) == .orderedSame
    }
}
