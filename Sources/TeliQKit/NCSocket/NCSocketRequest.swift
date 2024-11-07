//
//  NCSocketRequest.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/06.
//

import Foundation

/// 空响应结构体，用于替代 Void 类型的响应
public struct EmptyResponse: Codable {}

/// Socket 请求处理器
/// 用于快速发送请求并自动处理返回类型
///
/// ```swift
/// let request = NCSocketRequest(socket: socket)
/// let status = try await request.getStatus()
/// Task {
///     let status = try await request.getStatus()
///     print(status)
/// }
/// ```
public class NCSocketRequest {
    private let socket: NCSocket

    public init(socket: NCSocket) {
        self.socket = socket
    }

    private func sendRequest<T: Decodable, P: Encodable>(_ sender: (action: String, param: P, echo: String)) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false

            socket.send(sender) { (result: Result<T, Error>) in
                guard !hasResumed else { return }
                hasResumed = true

                switch result {
                case .success(let response):
                    continuation.resume(returning: (response))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }

            Task {
                try? await Task.sleep(nanoseconds: 5_000_000_000) // 5秒超时
                guard !hasResumed else { return }
                hasResumed = true
                continuation.resume(throwing: NCSocketError.timeout)
            }
        }
    }

    // MARK: - OneBot 11 协议

    /// 获取运行状态
    /// - Returns: 运行状态
    public func getStatus() async throws -> NCSocketReturn.GetStatus {
        let sender = NCSocketSender.getStatus()
        return try await sendRequest(sender)
    }
}
