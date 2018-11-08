//
//  HTTPTask.swift
//  iOSTemplate
//
//  Created by Yamamoto Keita on 2018/07/10.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import UIKit

open class HTTPTask: Task {
    /// 共通のUser-Agent
    public static var defaultUserAgent: String?

    /// 共通のHTTPConnector
    public static var createHttpConnector: () -> HTTPConnector = {
        return HTTPConnectorImpl()
    }

    /// 通信インジケーター
    open var indicator: UIView?
    /// クエリパラメーター
    private var queryItems: [KeyValue] = []
    /// データ転送のタイムアウト時間
    private var timeoutIntervalForRequest: TimeInterval = 30
    /// 通信完了までのタイムアウト時間
    private var timeoutIntervalForResource: TimeInterval = 60
    /// 通信オブジェクト
    private var httpConnector: HTTPConnector = HTTPTask.createHttpConnector()
    
    /// リクエスト内容をログ出力するか
    open var isRequestLogEnabled: Bool { return true }
    /// レスポンス内容をログ出力するか
    open var isResponseLogEnabled: Bool { return true }
    
    /// 通信を開始する
    override open func start() {
        var urlStr = requestURL
        
        if isRequestLogEnabled {
            print("[\(httpMethod)] \(urlStr)")
        }
        
        prepareRequest()
        
        // クエリを作成
        var httpBody: Data?
        if httpMethod == "POST" {
            httpBody = makePostData()
        } else if let query = makeQueryString() {
            urlStr += "?" + query
        }
        
        guard let url = URL(string: urlStr) else {
            handleConnectionError(.invalidURL)
            return
        }
        
        // リクエスト作成
        let request = NSMutableURLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        
        // ヘッダー付与
        let headers = self.headers
        if let userAgent = HTTPTask.defaultUserAgent, !headers.keys.map({ $0.lowercased() }).contains("user-agent") {
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 通信する
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        httpConnector.timeoutIntervalForRequest = timeoutIntervalForRequest
        httpConnector.timeoutIntervalForResource = timeoutIntervalForResource
        httpConnector.execute(request: request as URLRequest, completionHandler: {  [weak self] (data, resp, err) in
            DispatchQueue.main.async(execute: {
                self?.complete(data: data, response: resp, error: err)
            })
        })
        
        ConnectionHolder.add(self)
        updateIndicator(referenceCount: 1)
    }
    
    /// 通信完了時の処理
    private func complete(data: Data?, response: URLResponse?, error: Error?) {
        
        defer {
            ConnectionHolder.remove(self)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            updateIndicator(referenceCount: -1)
            finishHandler?()
            end()
        }
        
        // キャンセル済みの場合
        if httpConnector.isCancelled {
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            handleConnectionError(.network, error: error)
            return
        }
        
        // 通信エラーをチェック
        if error != nil {
            handleConnectionError(.network, error: error, response: response)
            return
        }
        
        guard let data = data else {
            handleConnectionError(.network, error: error, response: response)
            return
        }

        // ステータスコードをチェック
        if !checkStatusCode(response.statusCode) {
            handleConnectionError(.statusCode, error: error, response: response, data: data)
            return
        }

        handleResponseData(data, response: response)
    }
    
    /// レスポンスデータを処理する
    open func handleResponseData(_ data: Data, response: HTTPURLResponse) {
    }
    
    /// 通信エラーを処理する
    open func handleConnectionError(_ type: HTTPTaskError, error: Error? = nil, response: HTTPURLResponse? = nil, data: Data? = nil) {
        // Override
        let message = error?.localizedDescription ?? ""
        print("[ConnectionError] Type= \(type.description), NativeMessage=\(message)")
    }
    
    /// 通信をキャンセルする
    override open func cancel() {
        super.cancel()
        httpConnector.cancel()
    }
    
    // MARK: - computed property
    /// 通信先URL
    open var requestURL: String {
        return baseURL + path
    }
    
    /// 基本通信先URL
    open var baseURL: String {
        // override by subclass
        return ""
    }
    
    /// 通信先URLパス
    open var path: String {
        return ""
    }
    
    /// リクエストHTTPメソッド
    open var httpMethod: String {
        return "GET"
    }
    
    /// リクエストヘッダー
    open var headers: [String: String] {
        return [:]
    }
    
    /// リクエストエンコーディング
    open var requestEncoding: String.Encoding {
        return .utf8
    }
    /// リクエストを作成する
    open func prepareRequest() {
        // Override
    }
    
    /// ステータスコードが有効か判定する
    open func checkStatusCode(_ code: Int) -> Bool {
        return code == 200
    }
    
    /// 通信インジケーターを更新する。referenceCountは通信開始時に+1、通信完了時に-1を指定する
    open func updateIndicator(referenceCount: Int) {
        if let view = indicator {
            view.tag += referenceCount
            view.isHidden = (view.tag <= 0)
        }
    }
    
    /// クエリパラメーターを追加する
    open func addQuery(key: String, value: String?) {
        let item = KeyValue(key: key, value: value)
        queryItems.append(item)
    }
    
    open func makePostData() -> Data? {
        guard let query = makeQueryString() else { return nil }
        return query.data(using: requestEncoding)
    }
    
    open func makeQueryString() -> String? {
        guard let query = QueryUtils.makeQueryString(items: queryItems, encoder: parameterEncoder) else { return nil }
        if isRequestLogEnabled {
            print("      > \(query)")
        }
        return query
    }
    
    open var parameterEncoder: ((String) -> (String))? { return nil }
    
    // エラー処理状態
    public enum ErrorHandlingStatus {
        case finish
        case handleError
    }
}
