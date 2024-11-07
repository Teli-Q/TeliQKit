//
//  NCSocketError.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/06.
//

import Foundation

public enum NCSocketError: Error {
    case notConnected
    case timeout
    case apiError(code: Int, message: String)
    case encodingError(Error)
    case decodingError(Error)
    case invalidResponse(String)
    case unknownError(String)
}

extension NCSocketError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notConnected:
            return "WebSocket 未连接"
        case .timeout:
            return "请求超时"
        case .apiError(let code, let message):
            return "API错误(\(code)): \(message)"
        case .encodingError(let error):
            return "编码错误: \(error.localizedDescription)"
        case .decodingError(let error):
            return "解码错误: \(error.localizedDescription)"
        case .invalidResponse(let text):
            return "无效的响应: \(text)"
        case .unknownError(let text):
            return "未知错误: \(text)"
        }
    }
}