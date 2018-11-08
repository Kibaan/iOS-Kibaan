import Foundation

open class HTTPConnectorMock: HTTPConnector {
    
    open var timeoutIntervalForRequest: TimeInterval = 30.0
    open var timeoutIntervalForResource: TimeInterval = 60.0
    open var isCancelled: Bool = false
    
    open var postData: Data?
    
    open func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        postData = request.httpBody
    }
    
    open func cancel() {}
    
    open func getPostValue(key: String, encoding: String.Encoding) -> String {
        guard let data = postData,
            let string = String(data: data, encoding: encoding) else {
            return ""
        }
        
        let keyValue = string.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .first { $0.first == key }

        return keyValue?.last?.removingPercentEncoding ?? ""
    }
}
