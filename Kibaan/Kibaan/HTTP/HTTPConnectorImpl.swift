import Foundation

open class HTTPConnectorImpl: HTTPConnector {
    
    open var urlSessionTask: URLSessionTask?
    open var timeoutIntervalForRequest: TimeInterval = 30.0
    open var timeoutIntervalForResource: TimeInterval = 60.0
    open var isCancelled: Bool = false
    
    public init() {}
    
    open func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        isCancelled = false
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        config.timeoutIntervalForRequest = timeoutIntervalForRequest
        config.timeoutIntervalForResource = timeoutIntervalForResource
        let session = URLSession(configuration: config)
        urlSessionTask = session.dataTask(with: request, completionHandler: { [weak self] (data, resp, err) in
            completionHandler(data, resp, err)
            self?.urlSessionTask = nil
        })
        urlSessionTask?.resume()
    }
    
    open func cancel() {
        urlSessionTask?.cancel()
        urlSessionTask = nil
        isCancelled = true
    }
}
