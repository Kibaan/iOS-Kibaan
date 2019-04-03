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
            return "リクエストするURLが不正です。"
        case .network:
            return "通信エラーが発生しました。 通信環境が不安定か、接続先が誤っている可能性があります。"
        case .statusCode:
            return "HTTPステータスコードが不正です。"
        case .parse:
            return "レスポンスデータのパースに失敗しました。"
        case .invalidResponse:
            return "レスポンスデータのバリデーションエラーです。"
        }
    }
}
