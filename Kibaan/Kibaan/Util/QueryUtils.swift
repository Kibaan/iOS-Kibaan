import Foundation

public class QueryUtils {
    
    /// Key-Valueのリストからクエリ文字列を作成する
    static public func makeQueryString(items: [KeyValue], encoder: ((String) -> (String))? = nil) -> String? {
        if 0 < items.count {
            return items.map {
                if let encoder = encoder {
                    return encoder($0.key) + "=" + encoder($0.value ?? "")
                } else {
                    return urlEncode($0.key) + "=" + urlEncode($0.value ?? "")
                }
            }.joined(separator: "&")
        }
        return nil
    }
    
    /// クエリ文字列からKey-Valueのリストを取得する
    static public func getParameter(_ query: String?) -> [KeyValue] {
        guard let query = query else { return [] }
        return query.components(separatedBy: "&").map {
            let pairs = $0.components(separatedBy: "=")
            let key = pairs[0].removingPercentEncoding ?? ""
            let value = 1 < pairs.count ? pairs[1].removingPercentEncoding : nil
            return KeyValue(key: key, value: value)
        }
    }
    
    /// 文字列をURLエンコードする
    static public func urlEncode(_ str: String) -> String {
        // NSCharacterSet.urlQueryAllowedは?や&がエンコードされないので使えない
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
    }

}
