//
//  NCSocketSendParam.swift
//  TeliQKit
//
//  Created by Wibus on 2024/11/5.
//

import Foundation

/// WebSocket 发送参数的数据结构
public struct NCSocketSendParam: Codable {
    // MARK: - OneBot 11 协议

    /// (OneBot) 用于发送私聊消息的参数结构
    public struct SendPrivateMsg: Codable {
        /// 接收消息的用户 ID
        public let userId: Int
        /// 要发送的消息内容数组
        public let message: [NCSendMessage]

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case message
        }
    }

    /// (OneBot) 用于发送群聊消息的参数结构
    public struct SendGroupMsg: Codable {
        /// 目标群组 ID
        public let groupId: Int
        /// 要发送的消息内容数组
        public let message: [NCSendMessage]

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case message
        }
    }

    /// (OneBot) 用于发送通用消息的参数结构，支持私聊和群聊
    public struct SendMsg: Codable {
        /// 私聊时的目标用户 ID
        public let userId: Int?
        /// 群聊时的目标群组 ID
        public let groupId: Int?
        /// 要发送的消息内容数组
        public let message: [NCSendMessage]

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case groupId = "group_id"
            case message
        }
    }

    /// (OneBot) 用于删除消息的参数结构
    public struct DeleteMsg: Codable {
        /// 要删除的消息 ID
        public let messageId: Int

        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }

    /// (OneBot) 用于获取消息的参数结构
    public struct GetMsg: Codable {
        /// 要获取的消息 ID
        public let messageId: Int

        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }

    /// (OneBot) 用于发送点赞的参数结构
    public struct SendLike: Codable {
        /// 要点赞的用户 ID
        public let userId: Int
        /// 点赞次数
        public let times: Int

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case times
        }
    }

    /// (OneBot) 用于踢出群组成员的参数结构
    public struct SetGroupKick: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 要踢出的用户 ID
        public let userId: Int
        /// 是否拒绝此用户后续的加群请求
        public let rejectAddRequest: Bool?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
            case rejectAddRequest = "reject_add_request"
        }
    }

    /// (OneBot) 用于设置群组成员禁言的参数结构
    public struct SetGroupBan: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 要禁言的用户 ID
        public let userId: Int
        /// 禁言时长（秒）
        public let duration: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
            case duration
        }
    }

    /// (OneBot) 用于设置群组全员禁言的参数结构
    public struct SetGroupWholeBan: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 是否启用全员禁言
        public let enable: Bool?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case enable
        }
    }

    /// (OneBot) 用于设置群组管理员的参数结构
    public struct SetGroupAdmin: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 要设置的用户 ID
        public let userId: Int
        /// 是否设置为管理员
        public let enable: Bool?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
            case enable
        }
    }

    /// (OneBot) 用于设置群名片的参数结构
    public struct SetGroupCard: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 要设置的用户 ID
        public let userId: Int
        /// 群名片内容
        public let card: String

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
            case card
        }
    }

    /// (OneBot) 用于设置群组名称的参数结构
    public struct SetGroupName: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 新的群组名称
        public let groupName: String

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case groupName = "group_name"
        }
    }

    /// (OneBot) 用于退出群组的参数结构
    public struct SetGroupLeave: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 是否解散群组（群主专用）
        public let isDismiss: Bool?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case isDismiss = "is_dismiss"
        }
    }

    /// (OneBot) 用于设置群组专属头衔的参数结构
    public struct SetGroupSpecialTitle: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 要设置的用户 ID
        public let userId: Int
        /// 专属头衔内容
        public let specialTitle: String

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
            case specialTitle = "special_title"
        }
    }

    /// (OneBot) 用于处理好友添加请求的参数结构
    public struct SetFriendAddRequest: Codable {
        /// 请求标识
        public let flag: String
        /// 是否同意请求
        public let approve: Bool?
        /// 好友备注
        public let remark: String?
    }

    /// (OneBot) 用于处理群组添加请求的参数结构
    public struct SetGroupAddRequest: Codable {
        /// 请求标识
        public let flag: String
        /// 是否同意请求
        public let approve: Bool?
        /// 拒绝理由
        public let reason: String?
    }

    /// (OneBot) 用于获取登录信息的参数结构
    public struct GetLoginInfo: Codable {}

    /// (OneBot) 用于获取陌生人信息的参数结构
    public struct GetStrangerInfo: Codable {
        /// 用户 ID
        public let userId: Int

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
        }
    }

    /// (OneBot) 用于获取好友列表的参数结构
    public struct GetFriendList: Codable {
        /// 是否不使用缓存
        public let noCache: Bool?

        enum CodingKeys: String, CodingKey {
            case noCache = "no_cache"
        }
    }

    /// (OneBot) 用于获取群组信息的参数结构
    public struct GetGroupInfo: Codable {
        /// 群组 ID
        public let groupId: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
        }
    }

    /// (OneBot) 用于获取群组列表的参数结构
    public struct GetGroupList: Codable {
        /// 是否不使用缓存
        public let noCache: Bool?

        enum CodingKeys: String, CodingKey {
            case noCache = "no_cache"
        }
    }

    /// (OneBot) 用于获取群组成员信息的参数结构
    public struct GetGroupMemberInfo: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 用户 ID
        public let userId: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
        }
    }

    /// (OneBot) 用于获取群组成员列表的参数结构
    public struct GetGroupMemberList: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 是否不使用缓存
        public let noCache: Bool?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case noCache = "no_cache"
        }
    }

    /// (OneBot) 用于获取群组荣誉信息的参数结构
    public struct GetGroupHonorInfo: Codable {
        public enum HonorType: String, Codable {
            case all, talkative, performer, legend, strongNewbie, emotion
        }

        /// 群组 ID
        public let groupId: Int
        /// 荣誉类型
        public let type: HonorType?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case type
        }
    }

    /// (OneBot) 用于获取 Cookies 的参数结构
    public struct GetCookies: Codable {
        /// 域名
        public let domain: String
    }

    /// (OneBot) 用于获取 CSRF Token 的参数结构
    public struct GetCsrfToken: Codable {}

    // get_credentials: {}
    // get_record: {
    //   file_id: string
    //   out_format?: 'mp3' | 'amr' | 'wma' | 'm4a' | 'spx' | 'ogg' | 'wav' | 'flac'
    // }
    // get_image: { file_id: string }
    // can_send_image: {}
    // can_send_record: {}
    // get_status: {}
    // get_version_info: {}

    /// (OneBot) 用于获取证书信息
    public struct GetCredentials: Codable {}

    /// (OneBot) 用于获取录音的参数结构
    public struct GetRecord: Codable {
        public enum RecordFormat: String, Codable {
            case mp3, amr, wma, m4a, spx, ogg, wav, flac
        }

        /// 文件 ID
        public let fileId: String
        /// 输出格式
        public let outFormat: RecordFormat?

        enum CodingKeys: String, CodingKey {
            case fileId = "file_id"
            case outFormat = "out_format"
        }
    }

    /// (OneBot) 用于获取图片的参数结构
    public struct GetImage: Codable {
        /// 文件 ID
        public let fileId: String

        enum CodingKeys: String, CodingKey {
            case fileId = "file_id"
        }
    }

    /// (OneBot) 用于检查是否可以发送图片的参数结构
    public struct CanSendImage: Codable {}

    /// (OneBot) 用于检查是否可以发送录音的参数结构
    public struct CanSendRecord: Codable {}

    /// (OneBot) 用于获取状态的参数结构
    public struct GetStatus: Codable {}

    /// (OneBot) 用于获取版本信息的参数结构
    public struct GetVersionInfo: Codable {}

    // MARK: - go-cqhttp 协议

    /// (go-cqhttp) 用于设置 QQ 个人资料的参数结构
    public struct SetQQProfile: Codable {
        /// 昵称
        public let nickname: String
        /// 个性签名
        public let personalNote: String?
        /// 性别
        public let sex: Int?

        enum CodingKeys: String, CodingKey {
            case nickname
            case personalNote = "personal_note"
            case sex
        }
    }

    /// (go-cqhttp) 用于获取在线客户端列表的参数结构
    public struct GetOnlineClients: Codable {
        /// 是否不使用缓存
        public let noCache: Bool?

        enum CodingKeys: String, CodingKey {
            case noCache = "no_cache"
        }
    }

    /// (go-cqhttp) 用于标记消息已读的参数结构
    ///
    /// 有两种方式：
    /// - 通过用户 ID 标记私聊消息已读
    /// - 通过群组 ID 标记群消息已读
    public struct MarkMsgAsRead: Codable {
        /// 用户 ID
        public let userId: Int
        /// 群组 ID
        public let groupId: Int?

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case groupId = "group_id"
        }
    }

    /// (go-cqhttp) 用于发送群转发消息的参数结构
    public struct SendGroupForwardMsg: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 消息内容
        public let message: [NodeMessage]

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case message
        }
    }

    /// (go-cqhttp) 用于发送私聊转发消息的参数结构
    public struct SendPrivateForwardMsg: Codable {
        /// 用户 ID
        public let userId: Int
        /// 消息内容
        public let message: [NodeMessage]

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case message
        }
    }

    /// (go-cqhttp) 用于获取群消息历史记录的参数结构
    public struct GetGroupMsgHistory: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 消息序列号
        public let messageSeq: Int?
        /// 获取消息数量
        public let count: Int?
        /// 是否逆序
        public let reverseOrder: Bool?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case messageSeq = "message_seq"
            case count
            case reverseOrder = "reverse_order"
        }
    }

    /// (go-cqhttp) OCR 图片识别
    public struct OCRImage: Codable {
        /// 图片
        public let image: String
    }

    /// (go-cqhttp) 获取群系统消息
    public struct GetGroupSystemMsg: Codable {
        /// 群组 ID
        public let groupId: Int
    }

    /// (go-cqhttp) 获取群精华消息列表
    public struct GetEssenceMsgList: Codable {
        /// 群组 ID
        public let groupId: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
        }
    }

    /// (go-cqhttp) 设置群头像
    public struct SetGroupPortrait: Codable {
        /// 文件
        public let file: String
        /// 群组 ID
        public let groupId: Int
    }

    /// (go-cqhttp) 设置群精华消息
    public struct SetEssenceMsg: Codable {
        /// 消息 ID
        public let messageId: Int
    }

    /// (go-cqhttp) 删除群精华消息
    public struct DeleteEssenceMsg: Codable {
        /// 消息 ID
        public let messageId: Int
    }

    /// (go-cqhttp) 发送群公告
    public struct SendGroupNotice: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 内容
        public let content: String
        /// 图片
        public let image: String?
        /// 是否置顶
        public let pinned: Int?
        /// 类型
        public let type: Int?
        /// 是否需要确认
        public let confirmRequired: Int?
        /// 是否显示编辑卡片
        public let isShowEditCard: Int?
        /// 提示窗口类型
        public let tipWindowType: Int?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case content
            case image
            case pinned
            case type
            case confirmRequired = "confirm_required"
            case isShowEditCard = "is_show_edit_card"
            case tipWindowType = "tip_window_type"
        }
    }

    /// (go-cqhttp) 获取群公告
    public struct GetGroupNotice: Codable {
        /// 群组 ID
        public let groupId: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
        }
    }

    /// (go-cqhttp) 上传群文件
    public struct UploadGroupFile: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 文件
        public let file: String
        /// 文件名
        public let name: String
        /// 文件夹 ID
        public let folderId: String?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case file
            case name
            case folderId = "folder_id"
        }
    }

    /// (go-cqhttp) 删除群文件
    public struct DeleteGroupFile: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 文件 ID
        public let fileId: String
    }

    /// (go-cqhttp) 创建群文件夹
    public struct CreateGroupFileFolder: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 文件夹名
        public let folderName: String
    }

    /// (go-cqhttp) 删除群文件夹
    public struct DeleteGroupFolder: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 文件夹 ID
        public let folderId: String
    }

    /// (go-cqhttp) 获取群文件系统信息
    public struct GetGroupFileSystemInfo: Codable {
        /// 群组 ID
        public let groupId: Int
    }

    /// (go-cqhttp) 获取群根目录文件列表
    public struct GetGroupRootFiles: Codable {
        /// 群组 ID
        public let groupId: Int
    }

    /// (go-cqhttp) 获取群文件列表
    public struct GetGroupFilesByFolder: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 文件夹 ID
        public let folderId: String?
        /// 文件数量
        public let fileCount: Int?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case folderId = "folder_id"
            case fileCount = "file_count"
        }
    }

    /// (go-cqhttp) 获取群文件 URL
    public struct GetGroupFileUrl: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 文件 ID
        public let fileId: String

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case fileId = "file_id"
        }
    }

    /// (go-cqhttp) 上传私聊文件
    public struct UploadPrivateFile: Codable {
        /// 用户 ID
        public let userId: Int
        /// 文件
        public let file: String
        /// 文件名
        public let name: String

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case file
            case name
        }
    }

    /// (go-cqhttp) 下载文件
    public struct DownloadFile: Codable {
        /// base64
        public let base64: String?
        /// url
        public let url: String?
        /// 线程数
        public let threadCount: Int?
        /// 请求头
        public let headers: [String]?
        /// 文件名
        public let name: String?
    }

    // MARK: - NapCat 协议

    /// (NapCat) 用于 ArkShare 点对点分享的参数结构
    public struct ArkSharePeer: Codable {
        /// 群组 ID
        public let groupId: String?
        /// 用户 ID
        public let userId: String?
        /// 手机号码
        public let phoneNumber: String?

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
            case phoneNumber
        }
    }

    /// (NapCat) 用于获取机器人 UIN 范围的参数结构
    public struct GetRobotUinRange: Codable {}

    /// (NapCat) 用于设置在线状态的参数结构
    public struct SetOnlineStatus: Codable {
        /// 状态码
        public let status: Int
        /// 扩展状态码
        public let extStatus: Int
        /// 电池状态
        public let batteryStatus: Int

        enum CodingKeys: String, CodingKey {
            case status
            case extStatus = "ext_status"
            case batteryStatus = "battery_status"
        }
    }

    /// (NapCat) 用于获取带分类的好友列表的参数结构
    public struct GetFriendsWithCategory: Codable {}

    /// (NapCat) 用于设置 QQ 头像的参数结构
    public struct SetQQAvatar: Codable {
        /// 文件路径
        public let file: String
    }

    /// (NapCat) 用于获取文件的参数结构
    public struct GetFile: Codable {
        /// 文件 ID
        public let fileId: String

        enum CodingKeys: String, CodingKey {
            case fileId = "file_id"
        }
    }

    /// (NapCat) 用于转发单条好友消息的参数结构
    public struct ForwardFriendSingleMsg: Codable {
        /// 消息 ID
        public let messageId: Int
        /// 用户 ID
        public let userId: Int

        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
            case userId = "user_id"
        }
    }

    /// (NapCat) 用于转发单条群消息的参数结构
    public struct ForwardGroupSingleMsg: Codable {
        /// 消息 ID
        public let messageId: Int
        /// 群组 ID
        public let groupId: Int

        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
            case groupId = "group_id"
        }
    }

    /// (NapCat) 用于英文到中文翻译的参数结构
    public struct TranslateEn2Zh: Codable {
        /// 要翻译的词组数组
        public let words: [String]
    }

    /// (NapCat) 用于设置消息表情回应的参数结构
    public struct SetMsgEmojiLike: Codable {
        /// 消息 ID
        public let messageId: Int
        /// 表情 ID
        public let emojiId: String

        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
            case emojiId = "emoji_id"
        }
    }

    /// (NapCat) 用于标记私聊消息已读的参数结构
    public struct MarkPrivateMsgAsRead: Codable {
        /// 用户 ID
        public let userId: Int

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
        }
    }

    /// (NapCat) 用于获取好友消息历史的参数结构
    public struct GetFriendMsgHistory: Codable {
        /// 用户 ID
        public let userId: Int
        /// 消息序列号
        public let messageSeq: Int?
        /// 获取数量
        public let count: Int?
        /// 是否逆序
        public let reverseOrder: Bool?

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case messageSeq = "message_seq"
            case count
            case reverseOrder
        }
    }

    /// (NapCat) 用于创建收藏的参数结构
    public struct CreateCollection: Codable {
        /// 原始数据
        public let rawData: String
        /// 简介
        public let brief: String
    }

    /// (NapCat) 用于获取收藏列表的参数结构
    public struct GetCollectionList: Codable {
        /// 分类
        public let category: Int
        /// 数量
        public let count: Int
    }

    /// (NapCat) 用于设置个性签名的参数结构
    public struct SetSelfLongnick: Codable {
        /// 个性签名内容
        public let longNick: String
    }

    /// (NapCat) 用于获取最近联系人的参数结构
    public struct GetRecentContact: Codable {
        /// 获取数量
        public let count: Int?
    }

    /// (NapCat) 用于标记所有消息为已读的参数结构
    public struct MarkAllAsRead: Codable {}

    /// (NapCat) 用于获取点赞资料的参数结构
    public struct GetProfileLike: Codable {}

    /// (NapCat) 用于获取自定义表情的参数结构
    public struct FetchCustomFace: Codable {
        /// 获取数量
        public let count: Int?
    }

    /// (NapCat) 用于获取表情点赞的参数结构
    public struct FetchEmojiLike: Codable {
        /// 表情 ID
        public let emojiId: String
        /// 表情类型
        public let emojiType: String
        /// 消息 ID
        public let messageId: Int
        /// 获取数量
        public let count: Int?

        enum CodingKeys: String, CodingKey {
            case emojiId
            case emojiType
            case messageId = "message_id"
            case count
        }
    }

    /// (NapCat) 用于设置输入状态的参数结构
    public struct SetInputStatus: Codable {
        /// 群组 ID
        public let groupId: String?
        /// 用户 ID
        public let userId: String?
        /// 事件类型
        public let eventType: String

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
            case eventType
        }
    }

    /// (NapCat) 用于获取扩展群信息的参数结构
    public struct GetGroupInfoEx: Codable {
        /// 群组 ID
        public let groupId: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
        }
    }

    /// (NapCat) 用于获取群忽略添加请求的参数结构
    public struct GetGroupIgnoreAddRequest: Codable {
        /// 群组 ID
        public let groupId: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
        }
    }

    /// (NapCat) 用于删除群公告的参数结构
    public struct DelGroupNotice: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 公告 ID
        public let noticeId: String

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case noticeId = "notice_id"
        }
    }

    /// (NapCat) 用于获取用户资料点赞的参数结构
    public struct FetchUserProfileLike: Codable {
        /// QQ 号码
        public let qq: Int
    }

    /// (NapCat) 用于好友戳一戳的参数结构
    public struct FriendPoke: Codable {
        /// 用户 ID
        public let userId: Int

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
        }
    }

    /// (NapCat) 用于群组戳一戳的参数结构
    public struct GroupPoke: Codable {
        /// 群组 ID
        public let groupId: Int
        /// 用户 ID
        public let userId: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
        }
    }

    /// (NapCat) 用于获取数据包状态的参数结构
    public struct NCGetPacketStatus: Codable {}

    /// (NapCat) 用于获取用户状态的参数结构
    public struct NCGetUserStatus: Codable {
        /// 用户 ID
        public let userId: Int

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
        }
    }

    /// (NapCat) 用于获取 RKey 的参数结构
    public struct NCGetRKey: Codable {}

    /// (NapCat) 用于获取群禁言列表的参数结构
    public struct GetGroupShutList: Codable {
        /// 群组 ID
        public let groupId: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
        }
    }
}
