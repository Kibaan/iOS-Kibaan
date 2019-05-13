import CommonCrypto
import UIKit

public extension String {
    
    // MARK: - Subscript
    
    subscript(nsRange: NSRange) -> String? {
        if let range = Range(nsRange, in: self) {
            return String(self[range])
        }
        return nil
    }
    
    /// 0...3
    subscript(range: CountableClosedRange<Int>) -> String? {
        if self.count <= range.upperBound {
            return nil
        }
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound + 1)
        return String(self[start..<end])
    }
    
    /// 0..<3
    subscript(range: CountableRange<Int>) -> String? {
        if self.count < range.upperBound {
            return nil
        }
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start..<end])
    }
    
    // MARK: - Other
    
    /// 3...
    func substring(from: Int) -> String? {
        if self.count < from || from < 0 {
            return nil
        }
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: self.count)
        return String(self[start..<end])
    }
    
    /// ...3
    func substring(to: Int) -> String? {
        if self.count < to || to < 0 {
            return nil
        }
        let start = index(startIndex, offsetBy: 0)
        let end = index(startIndex, offsetBy: to)
        return String(self[start..<end])
    }
    
    /// fromで指定されたindexからlength分の文字列を切り出す
    func substring(from: Int, length: Int) -> String? {
        if self.count < from || self.count < from + length || from < 0 || length < 0 {
            return nil
        }
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: from + length)
        return String(self[start..<end])
    }
    
    /// スネークケースに変換する
    func toSnakeCase() -> String {
        var canGoNextBlock = false
        return map {
            let separator = (canGoNextBlock && $0.isUpperCase()) ? "_" : ""
            canGoNextBlock = $0.isLowerCase()
            return separator + $0.toLowerCase()
        }.joined(separator: "")
    }
    
    /// 空でなければtrue
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// 対象の文字列を削除する
    func remove(_ item: String) -> String {
        return replacingOccurrences(of: item, with: "")
    }
    
    /// 複数の対象の文字列を削除する
    func removeAll(items: [String]) -> String {
        var value = self
        items.forEach { value = value.remove($0) }
        return value
    }
    
    /// 指定した文字列を先頭に付けて返す
    func withPrefix(_ prefix: String?) -> String {
        guard let prefix = prefix else { return self }
        return prefix + self
    }
    
    /// 指定した文字列を先頭から削除した文字列を返す。
    /// 指定した文字列が先頭にない場合は元の文字列を返す。
    func removePrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
    
    /// 指定した文字列を末尾に付けて返す
    func withSuffix(_ suffix: String?) -> String {
        guard let suffix = suffix else { return self }
        return self + suffix
    }

    /// 指定した文字列を末尾から削除する。
    /// 指定した文字列が末尾にない場合は元の文字列を返す。
    func removeSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
    
    /// 空文字、改行をトリムする
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 文字列をDoubleに変換する。数値でない場合は0になる
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    /// 文字列をCGFloatに変換する。数値でない場合は0になる
    var floatValue: CGFloat {
        return CGFloat((self as NSString).doubleValue)
    }
    
    /// 文字列をIntに変換する。数値でない場合は0になる
    var integerValue: Int {
        return (self as NSString).integerValue
    }
    
    /// 指定した文字数ごとに区切った配列を返す
    func split(length: Int) -> [String] {
        return splitFromLeft(length: length)
    }
    
    /// 指定された文字で分割された文字列からの部分文字列を含む配列を空文字を除去した上で返す
    func splitWithoutEmpty(separator: Character) -> [String] {
        return split(separator: separator).map { String($0) }
    }
    
    /// 文字列の左側から指定した文字数ごとに区切った配列を返す
    func splitFromLeft(length: Int) -> [String] {
        guard !isEmpty else { return [""] }
        var array: [String] = []
        var i = 0
        while i < self.count {
            if let str = substring(from: i, length: length) {
                array.append(str)
            } else if let str = substring(from: i) {
                array.append(str)
            }
            i += length
        }
        return array
    }
    
    /// 文字列の右側から指定した文字数ごとに区切った配列を返す
    func splitFromRight(length: Int) -> [String] {
        guard !isEmpty else { return [""] }
        var array: [String] = []
        var i = 0
        while i < self.count {
            let from = self.count - (i + length)
            if let str = substring(from: from, length: length) {
                array.append(str)
            } else if let str = substring(to: from + length) {
                array.append(str)
            }
            i += length
        }
        return array.reversed()
    }
    
    /// 引数のいずれかの文字列で始まる場合はtrue
    func hasAnyPrefix(_ prefixes: [String]) -> Bool {
        return prefixes.contains { self.hasPrefix($0) }
    }
    
    /// 引数のいずれかの文字列から始まる場合は、該当する文字列を返す
    func anyPrefix(in prefixes: [String]) -> String? {
        return prefixes.first {
            self.hasPrefix($0)
        }
    }
    
    /// 数値を表す文字列か判定する
    var isNumber: Bool {
        return Double(self) != nil
    }
    
    /// 特定の文字に囲まれた文字列を取得する
    func enclosed(_ left: String, _ right: String) -> String? {
        
        if let startIndex = range(of: left)?.upperBound {
            var endIndex: String.Index = self.endIndex
            if let lastRange = range(of: right, options: .backwards) {
                endIndex = lastRange.lowerBound
            }
            if endIndex < startIndex {
                return nil
            }
            return String(self[startIndex..<endIndex])
        }
        
        return nil
    }
    
    /// 数字を3桁カンマ区切りにした文字列を返す
    /// 連続した数字のみカンマ区切りにし、数字以外の文字は無視する
    /// ex. "AAA(1234)BBB(5678)" → "AAA(1,234)BBB(5,678)"
    var numberFormat: String {
        var result = ""
        let numbers = components(separatedBy: ".")
        let pattern = "(\\d)(?=(\\d{3})+(\\D|$))"
        let replacedNumber = numbers[0].replacingOccurrences(of: pattern, with: "$1,", options: .regularExpression, range: nil)
        result.append(replacedNumber)
        result.append(numbers.count > 1 ? ".\(numbers[1])" : "")
        return result
    }
    
    /// 数字を+-符号付き3桁カンマ区切りにした文字列を返す
    /// ex. "+123456.789" -> "+123,456.789"
    /// ex. "-123456.789" -> "-123,456.789"
    /// ex. "-0.00" -> "0.00"
    var signedNumberFormat: String {
        let result = removePrefix("+").removePrefix("-")
        let doubleValue = self.doubleValue
        var sign = ""
        if 0 < doubleValue {
            sign = "+"
        } else if doubleValue < 0 {
            sign = "-"
        }
        return sign + result.numberFormat
    }
    
    /// 指定した桁まで文字列の右側を特定の文字で埋める
    /// 指定桁を超えている場合は何もしない
    func rightPadded(size: Int, spacer: String = " ") -> String {
        var result = self
        let add = size - count
        if 0 < add {
            (0..<add).forEach {_ in
                result += spacer
            }
        }
        return result
    }
    
    /// 指定した桁まで文字列の左側を特定の文字で埋める
    /// 指定桁を超えている場合は何もしない
    func leftPadded(size: Int, spacer: String = " ") -> String {
        var result = self
        let add = size - count
        if 0 < add {
            (0..<add).forEach {_ in
                result = spacer + result
            }
        }
        return result
    }
    
    /// 文字列リテラルに埋め込める形にエスケープする
    var literalEscaped: String {
        let conversion = [
            "\r": "",
            "\n": "\\n",
            "\"": "\\\"",
            "\'": "\\'",
            "\t": "\\t",
        ]
        
        var result = String(self)
        conversion.forEach {key, value in
            result = result.replacingOccurrences(of: key, with: value)
        }
        return result
    }
    
    /// ローカライズされた文字列を取得する
    var localizedString: String {
        return NSLocalizedString(self, comment: self)
    }
    
    /// URLエンコードされた文字列を取得する
    var urlEncoded: String {
        // NSCharacterSet.urlQueryAllowedは?や&がエンコードされないので使えない
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
    }
    
    /// URLデコードされた文字列を取得する
    var urlDecoded: String {
        return removingPercentEncoding ?? ""
    }
    
    /// NSDecimalNumberを取得する
    var decimalNumber: NSDecimalNumber? {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber == NSDecimalNumber.notANumber ? nil : decimalNumber
    }
    
    /// SHA-256形式のハッシュ値を返す
    func sha256() -> String {
        let cstr = self.cString(using: String.Encoding.utf8)
        let data = NSData(bytes: cstr, length: count)
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        CC_SHA256(data.bytes, CC_LONG(data.length), &digest)
        
        let output = NSMutableString(capacity: 64)
        (0..<32).forEach { i in
            output.appendFormat("%02x", digest[i])
        }
        return output as String
    }
    
    func toHiragana() -> String {
        return map { String($0.toHiragana()) }.joined()
    }
    
    func toKatakana() -> String {
        return map { String($0.toKatakana()) }.joined()
    }
}

public extension Optional where Wrapped == String {
    
    /// nilか空の場合trueを返す
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    /// nilか空でない場合trueを返す
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// アンラップした文字列を返す
    var unwrapped: String {
        if let value = self {
            return value
        }
        return ""
    }
    
    /// 空を置き換えた値を返す
    func emptyConverted(_ emptyMark: String) -> String {
        if let value = self, value.isNotEmpty {
            return value
        }
        return emptyMark
    }
}
