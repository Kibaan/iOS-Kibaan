import Foundation

public extension Date {
    
    /// フォーマットを指定してDateオブジェクトを作成する
    static func create(string: String?, format: String) -> Date? {
        guard let string = string else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "US")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    /// フォーマットを指定してDateを文字列にする
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "US")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// 年を加減したDateオブジェクトを作成する
    func yearAdded(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: value, to: self) ?? self
    }

    /// 月を加減したDateオブジェクトを作成する
    func monthAdded(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: value, to: self) ?? self
    }

    /// 日を加減したDateオブジェクトを作成する
    func dayAdded(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: value, to: self) ?? self
    }
    
    /// 秒を加減したDateオブジェクトを作成する
    func secondAdded(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .second, value: value, to: self) ?? self
    }
    
    /// 指定した日付時刻から何ミリ秒後かを取得する
    func countMilliSeconds(from: Date) -> Int {
        let diff = timeIntervalSince(from)
        return Int(diff * 1000)
    }
    
    /// 指定した日付時刻から何秒後かを取得する
    func countSeconds(from: Date) -> Int {
        let diff = timeIntervalSince(from)
        return Int(diff)
    }
}
