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
                    continuation.resume(returning: response)
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

    /// 发送私聊消息
    /// - Parameters:
    ///   - userId: 目标用户 ID
    ///   - message: 要发送的消息内容数组
    /// - Returns: 发送消息的结果，包含消息 ID
    /// - Protocol: OneBot 11
    public func sendPrivateMsg(userId: Int, message: [NCSendMessage]) async throws -> NCSocketReturn.SendPrivateMsg {
        let sender = NCSocketSender.sendPrivateMsg(userId: userId, message: message)
        return try await sendRequest(sender)
    }

    /// 发送群聊消息
    /// - Parameters:
    ///   - groupId: 目标群组 ID
    ///   - message: 要发送的消息内容数组
    /// - Returns: 发送消息的结果，包含消息 ID
    /// - Protocol: OneBot 11
    public func sendGroupMsg(groupId: Int, message: [NCSendMessage]) async throws -> NCSocketReturn.SendGroupMsg {
        let sender = NCSocketSender.sendGroupMsg(groupId: groupId, message: message)
        return try await sendRequest(sender)
    }

    /// 发送消息（支持私聊和群聊）
    /// - Parameters:
    ///   - userId: 私聊时的目标用户 ID
    ///   - groupId: 群聊时的目标群组 ID
    ///   - message: 要发送的消息内容数组
    /// - Returns: 发送消息的结果，包含消息 ID
    /// - Protocol: OneBot 11
    public func sendMsg(userId: Int? = nil, groupId: Int? = nil, message: [NCSendMessage]) async throws -> NCSocketReturn.SendMsg {
        let sender = NCSocketSender.sendMsg(userId: userId, groupId: groupId, message: message)
        return try await sendRequest(sender)
    }

    /// 撤回消息
    /// - Parameter messageId: 要撤回的消息 ID
    /// - Protocol: OneBot 11
    public func deleteMsg(messageId: Int) async throws -> NCSocketReturn.DeleteMsg {
        let sender = NCSocketSender.deleteMsg(messageId: messageId)
        return try await sendRequest(sender)
    }

    /// 获取消息
    /// - Parameter messageId: 要获取的消息 ID
    /// - Returns: 消息的详细信息
    /// - Protocol: OneBot 11
    public func getMsg(messageId: Int) async throws -> NCSocketReturn.GetMsg {
        let sender = NCSocketSender.getMsg(messageId: messageId)
        return try await sendRequest(sender)
    }

    /// 发送好友点赞
    /// - Parameters:
    ///   - userId: 目标用户 ID
    ///   - times: 点赞次数
    /// - Protocol: OneBot 11
    public func sendLike(userId: Int, times: Int) async throws -> NCSocketReturn.SendLike {
        let sender = NCSocketSender.sendLike(userId: userId, times: times)
        return try await sendRequest(sender)
    }

    /// 获取群组信息
    /// - Parameter groupId: 群组 ID
    /// - Returns: 群组的详细信息
    /// - Protocol: OneBot 11
    public func getGroupInfo(groupId: Int) async throws -> NCSocketReturn.GetGroupInfo {
        let sender = NCSocketSender.getGroupInfo(groupId: groupId)
        return try await sendRequest(sender)
    }

    /// 获取群组列表
    /// - Parameter noCache: 是否不使用缓存
    /// - Returns: 群组列表
    /// - Protocol: OneBot 11
    public func getGroupList(noCache: Bool? = nil) async throws -> NCSocketReturn.GetGroupList {
        let sender = NCSocketSender.getGroupList(noCache: noCache)
        return try await sendRequest(sender)
    }

    /// 获取群组成员信息
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 用户 ID
    /// - Returns: 群组成员的详细信息
    /// - Protocol: OneBot 11
    public func getGroupMemberInfo(groupId: Int, userId: Int) async throws -> NCSocketReturn.GetGroupMemberInfo {
        let sender = NCSocketSender.getGroupMemberInfo(groupId: groupId, userId: userId)
        return try await sendRequest(sender)
    }

    /// 获取群组成员列表
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - noCache: 是否不使用缓存
    /// - Returns: 群组成员列表
    /// - Protocol: OneBot 11
    public func getGroupMemberList(groupId: Int, noCache: Bool? = nil) async throws -> NCSocketReturn.GetGroupMemberList {
        let sender = NCSocketSender.getGroupMemberList(groupId: groupId, noCache: noCache)
        return try await sendRequest(sender)
    }

    /// 获取群组荣誉信息
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - type: 荣誉类型
    /// - Returns: 群组荣誉信息
    /// - Protocol: OneBot 11
    public func getGroupHonorInfo(groupId: Int, type: NCSocketSendParam.GetGroupHonorInfo.HonorType? = nil) async throws -> NCSocketReturn.GetGroupHonorInfo {
        let sender = NCSocketSender.getGroupHonorInfo(groupId: groupId, type: type)
        return try await sendRequest(sender)
    }

    /// 获取 Cookies
    /// - Parameter domain: 域名
    /// - Returns: Cookies 信息
    /// - Protocol: OneBot 11
    public func getCookies(domain: String) async throws -> NCSocketReturn.GetCookies {
        let sender = NCSocketSender.getCookies(domain: domain)
        return try await sendRequest(sender)
    }

    /// 获取 CSRF Token
    /// - Returns: CSRF Token
    /// - Protocol: OneBot 11
    public func getCsrfToken() async throws -> NCSocketReturn.GetCsrfToken {
        let sender = NCSocketSender.getCsrfToken()
        return try await sendRequest(sender)
    }

    /// 获取凭证信息
    /// - Returns: 凭证信息
    /// - Protocol: OneBot 11
    public func getCredentials() async throws -> NCSocketReturn.GetCredentials {
        let sender = NCSocketSender.getCredentials()
        return try await sendRequest(sender)
    }

    /// 获取录音文件
    /// - Parameters:
    ///   - fileId: 文件 ID
    ///   - outFormat: 输出格式
    /// - Returns: 录音文件信息
    /// - Protocol: OneBot 11
    public func getRecord(fileId: String, outFormat: NCSocketSendParam.GetRecord.RecordFormat? = nil) async throws -> NCSocketReturn.GetRecord {
        let sender = NCSocketSender.getRecord(fileId: fileId, outFormat: outFormat)
        return try await sendRequest(sender)
    }

    /// 获取图片
    /// - Parameter fileId: 文件 ID
    /// - Returns: 图片信息
    /// - Protocol: OneBot 11
    public func getImage(fileId: String) async throws -> NCSocketReturn.GetImage {
        let sender = NCSocketSender.getImage(fileId: fileId)
        return try await sendRequest(sender)
    }

    /// 检查是否可以发送图片
    /// - Returns: 是否可以发送图片
    /// - Protocol: OneBot 11
    public func canSendImage() async throws -> NCSocketReturn.CanSendImage {
        let sender = NCSocketSender.canSendImage()
        return try await sendRequest(sender)
    }

    /// 检查是否可以发送语音
    /// - Returns: 是否可以发送语音
    /// - Protocol: OneBot 11
    public func canSendRecord() async throws -> NCSocketReturn.CanSendRecord {
        let sender = NCSocketSender.canSendRecord()
        return try await sendRequest(sender)
    }

    /// 获取运行状态
    /// - Returns: 运行状态信息
    /// - Protocol: OneBot 11
    public func getStatus() async throws -> NCSocketReturn.GetStatus {
        let sender = NCSocketSender.getStatus()
        return try await sendRequest(sender)
    }

    /// 获取版本信息
    /// - Returns: 版本信息
    /// - Protocol: OneBot 11
    public func getVersionInfo() async throws -> NCSocketReturn.GetVersionInfo {
        let sender = NCSocketSender.getVersionInfo()
        return try await sendRequest(sender)
    }

    // MARK: - go-cqhttp 协议

    /// 设置 QQ 资料
    /// - Parameters:
    ///   - nickname: 昵称
    ///   - personalNote: 个性签名
    ///   - sex: 性别
    /// - Returns: 设置结果
    /// - Protocol: go-cqhttp
    public func setQQProfile(nickname: String, personalNote: String? = nil, sex: Int? = nil) async throws -> NCSocketReturn.SetQQProfile {
        let sender = NCSocketSender.setQQProfile(nickname: nickname, personalNote: personalNote, sex: sex)
        return try await sendRequest(sender)
    }

    /// 获取在线客户端列表
    /// - Parameter noCache: 是否不使用缓存
    /// - Returns: 在线客户端列表
    /// - Protocol: go-cqhttp
    public func getOnlineClients(noCache: Bool? = nil) async throws -> NCSocketReturn.GetOnlineClients {
        let sender = NCSocketSender.getOnlineClients(noCache: noCache)
        return try await sendRequest(sender)
    }

    /// 标记消息已读
    /// - Parameters:
    ///   - userId: 用户 ID
    ///   - groupId: 群组 ID
    /// - Protocol: go-cqhttp
    public func markMsgAsRead(userId: Int, groupId: Int? = nil) async throws -> NCSocketReturn.MarkMsgAsRead {
        let sender = NCSocketSender.markMsgAsRead(userId: userId, groupId: groupId)
        return try await sendRequest(sender)
    }

    /// 发送群转发消息
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - message: 消息内容数组
    /// - Returns: 发送结果
    /// - Protocol: go-cqhttp
    public func sendGroupForwardMsg(groupId: Int, message: [NodeMessage]) async throws -> NCSocketReturn.SendGroupForwardMsg {
        let sender = NCSocketSender.sendGroupForwardMsg(groupId: groupId, message: message)
        return try await sendRequest(sender)
    }

    /// 创建群文件夹
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - folderName: 文件夹名
    /// - Returns: 创建结果
    /// - Protocol: go-cqhttp
    public func createGroupFileFolder(groupId: Int, folderName: String) async throws -> NCSocketReturn.CreateGroupFileFolder {
        let sender = NCSocketSender.createGroupFileFolder(groupId: groupId, folderName: folderName)
        return try await sendRequest(sender)
    }

    /// 删除群文件夹
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - folderId: 文件夹 ID
    /// - Returns: 删除结果
    /// - Protocol: go-cqhttp
    public func deleteGroupFolder(groupId: Int, folderId: String) async throws -> NCSocketReturn.DeleteGroupFolder {
        let sender = NCSocketSender.deleteGroupFolder(groupId: groupId, folderId: folderId)
        return try await sendRequest(sender)
    }

    /// 获取群文件系统信息
    /// - Parameter groupId: 群组 ID
    /// - Returns: 群文件系统信息
    /// - Protocol: go-cqhttp
    public func getGroupFileSystemInfo(groupId: Int) async throws -> NCSocketReturn.GetGroupFileSystemInfo {
        let sender = NCSocketSender.getGroupFileSystemInfo(groupId: groupId)
        return try await sendRequest(sender)
    }

    /// 获取群根目录文件列表
    /// - Parameter groupId: 群组 ID
    /// - Returns: 群根目录文件列表
    /// - Protocol: go-cqhttp
    public func getGroupRootFiles(groupId: Int) async throws -> NCSocketReturn.GetGroupRootFiles {
        let sender = NCSocketSender.getGroupRootFiles(groupId: groupId)
        return try await sendRequest(sender)
    }

    /// 获取群文件列表
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - folderId: 文件夹 ID
    ///   - fileCount: 文件数量
    /// - Returns: 群文件列表
    /// - Protocol: go-cqhttp
    public func getGroupFilesByFolder(groupId: Int, folderId: String? = nil, fileCount: Int? = nil) async throws -> NCSocketReturn.GetGroupFilesByFolder {
        let sender = NCSocketSender.getGroupFilesByFolder(groupId: groupId, folderId: folderId, fileCount: fileCount)
        return try await sendRequest(sender)
    }

    /// 获取群文件 URL
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - fileId: 文件 ID
    /// - Returns: 群文件 URL
    /// - Protocol: go-cqhttp
    public func getGroupFileUrl(groupId: Int, fileId: String) async throws -> NCSocketReturn.GetGroupFileUrl {
        let sender = NCSocketSender.getGroupFileUrl(groupId: groupId, fileId: fileId)
        return try await sendRequest(sender)
    }
    
    // MARK: - NapCat 协议

    /// 获取好友消息历史
    /// - Parameters:
    ///   - userId: 用户 ID
    ///   - messageSeq: 消息序列号
    ///   - count: 获取数量
    ///   - reverseOrder: 是否逆序获取
    /// - Returns: 好友消息历史
    /// - Protocol: NapCat
    public func getFriendMsgHistory(userId: Int, messageSeq: Int? = nil, count: Int? = nil, reverseOrder: Bool? = nil) async throws -> NCSocketReturn.GetFriendMsgHistory {
        let sender = NCSocketSender.getFriendMsgHistory(userId: userId, messageSeq: messageSeq, count: count, reverseOrder: reverseOrder)
        return try await sendRequest(sender)
    }

    /// 创建收藏
    /// - Parameters:
    ///   - rawData: 原始数据
    ///   - brief: 简介
    /// - Protocol: NapCat
    public func createCollection(rawData: String, brief: String) async throws -> NCSocketReturn.CreateCollection {
        let sender = NCSocketSender.createCollection(rawData: rawData, brief: brief)
        return try await sendRequest(sender)
    }

    /// 获取收藏列表
    /// - Parameters:
    ///   - category: 分类
    ///   - count: 获取数量
    /// - Returns: 收藏列表
    /// - Protocol: NapCat
    public func getCollectionList(category: Int, count: Int) async throws -> NCSocketReturn.GetCollectionList {
        let sender = NCSocketSender.getCollectionList(category: category, count: count)
        return try await sendRequest(sender)
    }

    /// 设置个性签名
    /// - Parameter longNick: 个性签名内容
    /// - Returns: 设置结果
    /// - Protocol: NapCat
    public func setSelfLongnick(longNick: String) async throws -> NCSocketReturn.SetSelfLongnick {
        let sender = NCSocketSender.setSelfLongnick(longNick: longNick)
        return try await sendRequest(sender)
    }

    /// 获取最近联系人
    /// - Parameter count: 获取数量
    /// - Returns: 最近联系人列表
    /// - Protocol: NapCat
    public func getRecentContact(count: Int? = nil) async throws -> NCSocketReturn.GetRecentContact {
        let sender = NCSocketSender.getRecentContact(count: count)
        return try await sendRequest(sender)
    }

    /// 标记所有消息为已读
    /// - Protocol: NapCat
    public func markAllAsRead() async throws -> NCSocketReturn.MarkAllAsRead {
        let sender = NCSocketSender.markAllAsRead()
        return try await sendRequest(sender)
    }

    /// 获取资料点赞信息
    /// - Returns: 资料点赞信息
    /// - Protocol: NapCat
    public func getProfileLike() async throws -> NCSocketReturn.GetProfileLike {
        let sender = NCSocketSender.getProfileLike()
        return try await sendRequest(sender)
    }

    /// 获取自定义表情
    /// - Parameter count: 获取数量
    /// - Returns: 自定义表情列表
    /// - Protocol: NapCat
    public func fetchCustomFace(count: Int? = nil) async throws -> NCSocketReturn.FetchCustomFace {
        let sender = NCSocketSender.fetchCustomFace(count: count)
        return try await sendRequest(sender)
    }

    /// 获取表情点赞信息
    /// - Parameters:
    ///   - emojiId: 表情 ID
    ///   - emojiType: 表情类型
    ///   - messageId: 消息 ID
    ///   - count: 获取数量
    /// - Returns: 表情点赞信息
    /// - Protocol: NapCat
    public func fetchEmojiLike(emojiId: String, emojiType: String, messageId: Int, count: Int? = nil) async throws -> NCSocketReturn.FetchEmojiLike {
        let sender = NCSocketSender.fetchEmojiLike(emojiId: emojiId, emojiType: emojiType, messageId: messageId, count: count)
        return try await sendRequest(sender)
    }

    /// 设置输入状态
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 用户 ID
    ///   - eventType: 事件类型
    /// - Returns: 设置结果
    /// - Protocol: NapCat
    public func setInputStatus(groupId: String? = nil, userId: String? = nil, eventType: String) async throws -> NCSocketReturn.SetInputStatus {
        let sender = NCSocketSender.setInputStatus(groupId: groupId, userId: userId, eventType: eventType)
        return try await sendRequest(sender)
    }

    /// 获取扩展群信息
    /// - Parameter groupId: 群组 ID
    /// - Returns: 扩展群信息
    /// - Protocol: NapCat
    public func getGroupInfoEx(groupId: Int) async throws -> NCSocketReturn.GetGroupInfoEx {
        let sender = NCSocketSender.getGroupInfoEx(groupId: groupId)
        return try await sendRequest(sender)
    }

    /// 获取群忽略添加请求状态
    /// - Parameter groupId: 群组 ID
    /// - Returns: 群忽略添加请求状态
    /// - Protocol: NapCat
    public func getGroupIgnoreAddRequest(groupId: Int) async throws -> NCSocketReturn.GetGroupIgnoreAddRequest {
        let sender = NCSocketSender.getGroupIgnoreAddRequest(groupId: groupId)
        return try await sendRequest(sender)
    }

    /// 删除群公告
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - noticeId: 公告 ID
    /// - Protocol: NapCat
    public func delGroupNotice(groupId: Int, noticeId: String) async throws -> NCSocketReturn.DelGroupNotice {
        let sender = NCSocketSender.delGroupNotice(groupId: groupId, noticeId: noticeId)
        return try await sendRequest(sender)
    }

    /// 获取用户资料点赞信息
    /// - Parameter qq: QQ 号码
    /// - Returns: 用户资料点赞信息
    /// - Protocol: NapCat
    public func fetchUserProfileLike(qq: Int) async throws -> NCSocketReturn.FetchUserProfileLike {
        let sender = NCSocketSender.fetchUserProfileLike(qq: qq)
        return try await sendRequest(sender)
    }

    /// 好友戳一戳
    /// - Parameter userId: 用户 ID
    /// - Protocol: NapCat
    public func friendPoke(userId: Int) async throws -> NCSocketReturn.FriendPoke {
        let sender = NCSocketSender.friendPoke(userId: userId)
        return try await sendRequest(sender)
    }

    /// 群组戳一戳
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 用户 ID
    /// - Protocol: NapCat
    public func groupPoke(groupId: Int, userId: Int) async throws -> NCSocketReturn.GroupPoke {
        let sender = NCSocketSender.groupPoke(groupId: groupId, userId: userId)
        return try await sendRequest(sender)
    }

    /// 获取数据包状态
    /// - Returns: 数据包状态
    /// - Protocol: NapCat
    public func ncGetPacketStatus() async throws -> NCSocketReturn.NCGetPacketStatus {
        let sender = NCSocketSender.ncGetPacketStatus()
        return try await sendRequest(sender)
    }

    /// 获取用户状态
    /// - Parameter userId: 用户 ID
    /// - Returns: 用户状态
    /// - Protocol: NapCat
    public func ncGetUserStatus(userId: Int) async throws -> NCSocketReturn.NCGetUserStatus {
        let sender = NCSocketSender.ncGetUserStatus(userId: userId)
        return try await sendRequest(sender)
    }

    /// 获取 RKey
    /// - Returns: RKey 信息
    /// - Protocol: NapCat
    public func ncGetRKey() async throws -> NCSocketReturn.NCGetRKey {
        let sender = NCSocketSender.ncGetRKey()
        return try await sendRequest(sender)
    }

    /// 获取群禁言列表
    /// - Parameter groupId: 群组 ID
    /// - Returns: 群禁言列表
    /// - Protocol: NapCat
    public func getGroupShutList(groupId: Int) async throws -> NCSocketReturn.GetGroupShutList {
        let sender = NCSocketSender.getGroupShutList(groupId: groupId)
        return try await sendRequest(sender)
    }
}
