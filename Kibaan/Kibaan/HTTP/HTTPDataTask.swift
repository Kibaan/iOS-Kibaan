//
//  HTTPDataTask.swift
//  iOSTemplate
//
//  Created by Yamamoto Keita on 2018/07/10.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import UIKit

open class HTTPDataTask<DataType>: HTTPTask {
    
    public typealias ErrorHandler = (DataType?, HTTPErrorInfo) -> ErrorHandlingStatus
    
    open var successHandler: ((DataType) -> Void)?
    open var errorHandler: ErrorHandler?

    /// 完了処理を指定して処理を開始する
    @discardableResult
    open func execute(_ onSuccess: ((DataType) -> Void)? = nil) -> HTTPDataTask {
        successHandler = onSuccess
        start()
        return self
    }
    
    // エラー処理をセットする
    @discardableResult
    open func onError(_ action: ErrorHandler? = nil) -> HTTPDataTask {
        errorHandler = action
        return self
    }
    
    override open func handleResponseData(_ data: Data, response: HTTPURLResponse) {
        super.handleResponseData(data, response: response)
        
        // データをパース
        let result: DataType
        do {
            result = try parseResponse(data, response: response)
        } catch {
            DispatchQueue.main.async(execute: {
                self.handleError(.parse, result: nil, response: response, data: data)
            })
            return
        }

        if isValidResponse(result) {
            DispatchQueue.main.async(execute: {
                self.handleValidResponse(result: result)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.handleError(.invalidResponse, result: result, response: response, data: data)
            })
        }
    }
    
    func handleValidResponse(result: DataType) {
        preProcessOnComplete(result)
        successHandler?(result)
        postProcessOnComplete(result)
        complete()
        next()
    }
    
    override open func handleConnectionError(_ type: HTTPTaskError, error: Error? = nil, response: HTTPURLResponse?, data: Data?) {
        super.handleConnectionError(type, error: error, response: response, data: data)
        DispatchQueue.main.async(execute: {
            self.handleError(type, result: nil, response: response, data: data)
            self.next()
        })
    }

    open func handleError(_ type: HTTPTaskError, result: DataType?, error: Error? = nil, response: HTTPURLResponse?, data: Data?) {
        let errorInfo = HTTPErrorInfo(error: error, response: response, data: data)
        
        if errorHandler == nil || errorHandler?(result, errorInfo) == .handleError {
            errorProcess(type, result: result, errorInfo: errorInfo)
        }
        
        self.error()
    }
    
    open func errorProcess(_ type: HTTPTaskError, result: DataType?, errorInfo: HTTPErrorInfo) {
        // Override
    }

    open func parseResponse(_ data: Data, response: HTTPURLResponse) throws -> DataType {
        throw HTTPTaskError.parse
    }
    
    // レスポンス内容が正常か判定する
    open func isValidResponse(_ response: DataType) -> Bool {
        // Override
        return true
    }
    
    // 共通前処理
    open func preProcessOnComplete(_ result: DataType) {
        // Override
    }

    // 共通後処理
    open func postProcessOnComplete(_ result: DataType) {
        // Override
    }

}
