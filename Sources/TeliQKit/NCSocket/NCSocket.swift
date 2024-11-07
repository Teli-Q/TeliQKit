//
//  NCSocket.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/06.
//

import Foundation
import Starscream

/// WebSocket 响应类型
public enum NCSocketResponseType {
    /// 基础响应(带 echo)
    case base(NCSocketBaseResponse<JSON>)
    /// 事件通知
    case event(NCSocketEvent)
    /// 心跳包
    case heartbeat(NCSocketHeartbeat)
    /// 未知类型
    case unknown(String)
}

public extension NCSocketEvent {
    /// 事件类型
    enum EventType: String {
        case message
        case notice
        case request
        case meta = "meta_event"
        case unknown

        public init(rawValue: String) {
            switch rawValue {
            case "message": self = .message
            case "notice": self = .notice
            case "request": self = .request
            case "meta_event": self = .meta
            default: self = .unknown
            }
        }
    }

    /// 获取事件类型
    var type: EventType {
        return EventType(rawValue: postType)
    }
}

/// WebSocket 事件结构
public struct NCSocketEvent: Codable {
    public let postType: String
    public let time: Int
    public let selfId: Int

    enum CodingKeys: String, CodingKey {
        case postType = "post_type"
        case time
        case selfId = "self_id"
    }
}

/// WebSocket 心跳包结构
public struct NCSocketHeartbeat: Codable {
    public let status: String
    public let interval: Int
}

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
    /// 存储等待响应的回调
    private var waitingResponses: [String: (Result<Data, Error>) -> Void] = [:]
    /// 等待响应的锁
    private let waitingResponsesLock = NSLock()

    /// 添加等待响应
    private func addWaitingResponse(echo: String, callback: @escaping (Result<Data, Error>) -> Void) {
        self.waitingResponsesLock.lock()
        self.waitingResponses[echo] = callback
        self.waitingResponsesLock.unlock()
    }

    /// 移除等待响应
    private func removeWaitingResponse(echo: String) -> ((Result<Data, Error>) -> Void)? {
        self.waitingResponsesLock.lock()
        defer { waitingResponsesLock.unlock() }
        return self.waitingResponses.removeValue(forKey: echo)
    }

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
    /// 响应回调
    public var onResponse: ((NCSocketResponseType) -> Void)?

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

    /// 初始化连接器
    /// - Parameters:
    ///   - url: WS 地址
    ///   - connect: 是否立即自动连接
    public convenience init(
        url: String,
        connect: Bool = true
    ) {
        self.init(url: URL(string: url)!, connect: connect)
    }

    /// 请求处理器
    public lazy var request: NCSocketRequest = .init(socket: self)

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
            // #if DEBUG
            //     print("[*] [NCSocket:text] string: \(string)")
            // #endif
            guard let data = string.data(using: .utf8) else { return }

            let decoder = JSONDecoder()

            // 首先检查是否包含 echo 字段，这表明它是一个响应而不是事件
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let echo = json["echo"] as? String,
               let callback = removeWaitingResponse(echo: echo)
            {
                // 这是一个响应消息，应该传递给等待的回调
                #if DEBUG
                    print("[*] [NCSocket:response] echo: \(echo)")
                #endif
                callback(.success(data))
                return
            }

            // 如果没有 echo 字段，那么这可能是一个事件通知
            if let event = try? decoder.decode(NCSocketEvent.self, from: data) {
                #if DEBUG
                    print("[*] [NCSocket:event] event: \(event)")
                #endif
                self.onResponse?(.event(event))
            } else if let heartbeat = try? decoder.decode(NCSocketHeartbeat.self, from: data) {
                #if DEBUG
                    print("[*] [NCSocket:heartbeat] heartbeat: \(heartbeat)")
                #endif
                self.onResponse?(.heartbeat(heartbeat))
            } else {
                #if DEBUG
                    print("[*] [NCSocket:unknown] unknown: \(string)")
                #endif
                self.onResponse?(.unknown(string))
            }

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

    /// 发送信息结构
    private struct SendMessage<T: Encodable>: Encodable {
        let action: String
        let param: T
        let echo: String
    }

    /// - Parameters:
    /// 发送文本消息 (包含返回类型)
    /// - Parameters:
    ///   - action: 动作标识符
    ///   - param: 需要发送的参数对象，必须符合 Encodable 协议
    ///   - completion: 完成回调，返回解码后的响应数据或错误
    public func send<T: Encodable, R: Decodable>(
        action: String,
        param: T,
        echo: String,
        completion: @escaping (Result<NCSocketBaseResponse<R>, Error>) -> Void
    ) {
        guard self.isConnected else {
            completion(.failure(NCSocketError.notConnected))
            return
        }

        do {
            let message = SendMessage(action: action, param: param, echo: echo)
            let jsonData = try JSONEncoder().encode(message)

            // 添加等待响应的回调
            self.addWaitingResponse(echo: echo) { result in
                switch result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(NCSocketBaseResponse<R>.self, from: data)
                        if response.status == "ok" && response.retcode == 0 {
                            completion(.success(response))
                        } else {
                            completion(.failure(NCSocketError.apiError(
                                code: response.retcode,
                                message: response.message
                            )))
                        }
                    } catch {
                        completion(.failure(NCSocketError.decodingError(error)))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }

            self.socket.write(data: jsonData)
        } catch {
            completion(.failure(NCSocketError.encodingError(error)))
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
    /// socket.send(message: message, completion: { result in
    ///     switch result {
    ///     case .success(let returnMessage):
    ///         print(returnMessage)
    ///     case .failure(let error):
    ///         print(error)
    ///     }
    /// })
    /// ```
    public func send<T: Encodable, R: Decodable>(
        _ message: (action: String, param: T, echo: String),
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        #if DEBUG
            dump(T.self)
            dump(R.self)
        #endif

        guard self.isConnected else {
            #if DEBUG
                print("[*] [NCSocket:send] not connected")
            #endif
            completion(.failure(NCSocketError.notConnected))
            return
        }

        do {
            let sendMessage = SendMessage(action: message.action, param: message.param, echo: message.echo)
            let jsonData = try JSONEncoder().encode(sendMessage)

            // 添加等待响应的回调
            self.addWaitingResponse(echo: message.echo) { result in
                switch result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let baseResponse = try decoder.decode(NCSocketBaseResponse<R>.self, from: data)
                        if baseResponse.status == "ok" && baseResponse.retcode == 0 {
                            completion(.success(baseResponse.data))
                        } else {
                            completion(.failure(NCSocketError.apiError(
                                code: baseResponse.retcode,
                                message: baseResponse.message
                            )))
                        }
                    } catch {
                        #if DEBUG
                            print("[*] [NCSocket:send] error while decoding: \(error)")
                        #endif
                        completion(.failure(error))
                    }
                case let .failure(error):
                    #if DEBUG
                        print("[*] [NCSocket:send] error while sending: \(error)")
                    #endif
                    completion(.failure(error))
                }
            }

            self.socket.write(data: jsonData)
        } catch {
            #if DEBUG
                print("[*] [NCSocket:send] error before send: \(error)")
            #endif
            completion(.failure(error))
        }
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
