import Foundation

/// 16進数の表示フォーマット。
/// 大文字(FFFF)または小文字(ffff)
public enum HexCase {
    case upper
    case lower
}

public extension Data {

    /// 16進数文字列（大文字）
    var hexString: String {
        return hexArray(charCase: .upper).joined(separator: " ")
    }

    /// 1バイトずつ16進数文字列に変換した配列を返す
    func hexArray(charCase: HexCase = .lower) -> [String] {
        let format = (charCase == .lower ) ? "%02hhx" : "%02hhX"
        return map { String(format: format, $0) }
    }

    /// 指定したファイルからデータを読み込む
    init?(fileName: String) {
        guard let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName) else {
            return nil
        }
        try? self.init(contentsOf: fileURL)
    }
    
    /// 指定したファイルにデータを書き込む
    func writeTo(fileName: String) {
        guard let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(fileName) else {
            return
        }
        
        do {
            try write(to: fileURL, options: .atomic)
        } catch {
            print(error)
        }
    }
}
