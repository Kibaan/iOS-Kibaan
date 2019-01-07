import UIKit

public class URLRequestBuilder {
    
    // MARK: - Enum
    
    public enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    // MARK: - Variables
    
    /// 接続先URL
    public var requestUrl: String = ""
    /// キャッシュポリシー
    public var cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringCacheData
    /// タイムアウト時間
    public var timeoutInterval: TimeInterval = 60.0
    /// クエリパラメータ
    public var queryItems: [KeyValue] = []
    
    // MARK: - Other
    
    /// 接続先URLを設定する
    public func url(_ url: String) -> URLRequestBuilder {
        requestUrl = url
        return self
    }
    
    /// キャッシュポリシーを設定する
    public func cachePolicy(_ policy: NSURLRequest.CachePolicy) -> URLRequestBuilder {
        cachePolicy = policy
        return self
    }
    
    /// タイムアウト時間を設定する
    public func timeOutInterval(_ interval: TimeInterval) -> URLRequestBuilder {
        timeoutInterval = interval
        return self
    }
    
    /// クエリパラメーターを追加する
    public func queryItem(_ key: String, value: String?) -> URLRequestBuilder {
        let item = KeyValue(key: key, value: value)
        queryItems.append(item)
        return self
    }
    
    /// 設定された内容でURLRequestを生成して返す
    public func build(method: HttpMethod = .get) -> URLRequest? {
        var httpBody: Data?
        var urlStr = requestUrl
        let query = URLQuery(keyValues: queryItems).stringValue
        if method == .post {
            httpBody = query.data(using: .utf8)
        } else {
            urlStr += query
        }
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
            request.httpMethod = method.rawValue
            request.httpBody = httpBody
            return request
        }
        return nil
    }
}
