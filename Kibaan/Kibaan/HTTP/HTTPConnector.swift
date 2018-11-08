import Foundation

public protocol HTTPConnector {
    
    var timeoutIntervalForRequest: TimeInterval { get set }
    var timeoutIntervalForResource: TimeInterval { get set }
    var isCancelled: Bool { get }
    
    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func cancel()
    
}
