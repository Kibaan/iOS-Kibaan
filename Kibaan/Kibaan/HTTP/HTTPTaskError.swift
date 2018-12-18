//
//  HTTPTaskError.swift
//  iOSTemplate
//
//  Created by Yamamoto Keita on 2018/07/09.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Foundation

/// HTTP通信のエラー種別
public enum HTTPTaskError: Error {
    // URL不正
    case invalidURL
    // オフライン、タイムアウトなどの通信エラー
    case network
    // HTTPステータスコードが既定ではないエラー
    case statusCode
    // レスポンスのパースに失敗
    case parse
    // レスポンスは取得できたが内容がエラー
    case invalidResponse
    
    public var description: String {
        switch self {
        case .invalidURL:
            return "URLが不正です"
        case .network:
            return "オフライン、タイムアウトなどの通信エラー"
        case .statusCode:
            return "HTTPステータスコードが既定ではないエラー"
        case .parse:
            return "レスポンスデータのパースに失敗"
        case .invalidResponse:
            return "レスポンスデータの内容がエラー"
        }
    }
}
