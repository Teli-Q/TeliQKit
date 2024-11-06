//
//  NCSocket.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/06.
//

import Foundation
import Starscream

/// Socket 连接器
/// 用于快速建立与服务端建立连接与通信
/// 支持消息发送与接收
///
/// ```swift
/// let socket = NCSocket(url: URL(string: "ws://example.com/socket")!)
/// socket.connect()
/// socket.onConnected = { headers in
///     print("Connected with headers: \(headers)")
/// }
/// socket.send(text: "Hello, World!")
/// ```
public class NCSocket: WebSocketDelegate {
    
    /// Socket 连接器
    private var socket: WebSocket
    /// WS 地址
    private var wsUrl: URL
    /// 连接状态
    private var isConnected: Bool = false
    /// 重连次数
    private var reconnectCount: Int = 0
    /// 最大重连次数
    private let maxReconnectCount: Int = 5

    /// 连接回调
    public var onConnected: (([String: String]) -> Void)?
    /// 断开连接回调
    public var onDisconnected: ((String, Int) -> Void)?
    /// 文本消息回调
    public var onText: ((String) -> Void)?
    /// 二进制数据回调
    public var onBinary: ((Data) -> Void)?
    /// 错误回调
    public var onError: ((Error) -> Void)?
    /// 连接取消回调
    public var onCancelled: (() -> Void)?
    /// 对端关闭回调
    public var onPeerClosed: (() -> Void)?


    /// 初始化连接器
    /// - Parameters:
    ///   - url: WS 地址
    ///   - connect: 是否立即自动连接
    public init(
      url: URL,
      connect: Bool = true
    ) {
        self.wsUrl = url
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        self.socket = WebSocket(request: request)
        self.socket.delegate = self
        if connect {
            self.connect()
        }
    }

    public func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case let .connected(headers):
            self.isConnected = true
            self.reconnectCount = 0
            #if DEBUG
                print("[*] [NCSocket:connected] headers: \(headers)")
            #endif
            self.onConnected?(headers)

        case let .disconnected(reason, code):
            self.isConnected = false
            #if DEBUG
                print("[*] [NCSocket:disconnected] reason: \(reason), code: \(code)")
            #endif
            self.handleReconnect()
            self.onDisconnected?(reason, Int(code))

        case let .text(string):
            #if DEBUG
                print("[*] [NCSocket:text] string: \(string)")
            #endif
            self.onText?(string)

        case let .binary(data):
            #if DEBUG
                print("[*] [NCSocket:binary] data: \(data.count) bytes")
            #endif
            self.onBinary?(data)

        case let .error(error):
            self.isConnected = false
            #if DEBUG
                print("[*] [NCSocket:error] error: \(error?.localizedDescription ?? "未知错误")")
            #endif
            self.handleReconnect()
            if let error = error {
                self.onError?(error)
            }

        case .cancelled:
            self.isConnected = false
            #if DEBUG
                print("[*] [NCSocket:cancelled]")
            #endif
            self.onCancelled?()

        case .peerClosed:
            self.isConnected = false
            #if DEBUG
                print("[*] [NCSocket:peerClosed]")
            #endif
            self.handleReconnect()
            self.onPeerClosed?()

        default:
            break
        }
    }

    /// 连接到服务器
    public func connect() {
        self.socket.connect()
    }

    /// 断开连接
    public func disconnect() {
        self.socket.disconnect()
    }

    /// 发送文本消息
    public func send(text: String) {
        self.socket.write(string: text)
    }

    /// 发送文本消息 (包含返回类型)
    /// - Parameters:
    ///   - action: 动作标识符
    ///   - param: 需要发送的参数对象，必须符合 Encodable 协议
    ///   - completion: 完成回调，返回解码后的响应数据或错误
    public func send<T: Encodable, R: Decodable>(
        action: String,
        param: T,
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        guard isConnected else {
            completion(.failure(NCSocketError.notConnected))
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(param)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                completion(.failure(NCSocketError.encodingFailed))
                return
            }
            
            self.socket.write(string: jsonString)
        } catch {
            completion(.failure(error))
        }
    }

    /// 发送由 NCSocketSender 生成的消息
    /// - Parameters:
    ///   - message: NCSocketSender 生成的消息元组
    ///   - completion: 完成回调，返回解码后的响应数据或错误
    /// 
    /// 使用示例：
    /// ```swift
    /// let message = NCSocketSender.sendPrivateMsg(userId: 123456, message: [NCMessageBuilder.text("Hello, World!")])
    /// socket.send(message: message)
    /// ```
    public func send<T: Encodable, R: Decodable>(
        _ message: (action: String, param: T),
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        self.send(action: message.action, param: message.param, completion: completion)
    }

    /// 发送二进制数据
    public func send(data: Data) {
        self.socket.write(data: data)
    }

    /// 处理重连逻辑
    private func handleReconnect() {
        guard !self.isConnected, self.reconnectCount < self.maxReconnectCount else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.reconnectCount + 1)) { [weak self] in
            guard let self = self else { return }
            #if DEBUG
                print("[*] [NCSocket:reconnect] 尝试重连... 第 \(self.reconnectCount + 1) 次")
            #endif
            self.reconnectCount += 1
            self.connect()
        }
    }
}


public enum NCSocketError: Error {
    case notConnected
    case encodingFailed
}
