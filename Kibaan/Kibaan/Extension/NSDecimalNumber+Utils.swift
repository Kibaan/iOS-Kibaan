import UIKit

public extension NSDecimalNumber {
    
    /// 指定した小数桁まで切り下げる
    /// マイナスの場合はマイナス方向に切り下げ（scale0の場合、-0.1 → -1.0）
    func roundDown(_ scale: Int = 0) -> NSDecimalNumber {
        return rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .down, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
    }
    
    /// 指定した小数桁まで切り上げる
    /// マイナスの場合はプラス方向に切り上げ（scale0の場合、-0.1 → 0.0）
    func roundUp(_ scale: Int = 0) -> NSDecimalNumber {
        return rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .up, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
    }

    /// 指定した小数桁まで切り捨てる
    /// 絶対値が小さくなる方向に切り捨て（scale0の場合、-0.1 → 0.0）
    func roundAbsDown(_ scale: Int = 0) -> NSDecimalNumber {
        let roundingMode: NSDecimalNumber.RoundingMode = (0 <= self) ? .down : .up
        return rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: roundingMode, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
    }

    /// 指定した小数桁まで切り上げる
    /// 絶対値が大きくなる方向に切り上げ（scale0の場合、-0.1 → -1.0）
    func roundAbsUp(_ scale: Int = 0) -> NSDecimalNumber {
        let roundingMode: NSDecimalNumber.RoundingMode = (0 <= self) ? .up : .down
        return rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: roundingMode, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
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
    
    /// 最初の引数の値が2番目の引数の値より小さいかどうかを示すブール値を返す.
    public static func < (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
    
    /// 最初の引数の値が2番目の引数と一致しているかどうかを示すブール値を返す.
    public static func == (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) == .orderedSame
    }
}
