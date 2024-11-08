//
//  NCSocketSender.swift
//  TeliQKit
//
//  Created by Wibus on 2024/11/5.
//

import Foundation

/// WebSocket 发送器，用于生成对应的 action name 和参数
public class NCSocketSender {
    /// 生成 echo 字符串
    private static func generateEcho() -> String {
        return UUID().uuidString
    }

    /// 将 Swift 的驼峰命名转换为下划线命名
    private static func camelCaseToSnakeCase(_ input: String) -> String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(input.startIndex..., in: input)
        return regex.stringByReplacingMatches(
            in: input,
            range: range,
            withTemplate: "$1_$2"
        ).lowercased()
    }

    /// 生成发送参数
    /// - Parameter param: 要发送的参数对象
    public static func send<T: Encodable>(param: T) -> (action: String, param: T, echo: String) {
        let typeName = String(describing: type(of: param))
            .replacingOccurrences(of: "NCSocketSendParam.", with: "")
        let actionName = camelCaseToSnakeCase(typeName)
        return (actionName, param, generateEcho())
    }

    // MARK: - OneBot 11 协议

    /// 发送私聊消息
    /// - Parameters:
    ///   - userId: 目标用户 ID
    ///   - message: 要发送的消息内容数组
    public static func sendPrivateMsg(userId: Int, message: [NCSendMessage]) -> (action: String, param: NCSocketSendParam.SendPrivateMsg, echo: String) {
        let param = NCSocketSendParam.SendPrivateMsg(userId: userId, message: message)
        return send(param: param)
    }

    /// 发送群聊消息
    /// - Parameters:
    ///   - groupId: 目标群组 ID
    ///   - message: 要发送的消息内容数组
    public static func sendGroupMsg(groupId: Int, message: [NCSendMessage]) -> (action: String, param: NCSocketSendParam.SendGroupMsg, echo: String) {
        let param = NCSocketSendParam.SendGroupMsg(groupId: groupId, message: message)
        return send(param: param)
    }

    /// 发送消息（支持私聊和群聊）
    /// - Parameters:
    ///   - userId: 私聊时的目标用户 ID
    ///   - groupId: 群聊时的目标群组 ID
    ///   - message: 要发送的消息内容数组
    public static func sendMsg(userId: Int? = nil, groupId: Int? = nil, message: [NCSendMessage]) -> (action: String, param: NCSocketSendParam.SendMsg, echo: String) {
        let param = NCSocketSendParam.SendMsg(userId: userId, groupId: groupId, message: message)
        return send(param: param)
    }

    /// 撤回消息
    /// - Parameter messageId: 要撤回的消息 ID
    public static func deleteMsg(messageId: Int) -> (action: String, param: NCSocketSendParam.DeleteMsg, echo: String) {
        let param = NCSocketSendParam.DeleteMsg(messageId: messageId)
        return send(param: param)
    }

    /// 获取消息
    /// - Parameter messageId: 要获取的消息 ID
    public static func getMsg(messageId: Int) -> (action: String, param: NCSocketSendParam.GetMsg, echo: String) {
        let param = NCSocketSendParam.GetMsg(messageId: messageId)
        return send(param: param)
    }

    /// 发送好友点赞
    /// - Parameters:
    ///   - userId: 目标用户 ID
    ///   - times: 点赞次数
    public static func sendLike(userId: Int, times: Int) -> (action: String, param: NCSocketSendParam.SendLike, echo: String) {
        let param = NCSocketSendParam.SendLike(userId: userId, times: times)
        return send(param: param)
    }

    /// 踢出群组成员
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 要踢出的用户 ID
    ///   - rejectAddRequest: 是否拒绝此用户后续的加群请求
    public static func setGroupKick(groupId: Int, userId: Int, rejectAddRequest: Bool? = nil) -> (action: String, param: NCSocketSendParam.SetGroupKick, echo: String) {
        let param = NCSocketSendParam.SetGroupKick(groupId: groupId, userId: userId, rejectAddRequest: rejectAddRequest)
        return send(param: param)
    }

    /// 设置群组成员禁言
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 要禁言的用户 ID
    ///   - duration: 禁言时长（秒）
    public static func setGroupBan(groupId: Int, userId: Int, duration: Int) -> (action: String, param: NCSocketSendParam.SetGroupBan, echo: String) {
        let param = NCSocketSendParam.SetGroupBan(groupId: groupId, userId: userId, duration: duration)
        return send(param: param)
    }

    /// 设置群组全员禁言
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - enable: 是否启用全员禁言
    public static func setGroupWholeBan(groupId: Int, enable: Bool? = nil) -> (action: String, param: NCSocketSendParam.SetGroupWholeBan, echo: String) {
        let param = NCSocketSendParam.SetGroupWholeBan(groupId: groupId, enable: enable)
        return send(param: param)
    }

    /// 设置群组管理员
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 要设置的用户 ID
    ///   - enable: 是否设置为管理员
    public static func setGroupAdmin(groupId: Int, userId: Int, enable: Bool? = nil) -> (action: String, param: NCSocketSendParam.SetGroupAdmin, echo: String) {
        let param = NCSocketSendParam.SetGroupAdmin(groupId: groupId, userId: userId, enable: enable)
        return send(param: param)
    }

    /// 设置群名片
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 要设置的用户 ID
    ///   - card: 群名片内容
    public static func setGroupCard(groupId: Int, userId: Int, card: String) -> (action: String, param: NCSocketSendParam.SetGroupCard, echo: String) {
        let param = NCSocketSendParam.SetGroupCard(groupId: groupId, userId: userId, card: card)
        return send(param: param)
    }

    /// 设置群组名称
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - groupName: 新的群组名称
    public static func setGroupName(groupId: Int, groupName: String) -> (action: String, param: NCSocketSendParam.SetGroupName, echo: String) {
        let param = NCSocketSendParam.SetGroupName(groupId: groupId, groupName: groupName)
        return send(param: param)
    }

    /// 退出群组
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - isDismiss: 是否解散群组（群主专用）
    public static func setGroupLeave(groupId: Int, isDismiss: Bool? = nil) -> (action: String, param: NCSocketSendParam.SetGroupLeave, echo: String) {
        let param = NCSocketSendParam.SetGroupLeave(groupId: groupId, isDismiss: isDismiss)
        return send(param: param)
    }

    /// 设置群组专属头衔
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 要设置的用户 ID
    ///   - specialTitle: 专属头衔内容
    public static func setGroupSpecialTitle(groupId: Int, userId: Int, specialTitle: String) -> (action: String, param: NCSocketSendParam.SetGroupSpecialTitle, echo: String) {
        let param = NCSocketSendParam.SetGroupSpecialTitle(groupId: groupId, userId: userId, specialTitle: specialTitle)
        return send(param: param)
    }

    /// 处理好友添加请求
    /// - Parameters:
    ///   - flag: 请求标识
    ///   - approve: 是否同意请求
    ///   - remark: 好友备注
    public static func setFriendAddRequest(flag: String, approve: Bool? = nil, remark: String? = nil) -> (action: String, param: NCSocketSendParam.SetFriendAddRequest, echo: String) {
        let param = NCSocketSendParam.SetFriendAddRequest(flag: flag, approve: approve, remark: remark)
        return send(param: param)
    }

    /// 处理群组添加请求
    /// - Parameters:
    ///   - flag: 请求标识
    ///   - approve: 是否同意请求
    ///   - reason: 拒绝理由
    public static func setGroupAddRequest(flag: String, approve: Bool? = nil, reason: String? = nil) -> (action: String, param: NCSocketSendParam.SetGroupAddRequest, echo: String) {
        let param = NCSocketSendParam.SetGroupAddRequest(flag: flag, approve: approve, reason: reason)
        return send(param: param)
    }

    /// 获取登录信息
    public static func getLoginInfo() -> (action: String, param: NCSocketSendParam.GetLoginInfo, echo: String) {
        let param = NCSocketSendParam.GetLoginInfo()
        return send(param: param)
    }

    /// 获取陌生人信息
    /// - Parameter userId: 用户 ID
    public static func getStrangerInfo(userId: Int) -> (action: String, param: NCSocketSendParam.GetStrangerInfo, echo: String) {
        let param = NCSocketSendParam.GetStrangerInfo(userId: userId)
        return send(param: param)
    }

    /// 获取好友列表
    /// - Parameter noCache: 是否不使用缓存
    public static func getFriendList(noCache: Bool? = nil) -> (action: String, param: NCSocketSendParam.GetFriendList, echo: String) {
        let param = NCSocketSendParam.GetFriendList(noCache: noCache)
        return send(param: param)
    }

    /// 获取群组信息
    /// - Parameter groupId: 群组 ID
    public static func getGroupInfo(groupId: Int) -> (action: String, param: NCSocketSendParam.GetGroupInfo, echo: String) {
        let param = NCSocketSendParam.GetGroupInfo(groupId: groupId)
        return send(param: param)
    }

    /// 获取群组列表
    /// - Parameter noCache: 是否不使用缓存
    public static func getGroupList(noCache: Bool? = nil) -> (action: String, param: NCSocketSendParam.GetGroupList, echo: String) {
        let param = NCSocketSendParam.GetGroupList(noCache: noCache)
        return send(param: param)
    }

    /// 获取群组成员信息
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 用户 ID
    public static func getGroupMemberInfo(groupId: Int, userId: Int) -> (action: String, param: NCSocketSendParam.GetGroupMemberInfo, echo: String) {
        let param = NCSocketSendParam.GetGroupMemberInfo(groupId: groupId, userId: userId)
        return send(param: param)
    }

    /// 获取群组成员列表
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - noCache: 是否不使用缓存
    public static func getGroupMemberList(groupId: Int, noCache: Bool? = nil) -> (action: String, param: NCSocketSendParam.GetGroupMemberList, echo: String) {
        let param = NCSocketSendParam.GetGroupMemberList(groupId: groupId, noCache: noCache)
        return send(param: param)
    }

    /// 获取群组荣誉信息
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - type: 荣誉类型
    public static func getGroupHonorInfo(groupId: Int, type: NCSocketSendParam.GetGroupHonorInfo.HonorType? = nil) -> (action: String, param: NCSocketSendParam.GetGroupHonorInfo, echo: String) {
        let param = NCSocketSendParam.GetGroupHonorInfo(groupId: groupId, type: type)
        return send(param: param)
    }

    /// 获取 Cookies
    /// - Parameter domain: 域名
    public static func getCookies(domain: String) -> (action: String, param: NCSocketSendParam.GetCookies, echo: String) {
        let param = NCSocketSendParam.GetCookies(domain: domain)
        return send(param: param)
    }

    /// 获取 CSRF Token
    public static func getCsrfToken() -> (action: String, param: NCSocketSendParam.GetCsrfToken, echo: String) {
        let param = NCSocketSendParam.GetCsrfToken()
        return send(param: param)
    }

    /// 获取证书信息
    public static func getCredentials() -> (action: String, param: NCSocketSendParam.GetCredentials, echo: String) {
        let param = NCSocketSendParam.GetCredentials()
        return send(param: param)
    }

    /// 获取录音文件
    /// - Parameters:
    ///   - fileId: 文件 ID
    ///   - outFormat: 输出格式
    public static func getRecord(fileId: String, outFormat: NCSocketSendParam.GetRecord.RecordFormat? = nil) -> (action: String, param: NCSocketSendParam.GetRecord, echo: String) {
        let param = NCSocketSendParam.GetRecord(fileId: fileId, outFormat: outFormat)
        return send(param: param)
    }

    /// 获取图片
    /// - Parameter fileId: 文件 ID
    public static func getImage(fileId: String) -> (action: String, param: NCSocketSendParam.GetImage, echo: String) {
        let param = NCSocketSendParam.GetImage(fileId: fileId)
        return send(param: param)
    }

    /// 检查是否可以发送图片
    public static func canSendImage() -> (action: String, param: NCSocketSendParam.CanSendImage, echo: String) {
        let param = NCSocketSendParam.CanSendImage()
        return send(param: param)
    }

    /// 检查是否可以发送语音
    public static func canSendRecord() -> (action: String, param: NCSocketSendParam.CanSendRecord, echo: String) {
        let param = NCSocketSendParam.CanSendRecord()
        return send(param: param)
    }

    /// 获取运行状态
    public static func getStatus() -> (action: String, param: NCSocketSendParam.GetStatus, echo: String) {
        let param = NCSocketSendParam.GetStatus()
        return send(param: param)
    }

    /// 获取版本信息
    public static func getVersionInfo() -> (action: String, param: NCSocketSendParam.GetVersionInfo, echo: String) {
        let param = NCSocketSendParam.GetVersionInfo()
        return send(param: param)
    }

    // MARK: - go-cqhttp 协议

    /// 设置 QQ 资料
    /// - Parameters:
    ///   - nickname: 昵称
    ///   - personalNote: 个性签名
    ///   - sex: 性别
    public static func setQQProfile(nickname: String, personalNote: String? = nil, sex: Int? = nil) -> (action: String, param: NCSocketSendParam.SetQQProfile, echo: String) {
        let param = NCSocketSendParam.SetQQProfile(nickname: nickname, personalNote: personalNote, sex: sex)
        return send(param: param)
    }

    /// 获取在线客户端列表
    /// - Parameter noCache: 是否不使用缓存
    public static func getOnlineClients(noCache: Bool? = nil) -> (action: String, param: NCSocketSendParam.GetOnlineClients, echo: String) {
        let param = NCSocketSendParam.GetOnlineClients(noCache: noCache)
        return send(param: param)
    }

    /// 标记消息已读
    /// - Parameters:
    ///   - userId: 用户 ID (可选)
    ///   - groupId: 群组 ID (可选)
    ///
    /// 有两种方式：
    /// - 通过用户 ID 标记私聊消息已读
    /// - 通过群组 ID 标记群消息已读
    public static func markMsgAsRead(userId: Int, groupId: Int? = nil) -> (action: String, param: NCSocketSendParam.MarkMsgAsRead, echo: String) {
        let param = NCSocketSendParam.MarkMsgAsRead(userId: userId, groupId: groupId)
        return send(param: param)
    }

    /// 发送群转发消息
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - message: 消息内容数组
    public static func sendGroupForwardMsg(groupId: Int, message: [NodeMessage]) -> (action: String, param: NCSocketSendParam.SendGroupForwardMsg, echo: String) {
        let param = NCSocketSendParam.SendGroupForwardMsg(groupId: groupId, message: message)
        return send(param: param)
    }

    /// 发送私聊转发消息
    /// - Parameters:
    ///   - userId: 用户 ID
    ///   - message: 消息内容数组
    public static func sendPrivateForwardMsg(userId: Int, message: [NodeMessage]) -> (action: String, param: NCSocketSendParam.SendPrivateForwardMsg, echo: String) {
        let param = NCSocketSendParam.SendPrivateForwardMsg(userId: userId, message: message)
        return send(param: param)
    }

    /// 获取群消息历史记录
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - messageSeq: 消息序列号
    ///   - count: 获取消息数量
    ///   - reverseOrder: 是否逆序
    public static func getGroupMsgHistory(groupId: Int, messageSeq: Int? = nil, count: Int? = nil, reverseOrder: Bool? = nil) -> (action: String, param: NCSocketSendParam.GetGroupMsgHistory, echo: String) {
        let param = NCSocketSendParam.GetGroupMsgHistory(groupId: groupId, messageSeq: messageSeq, count: count, reverseOrder: reverseOrder)
        return send(param: param)
    }

    /// OCR 图片识别
    /// - Parameter image: 图片
    public static func ocrImage(image: String) -> (action: String, param: NCSocketSendParam.OCRImage, echo: String) {
        let param = NCSocketSendParam.OCRImage(image: image)
        return send(param: param)
    }

    /// 获取群系统消息
    /// - Parameter groupId: 群组 ID
    public static func getGroupSystemMsg(groupId: Int) -> (action: String, param: NCSocketSendParam.GetGroupSystemMsg, echo: String) {
        let param = NCSocketSendParam.GetGroupSystemMsg(groupId: groupId)
        return send(param: param)
    }

    /// 获取群精华消息列表
    /// - Parameter groupId: 群组 ID
    public static func getEssenceMsgList(groupId: Int) -> (action: String, param: NCSocketSendParam.GetEssenceMsgList, echo: String) {
        let param = NCSocketSendParam.GetEssenceMsgList(groupId: groupId)
        return send(param: param)
    }

    /// 设置群头像
    /// - Parameters:
    ///   - file: 文件
    ///   - groupId: 群组 ID
    public static func setGroupPortrait(file: String, groupId: Int) -> (action: String, param: NCSocketSendParam.SetGroupPortrait, echo: String) {
        let param = NCSocketSendParam.SetGroupPortrait(file: file, groupId: groupId)
        return send(param: param)
    }

    /// 设置群精华消息
    /// - Parameter messageId: 消息 ID
    public static func setEssenceMsg(messageId: Int) -> (action: String, param: NCSocketSendParam.SetEssenceMsg, echo: String) {
        let param = NCSocketSendParam.SetEssenceMsg(messageId: messageId)
        return send(param: param)
    }

    /// 删除群精华消息
    /// - Parameter messageId: 消息 ID
    public static func deleteEssenceMsg(messageId: Int) -> (action: String, param: NCSocketSendParam.DeleteEssenceMsg, echo: String) {
        let param = NCSocketSendParam.DeleteEssenceMsg(messageId: messageId)
        return send(param: param)
    }

    /// 发送群公告
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - content: 内容
    ///   - image: 图片
    ///   - pinned: 是否置顶
    ///   - type: 类型
    ///   - confirmRequired: 是否需要确认
    ///   - isShowEditCard: 是否显示编辑卡片
    ///   - tipWindowType: 提示窗口类型
    public static func sendGroupNotice(
        groupId: Int,
        content: String,
        image: String? = nil,
        pinned: Int? = nil,
        type: Int? = nil,
        confirmRequired: Int? = nil,
        isShowEditCard: Int? = nil,
        tipWindowType: Int? = nil
    ) -> (action: String, param: NCSocketSendParam.SendGroupNotice, echo: String) {
        let param = NCSocketSendParam.SendGroupNotice(
            groupId: groupId,
            content: content,
            image: image,
            pinned: pinned,
            type: type,
            confirmRequired: confirmRequired,
            isShowEditCard: isShowEditCard,
            tipWindowType: tipWindowType
        )
        return send(param: param)
    }

    /// 获取群公告
    /// - Parameter groupId: 群组 ID
    public static func getGroupNotice(groupId: Int) -> (action: String, param: NCSocketSendParam.GetGroupNotice, echo: String) {
        let param = NCSocketSendParam.GetGroupNotice(groupId: groupId)
        return send(param: param)
    }

    /// 上传群文件
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - file: 文件
    ///   - name: 文件名
    ///   - folderId: 文件夹 ID
    public static func uploadGroupFile(groupId: Int, file: String, name: String, folderId: String? = nil) -> (action: String, param: NCSocketSendParam.UploadGroupFile, echo: String) {
        let param = NCSocketSendParam.UploadGroupFile(groupId: groupId, file: file, name: name, folderId: folderId)
        return send(param: param)
    }

    /// 删除群文件
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - fileId: 文件 ID
    public static func deleteGroupFile(groupId: Int, fileId: String) -> (action: String, param: NCSocketSendParam.DeleteGroupFile, echo: String) {
        let param = NCSocketSendParam.DeleteGroupFile(groupId: groupId, fileId: fileId)
        return send(param: param)
    }

    /// 创建群文件夹
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - folderName: 文件夹名
    public static func createGroupFileFolder(groupId: Int, folderName: String) -> (action: String, param: NCSocketSendParam.CreateGroupFileFolder, echo: String) {
        let param = NCSocketSendParam.CreateGroupFileFolder(groupId: groupId, folderName: folderName)
        return send(param: param)
    }

    /// 删除群文件夹
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - folderId: 文件夹 ID
    public static func deleteGroupFolder(groupId: Int, folderId: String) -> (action: String, param: NCSocketSendParam.DeleteGroupFolder, echo: String) {
        let param = NCSocketSendParam.DeleteGroupFolder(groupId: groupId, folderId: folderId)
        return send(param: param)
    }

    /// 获取群文件系统信息
    /// - Parameter groupId: 群组 ID
    public static func getGroupFileSystemInfo(groupId: Int) -> (action: String, param: NCSocketSendParam.GetGroupFileSystemInfo, echo: String) {
        let param = NCSocketSendParam.GetGroupFileSystemInfo(groupId: groupId)
        return send(param: param)
    }

    /// 获取群根目录文件列表
    /// - Parameter groupId: 群组 ID
    public static func getGroupRootFiles(groupId: Int) -> (action: String, param: NCSocketSendParam.GetGroupRootFiles, echo: String) {
        let param = NCSocketSendParam.GetGroupRootFiles(groupId: groupId)
        return send(param: param)
    }

    /// 获取群文件列表
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - folderId: 文件夹 ID
    ///   - fileCount: 文件数量
    public static func getGroupFilesByFolder(groupId: Int, folderId: String? = nil, fileCount: Int? = nil) -> (action: String, param: NCSocketSendParam.GetGroupFilesByFolder, echo: String) {
        let param = NCSocketSendParam.GetGroupFilesByFolder(groupId: groupId, folderId: folderId, fileCount: fileCount)
        return send(param: param)
    }

    /// 获取群文件 URL
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - fileId: 文件 ID
    public static func getGroupFileUrl(groupId: Int, fileId: String) -> (action: String, param: NCSocketSendParam.GetGroupFileUrl, echo: String) {
        let param = NCSocketSendParam.GetGroupFileUrl(groupId: groupId, fileId: fileId)
        return send(param: param)
    }

    /// 上传私聊文件
    /// - Parameters:
    ///   - userId: 用户 ID
    ///   - file: 文件
    ///   - name: 文件名
    public static func uploadPrivateFile(userId: Int, file: String, name: String) -> (action: String, param: NCSocketSendParam.UploadPrivateFile, echo: String) {
        let param = NCSocketSendParam.UploadPrivateFile(userId: userId, file: file, name: name)
        return send(param: param)
    }

    /// 下载文件
    /// - Parameters:
    ///   - base64: base64
    ///   - url: url
    ///   - threadCount: 线程数
    ///   - headers: 请求头
    ///   - name: 文件名
    public static func downloadFile(base64: String? = nil, url: String? = nil, threadCount: Int? = nil, headers: [String]? = nil, name: String? = nil) -> (action: String, param: NCSocketSendParam.DownloadFile, echo: String) {
        let param = NCSocketSendParam.DownloadFile(base64: base64, url: url, threadCount: threadCount, headers: headers, name: name)
        return send(param: param)
    }

    // MARK: - NapCat 协议

    /// 点对点分享
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 用户 ID
    ///   - phoneNumber: 手机号码
    public static func arkSharePeer(groupId: String? = nil, userId: String? = nil, phoneNumber: String? = nil) -> (action: String, param: NCSocketSendParam.ArkSharePeer, echo: String) {
        let param = NCSocketSendParam.ArkSharePeer(groupId: groupId, userId: userId, phoneNumber: phoneNumber)
        return send(param: param)
    }

    /// 获取机器人 UIN 范围
    public static func getRobotUinRange() -> (action: String, param: NCSocketSendParam.GetRobotUinRange, echo: String) {
        let param = NCSocketSendParam.GetRobotUinRange()
        return send(param: param)
    }

    /// 设置在线状态
    /// - Parameters:
    ///   - status: 状态码
    ///   - extStatus: 扩展状态码
    ///   - batteryStatus: 电池状态
    public static func setOnlineStatus(status: Int, extStatus: Int, batteryStatus: Int) -> (action: String, param: NCSocketSendParam.SetOnlineStatus, echo: String) {
        let param = NCSocketSendParam.SetOnlineStatus(status: status, extStatus: extStatus, batteryStatus: batteryStatus)
        return send(param: param)
    }

    /// 获取带分类的好友列表
    public static func getFriendsWithCategory() -> (action: String, param: NCSocketSendParam.GetFriendsWithCategory, echo: String) {
        let param = NCSocketSendParam.GetFriendsWithCategory()
        return send(param: param)
    }

    /// 设置 QQ 头像
    /// - Parameter file: 头像文件路径
    public static func setQQAvatar(file: String) -> (action: String, param: NCSocketSendParam.SetQQAvatar, echo: String) {
        let param = NCSocketSendParam.SetQQAvatar(file: file)
        return send(param: param)
    }

    /// 获取文件
    /// - Parameter fileId: 文件 ID
    public static func getFile(fileId: String) -> (action: String, param: NCSocketSendParam.GetFile, echo: String) {
        let param = NCSocketSendParam.GetFile(fileId: fileId)
        return send(param: param)
    }

    /// 转发单条好友消息
    /// - Parameters:
    ///   - messageId: 消息 ID
    ///   - userId: 目标用户 ID
    public static func forwardFriendSingleMsg(messageId: Int, userId: Int) -> (action: String, param: NCSocketSendParam.ForwardFriendSingleMsg, echo: String) {
        let param = NCSocketSendParam.ForwardFriendSingleMsg(messageId: messageId, userId: userId)
        return send(param: param)
    }

    /// 转发单条群消息
    /// - Parameters:
    ///   - messageId: 消息 ID
    ///   - groupId: 目标群组 ID
    public static func forwardGroupSingleMsg(messageId: Int, groupId: Int) -> (action: String, param: NCSocketSendParam.ForwardGroupSingleMsg, echo: String) {
        let param = NCSocketSendParam.ForwardGroupSingleMsg(messageId: messageId, groupId: groupId)
        return send(param: param)
    }

    /// 英文翻译为中文
    /// - Parameter words: 要翻译的词组数组
    public static func translateEn2Zh(words: [String]) -> (action: String, param: NCSocketSendParam.TranslateEn2Zh, echo: String) {
        let param = NCSocketSendParam.TranslateEn2Zh(words: words)
        return send(param: param)
    }

    /// 设置消息表情回应
    /// - Parameters:
    ///   - messageId: 消息 ID
    ///   - emojiId: 表情 ID
    public static func setMsgEmojiLike(messageId: Int, emojiId: String) -> (action: String, param: NCSocketSendParam.SetMsgEmojiLike, echo: String) {
        let param = NCSocketSendParam.SetMsgEmojiLike(messageId: messageId, emojiId: emojiId)
        return send(param: param)
    }

    /// 标记私聊消息为已读
    /// - Parameter userId: 用户 ID
    public static func markPrivateMsgAsRead(userId: Int) -> (action: String, param: NCSocketSendParam.MarkPrivateMsgAsRead, echo: String) {
        let param = NCSocketSendParam.MarkPrivateMsgAsRead(userId: userId)
        return send(param: param)
    }

    /// 获取好友消息历史
    /// - Parameters:
    ///   - userId: 用户 ID
    ///   - messageSeq: 消息序列号
    ///   - count: 获取数量
    ///   - reverseOrder: 是否逆序获取
    public static func getFriendMsgHistory(userId: Int, messageSeq: Int? = nil, count: Int? = nil, reverseOrder: Bool? = nil) -> (action: String, param: NCSocketSendParam.GetFriendMsgHistory, echo: String) {
        let param = NCSocketSendParam.GetFriendMsgHistory(userId: userId, messageSeq: messageSeq, count: count, reverseOrder: reverseOrder)
        return send(param: param)
    }

    /// 创建收藏
    /// - Parameters:
    ///   - rawData: 原始数据
    ///   - brief: 简介
    public static func createCollection(rawData: String, brief: String) -> (action: String, param: NCSocketSendParam.CreateCollection, echo: String) {
        let param = NCSocketSendParam.CreateCollection(rawData: rawData, brief: brief)
        return send(param: param)
    }

    /// 获取收藏列表
    /// - Parameters:
    ///   - category: 分类
    ///   - count: 获取数量
    public static func getCollectionList(category: Int, count: Int) -> (action: String, param: NCSocketSendParam.GetCollectionList, echo: String) {
        let param = NCSocketSendParam.GetCollectionList(category: category, count: count)
        return send(param: param)
    }

    /// 设置个性签名
    /// - Parameter longNick: 个性签名内容
    public static func setSelfLongnick(longNick: String) -> (action: String, param: NCSocketSendParam.SetSelfLongnick, echo: String) {
        let param = NCSocketSendParam.SetSelfLongnick(longNick: longNick)
        return send(param: param)
    }

    /// 获取最近联系人
    /// - Parameter count: 获取数量
    public static func getRecentContact(count: Int? = nil) -> (action: String, param: NCSocketSendParam.GetRecentContact, echo: String) {
        let param = NCSocketSendParam.GetRecentContact(count: count)
        return send(param: param)
    }

    /// 标记所有消息为已读
    public static func markAllAsRead() -> (action: String, param: NCSocketSendParam.MarkAllAsRead, echo: String) {
        let param = NCSocketSendParam.MarkAllAsRead()
        return send(param: param)
    }

    /// 获取资料点赞信息
    public static func getProfileLike() -> (action: String, param: NCSocketSendParam.GetProfileLike, echo: String) {
        let param = NCSocketSendParam.GetProfileLike()
        return send(param: param)
    }

    /// 获取自定义表情
    /// - Parameter count: 获取数量
    public static func fetchCustomFace(count: Int? = nil) -> (action: String, param: NCSocketSendParam.FetchCustomFace, echo: String) {
        let param = NCSocketSendParam.FetchCustomFace(count: count)
        return send(param: param)
    }

    /// 获取表情点赞信息
    /// - Parameters:
    ///   - emojiId: 表情 ID
    ///   - emojiType: 表情类型
    ///   - messageId: 消息 ID
    ///   - count: 获取数量
    public static func fetchEmojiLike(emojiId: String, emojiType: String, messageId: Int, count: Int? = nil) -> (action: String, param: NCSocketSendParam.FetchEmojiLike, echo: String) {
        let param = NCSocketSendParam.FetchEmojiLike(emojiId: emojiId, emojiType: emojiType, messageId: messageId, count: count)
        return send(param: param)
    }

    /// 设置输入状态
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 用户 ID
    ///   - eventType: 事件类型
    public static func setInputStatus(groupId: String? = nil, userId: String? = nil, eventType: String) -> (action: String, param: NCSocketSendParam.SetInputStatus, echo: String) {
        let param = NCSocketSendParam.SetInputStatus(groupId: groupId, userId: userId, eventType: eventType)
        return send(param: param)
    }

    /// 获取扩展群信息
    /// - Parameter groupId: 群组 ID
    public static func getGroupInfoEx(groupId: Int) -> (action: String, param: NCSocketSendParam.GetGroupInfoEx, echo: String) {
        let param = NCSocketSendParam.GetGroupInfoEx(groupId: groupId)
        return send(param: param)
    }

    /// 获取群忽略添加请求状态
    /// - Parameter groupId: 群组 ID
    public static func getGroupIgnoreAddRequest(groupId: Int) -> (action: String, param: NCSocketSendParam.GetGroupIgnoreAddRequest, echo: String) {
        let param = NCSocketSendParam.GetGroupIgnoreAddRequest(groupId: groupId)
        return send(param: param)
    }

    /// 删除群公告
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - noticeId: 公告 ID
    public static func delGroupNotice(groupId: Int, noticeId: String) -> (action: String, param: NCSocketSendParam.DelGroupNotice, echo: String) {
        let param = NCSocketSendParam.DelGroupNotice(groupId: groupId, noticeId: noticeId)
        return send(param: param)
    }

    /// 获取用户资料点赞信息
    /// - Parameter qq: QQ 号码
    public static func fetchUserProfileLike(qq: Int) -> (action: String, param: NCSocketSendParam.FetchUserProfileLike, echo: String) {
        let param = NCSocketSendParam.FetchUserProfileLike(qq: qq)
        return send(param: param)
    }

    /// 好友戳一戳
    /// - Parameter userId: 用户 ID
    public static func friendPoke(userId: Int) -> (action: String, param: NCSocketSendParam.FriendPoke, echo: String) {
        let param = NCSocketSendParam.FriendPoke(userId: userId)
        return send(param: param)
    }

    /// 群组戳一戳
    /// - Parameters:
    ///   - groupId: 群组 ID
    ///   - userId: 用户 ID
    public static func groupPoke(groupId: Int, userId: Int) -> (action: String, param: NCSocketSendParam.GroupPoke, echo: String) {
        let param = NCSocketSendParam.GroupPoke(groupId: groupId, userId: userId)
        return send(param: param)
    }

    /// 获取数据包状态
    public static func ncGetPacketStatus() -> (action: String, param: NCSocketSendParam.NCGetPacketStatus, echo: String) {
        let param = NCSocketSendParam.NCGetPacketStatus()
        return send(param: param)
    }

    /// 获取用户状态
    /// - Parameter userId: 用户 ID
    public static func ncGetUserStatus(userId: Int) -> (action: String, param: NCSocketSendParam.NCGetUserStatus, echo: String) {
        let param = NCSocketSendParam.NCGetUserStatus(userId: userId)
        return send(param: param)
    }

    /// 获取 RKey
    public static func ncGetRKey() -> (action: String, param: NCSocketSendParam.NCGetRKey, echo: String) {
        let param = NCSocketSendParam.NCGetRKey()
        return send(param: param)
    }

    /// 获取群禁言列表
    /// - Parameter groupId: 群组 ID
    public static func getGroupShutList(groupId: Int) -> (action: String, param: NCSocketSendParam.GetGroupShutList, echo: String) {
        let param = NCSocketSendParam.GetGroupShutList(groupId: groupId)
        return send(param: param)
    }
}
