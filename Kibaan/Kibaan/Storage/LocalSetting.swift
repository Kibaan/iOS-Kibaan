//
//  Created by Yamamoto Keita on 2018/04/02.
//

import UIKit

/// 端末に保存可能な設定項目
open class LocalSetting {
    
    open var items: [String: String] = [:]
    
    open var fileName: String

    public init(fileName: String) {
        self.fileName = fileName
        loadItems()
    }
    
    public init() {
        // 引数なしコンストラクタではクラス名をファイル名とする
        fileName = String(describing: type(of: self))
        loadItems()
    }
    
    /// 他のインスタンスの設定をコピーする
    public init(other: LocalSetting) {
        fileName = other.fileName
        items = other.items
    }
    
    private func loadItems() {
        if let nsDictionary = NSDictionary(contentsOfFile: filePath),
            let dictionary = nsDictionary as? Dictionary<String, String> {
            items = dictionary
        }
    }
    
    /// 設定情報を保存する
    open func save() {
        // itemsをNSDictionaryにキャストしてwriteするとクラッシュする場合があるので、新しいNSDictionaryを作成する
        let objcDictionary = NSDictionary(dictionary: items)
        objcDictionary.write(toFile: filePath, atomically: true)
    }
    
    /// 設定項目を上書きする
    open func overwriteItems(other: LocalSetting) {
        items = other.items // dictionaryはstructなので参照代入ではなくコピーされる
    }
    
    // MARK: - String
    
    /// Stringの値を取得
    open func getString(_ key: String, defaultValue: String) -> String {
        if let value = getStringOrNil(key) {
            return value
        }
        return defaultValue
    }
    
    /// Stringまたはnilの値を取得
    open func getStringOrNil(_ key: String) -> String? {
        return items[key]
    }
    
    /// Stringの値を設定
    open func setString(_ key: String, value: String, willSave: Bool = true) {
        items[key] = value
        if willSave {
            save()
        }
    }

    /// Stringまたはnilの値を設定
    open func setStringOrNil(_ key: String, value: String?, willSave: Bool = true) {
        items[key] = value
        if willSave {
            save()
        }
    }

    // MARK: - String Array
    
    /// String arrayの値を取得
    open func getStringArray(_ key: String, defaultValue: [String] = []) -> [String] {
        if let array = getStringArrayOrNil(key) {
            return array
        }
        return defaultValue
    }
    
    /// String arrayまたはnilの値を取得
    open func getStringArrayOrNil(_ key: String) -> [String]? {
        if let stringData = items[key]?.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: stringData, options: []),
            let array = jsonObject as? [String] {
            return array
        }
        return nil
    }
    
    /// String arrayの値を保存
    open func setStringArray(key: String, value: [String], willSave: Bool = true) {
        guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {
            return
        }
        
        items[key] = String(data: data, encoding: .utf8)

        if willSave {
            save()
        }
    }
    
    // MARK: - Bool
    /// Boolの値を取得
    open func getBool(_ key: String, defaultValue: Bool = false) -> Bool {
        if let value = getBoolOrNil(key) {
            return value
        }
        return defaultValue
    }
    
    /// Boolまたはnilの値を取得
    open func getBoolOrNil(_ key: String) -> Bool? {
        return stringToBool(items[key])
    }
    
    /// Boolの値を設定
    open func setBool(_ key: String, value: Bool, willSave: Bool = true) {
        items[key] = boolToString(value)

        if willSave {
            save()
        }
    }
    /// Boolまたはnilの値を設定
    open func setBoolOrNil(_ key: String, value: Bool?, willSave: Bool = true) {
        items[key] = boolToString(value)
        
        if willSave {
            save()
        }
    }
    
    // MARK: - Int
    
    /// Intの値を取得
    open func getInt(_ key: String, defaultValue: Int = 0) -> Int {
        if let value = getIntOrNil(key) {
            return value
        }
        return defaultValue
    }
    /// Intまたはnilの値を取得
    open func getIntOrNil(_ key: String) -> Int? {
        if let string = items[key] {
            return Int(string)
        }
        return nil
    }
    /// Intの値を設定
    open func setInt(_ key: String, value: Int, willSave: Bool = true) {
        items[key] = String(value)

        if willSave {
            save()
        }
    }
    /// Intまたはnilの値を設定
    open func setIntOrNil(_ key: String, value: Int?, willSave: Bool = true) {
        if let int = value {
            items[key] = String(int)
        } else {
            items[key] = nil
        }
        
        if willSave {
            save()
        }
    }
    
    // MARK: - Float
    /// CGFloatの値を取得
    open func getFloat(_ key: String, defaultValue: CGFloat = 0) -> CGFloat {
        if let value = getFloatOrNil(key) {
            return value
        }
        return defaultValue
    }
    /// CGFloatまたはnilの値を取得
    open func getFloatOrNil(_ key: String) -> CGFloat? {
        if let string = items[key], let d = Double(string) {
            return CGFloat(d)
        }
        return nil
    }
    /// CGFloatの値を設定する
    open func setFloat(_ key: String, value: CGFloat, decimalLength: Int, willSave: Bool = true) {
        // 有効桁まで四捨五入
        let decimal = NSDecimalNumber(value: Double(value))
        let rounded = decimal.roundPlain(decimalLength)
        
        items[key] = String(format: "%.\(decimalLength)f", arguments: [rounded.doubleValue])

        if willSave {
            save()
        }
    }
    /// CGFloatまたはnilの値を設定
    open func setFloatOrNil(_ key: String, value: CGFloat?, decimalLength: Int, willSave: Bool = true) {
        if let float = value {
            setFloat(key, value: float, decimalLength: decimalLength, willSave: willSave)
        } else {
            items[key] = nil
        }
        if willSave {
            save()
        }
    }
    
    // MARK: - Enum
    /// Stringのenumを取得する
    open func getEnum<T: RawRepresentable>(_ key: String, type: T.Type, defaultValue: T) -> T where T.RawValue == String {
        if let value = getEnumOrNil(key, type: type) {
            return value
        }
        return defaultValue
    }
    /// Stringのenumまたはnilを取得する
    open func getEnumOrNil<T: RawRepresentable>(_ key: String, type: T.Type) -> T? where T.RawValue == String {
        if let string = items[key] {
            return T(rawValue: string)
        }
        return nil
    }
    /// Stringのenumを設定する
    open func setEnum<T: RawRepresentable>(_ key: String, value: T, willSave: Bool = true) where T.RawValue == String {
        items[key] = value.rawValue
        if willSave {
            save()
        }
    }
    /// Stringのenumまたはnilを設定する
    open func setEnumOrNil<T: RawRepresentable>(_ key: String, value: T?, willSave: Bool = true) where T.RawValue == String {
        if let value = value {
            items[key] = value.rawValue
        } else {
            items[key] = nil
        }
        if willSave {
            save()
        }
    }
    
    // MARK: - Enum Array
    /// EnumのArrayを取得する
    open func getEnumArray<T: RawRepresentable>(_ key: String, type: T.Type, defaultValue: [T] = []) -> [T] where T.RawValue == String {
        if let stringArray = getStringArrayOrNil(key) {
            return stringArray.compactMap { T(rawValue: $0) }
        }
        return  defaultValue
    }

    /// EnumのArrayを設定する
    open func setEnumArray<T: RawRepresentable>(_ key: String, value: [T], willSave: Bool = true) where T.RawValue == String {
        let rawValues = value.map { $0.rawValue }
        setStringArray(key: key, value: rawValues, willSave: willSave)
    }

    // MARK: - Enum or nil Array
    /// Enum?のArrayを取得する
    open func getEnumOrNilArray<T: RawRepresentable>(_ key: String, type: T.Type, defaultValue: [T?] = []) -> [T?] where T.RawValue == String {
        if let stringArray = getStringArrayOrNil(key) {
            return stringArray.map { T(rawValue: $0) }
        }
        return defaultValue
    }
    
    /// Enum?のArrayを設定する
    open func setEnumOrNilArray<T: RawRepresentable>(_ key: String, value: [T?], willSave: Bool = true) where T.RawValue == String {
        setStringArray(key: key, value: value.map { $0?.rawValue ?? "" }, willSave: willSave)
    }
    
    // MARK: - Codable
    /// Codableを取得する
    open func getCodable<T: Codable>(_ key: String, type: T.Type, defaultValue: T) -> T {
        if let jsonData = items[key]?.data(using: .utf8),
            let result = try? JSONDecoder().decode(T.self, from: jsonData) {
            return result
        }
        return defaultValue
    }
    
    /// Codableを設定する
    open func setCodable<T: Codable>(_ key: String, value: T, willSave: Bool = true) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let jsonData = try? encoder.encode(value) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            items[key] = jsonString
        } else {
            items[key] = nil
        }
        
        if willSave {
            save()
        }
    }

    // MARK: - Utilities

    /// bool値をStringに変換する
    private func boolToString(_ value: Bool?) -> String? {
        if let bool = value {
            return bool ? "true" : "false"
        }
        return nil
    }
    /// bool値をStringに変換する
    private func stringToBool(_ value: String?) -> Bool? {
        if let string = value {
            if string == "true" {
                return true
            } else if string == "false" {
                return false
            }
        }
        return nil
    }
    
    // MARK: - Computed property
    open var filePath: String {
        return "\(NSHomeDirectory())/Documents/\(fileName)"
    }
    
}
