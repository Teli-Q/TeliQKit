//
//  NCSocketSendReturn.swift
//  TeliQKit
//
//  Created by Wibus on 2024/11/5.
//

import Foundation

/// WebSocket 返回参数的数据结构
public struct NCSocketReturn: Codable {
    /// (OneBot) 发送私聊消息返回的参数结构
    public typealias SendPrivateMsg = SendMsg
    
    /// (OneBot) 发送群聊消息返回的参数结构
    public typealias SendGroupMsg = SendMsg
    
    /// (OneBot) 发送消息返回的参数结构
    public struct SendMsg: Codable {
        public let messageId: Int
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
        }
    }
    
    /// (OneBot) 删除消息返回的参数结构
    public struct DeleteMsg: Codable {}
    
    /// (OneBot) 获取消息返回的参数结构
    public struct GetMsg: Codable {
        // 定义 MessageType 枚举来区分消息类型
        public enum MessageType: String, Codable {
            case privateMessage = "private"
            case groupMessage = "group"
        }

        // 定义 PrivateSender 和 GroupSender
        public struct PrivateSender: Codable {
            public let userId: Int
            public let nickname: String
            public let card: String
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case nickname
                case card
            }
        }

        public struct GroupSender: Codable {
            public let userId: Int
            public let nickname: String
            public let card: String
            public let role: String // 'owner' | 'admin' | 'member'
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case nickname
                case card
                case role
            }
        }

        // 根据 message_type 区分不同类型的消息
        public let messageType: MessageType // 'private' | 'group'
        public let groupId: Int?
        public let sender: Sender // 根据 messageType 来区分 PrivateSender 或 GroupSender
        public let subType: String // 'friend' | 'normal'
        public let selfId: Int
        public let userId: Int
        public let time: Int
        public let messageId: Int
        public let messageSeq: Int
        public let realId: Int
        public let rawMessage: String
        public let font: Int
        public let postType: String // 'message' | 'message_sent'

        enum CodingKeys: String, CodingKey {
            case messageType = "message_type"
            case groupId = "group_id"
            case sender
            case subType = "sub_type"
            case selfId = "self_id"
            case userId = "user_id"
            case time
            case messageId = "message_id"
            case messageSeq = "message_seq"
            case realId = "real_id"
            case rawMessage = "raw_message"
            case font
            case postType = "post_type"
        }

        // 使用一个 enum 来动态区分 PrivateSender 或 GroupSender
        public enum Sender: Codable {
            case privateSender(PrivateSender)
            case groupSender(GroupSender)
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                // 根据父级的 message_type 来判断解码哪个 sender
                let topContainer = try decoder.container(keyedBy: CodingKeys.self)
                let messageType = try topContainer.decode(MessageType.self, forKey: .messageType)

                switch messageType {
                case .privateMessage:
                    let privateSender = try container.decode(PrivateSender.self)
                    self = .privateSender(privateSender)
                case .groupMessage:
                    let groupSender = try container.decode(GroupSender.self)
                    self = .groupSender(groupSender)
                }
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                switch self {
                case .privateSender(let sender):
                    try container.encode(sender, forKey: .sender)
                case .groupSender(let sender):
                    try container.encode(sender, forKey: .sender)
                }
            }
        }
    }

    /// (OneBot) 获取转发消息返回的参数结构
    public struct GetForwardMsg: Codable {
        public let messages: [GetMsg]
    }
    
    /// (OneBot) 发送点赞返回的参数结构
    public struct SendLike: Codable {}
    
    /// (OneBot) 设置群组踢人返回的参数结构
    public struct SetGroupKick: Codable {}
    
    /// (OneBot) 设置群组禁言返回的参数结构
    public struct SetGroupBan: Codable {}
    
    /// (OneBot) 设置群组全员禁言返回的参数结构
    public struct SetGroupWholeBan: Codable {}
    
    /// (OneBot) 设置群组管理员返回的参数结构
    public struct SetGroupAdmin: Codable {}
    
    /// (OneBot) 设置群名片返回的参数结构
    public struct SetGroupCard: Codable {}
    
    /// (OneBot) 设置群组名称返回的参数结构
    public struct SetGroupName: Codable {}
    
    /// (OneBot) 退出群组返回的参数结构
    public struct SetGroupLeave: Codable {}
    
    /// (OneBot) 设置群组专属头衔返回的参数结构
    public struct SetGroupSpecialTitle: Codable {}
    
    /// (OneBot) 处理好友添加请求返回的参数结构
    public struct SetFriendAddRequest: Codable {}
    
    /// (OneBot) 处理群组添加请求返回的参数结构
    public struct SetGroupAddRequest: Codable {}
    
    /// (OneBot) 获取登录信息返回的参数结构
    public struct GetLoginInfo: Codable {
        public let userId: Int
        public let nickname: String
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case nickname
        }
    }
    
    /// (OneBot) 获取陌生人信息返回的参数结构
    public struct GetStrangerInfo: Codable {
        public let userId: Int
        public let uid: String
        public let nickname: String
        public let age: Int
        public let qid: String
        public let qqLevel: Int
        public let sex: String // 'female' | 'male' | 'unknown'
        public let longNick: String
        public let regTime: Int
        public let isVip: Bool
        public let isYearsVip: Bool
        public let vipLevel: Int
        public let remark: String
        public let status: Int
        public let loginDays: Int
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case uid
            case nickname
            case age
            case qid
            case qqLevel
            case sex
            case longNick = "long_nick"
            case regTime = "reg_time"
            case isVip = "is_vip"
            case isYearsVip = "is_years_vip"
            case vipLevel = "vip_level"
            case remark
            case status
            case loginDays = "login_days"
        }
    }
    
    /// (OneBot) 获取好友列表返回的参数结构
    public struct GetFriendListItem: Codable {
        public let qid: String
        public let longNick: String
        public let birthdayYear: Int
        public let birthdayMonth: Int
        public let birthdayDay: Int
        public let age: Int
        public let sex: String
        public let eMail: String
        public let phoneNum: String
        public let categoryId: Int
        public let richTime: Int
        public let richBuffer: [String: Int]
        public let uid: String
        public let uin: String
        public let nick: String
        public let remark: String
        public let userId: Int
        public let nickname: String
        public let level: Int
        
        enum CodingKeys: String, CodingKey {
            case qid
            case longNick
            case birthdayYear = "birthday_year"
            case birthdayMonth = "birthday_month"
            case birthdayDay = "birthday_day"
            case age
            case sex
            case eMail
            case phoneNum
            case categoryId
            case richTime
            case richBuffer
            case uid
            case uin
            case nick
            case remark
            case userId = "user_id"
            case nickname
            case level
        }
    }
    
    /// (OneBot) 获取群组信息返回的参数结构
    public struct GetGroupInfo: Codable {
        public let groupId: Int
        public let groupName: String
        public let memberCount: Int
        public let maxMemberCount: Int
        
        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case groupName = "group_name"
            case memberCount = "member_count"
            case maxMemberCount = "max_member_count"
        }
    }
    
    /// (OneBot) 获取群组列表返回的参数结构
    public typealias GetGroupList = [GetGroupInfo]
    
    /// (OneBot) 获取群组成员信息返回的参数结构
    public struct GetGroupMemberInfo: Codable {
        public let groupId: Int
        public let userId: Int
        public let nickname: String
        public let card: String
        public let sex: String // 'unknown' | 'male' | 'female'
        public let age: Int
        public let area: String
        public let level: Int
        public let qqLevel: Int
        public let joinTime: Int
        public let lastSentTime: Int
        public let titleExpireTime: Int
        public let unfriendly: Bool
        public let cardChangeable: Bool
        public let isRobot: Bool
        public let shutUpTimestamp: Int
        public let role: String // 'owner' | 'admin' | 'member'
        public let title: String
        
        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case userId = "user_id"
            case nickname
            case card
            case sex
            case age
            case area
            case level
            case qqLevel = "qq_level"
            case joinTime = "join_time"
            case lastSentTime = "last_sent_time"
            case titleExpireTime = "title_expire_time"
            case unfriendly
            case cardChangeable = "card_changeable"
            case isRobot = "is_robot"
            case shutUpTimestamp = "shut_up_timestamp"
            case role
            case title
        }
    }
    
    /// (OneBot) 获取群组成员列表返回的参数结构
    public typealias GetGroupMemberList = [GetGroupInfo]
    
    /// (OneBot) 获取群组荣誉信息返回的参数结构
    public struct GetGroupHonorInfo: Codable {
        public struct HonorMember: Codable {
            public let userId: Int
            public let avatar: String
            public let nickname: String
            public let dayCount: Int
            public let description: String
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case avatar
                case nickname
                case dayCount = "day_count"
                case description
            }
        }
        
        public let groupId: String
        public let currentTalkative: HonorMember
        public let talkativeList: [HonorMember]
        public let performerList: [HonorMember]
        public let legendList: [HonorMember]
        public let emotionList: [HonorMember]
        public let strongNewbieList: [HonorMember]
        
        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case currentTalkative = "current_talkative"
            case talkativeList = "talkative_list"
            case performerList = "performer_list"
            case legendList = "legend_list"
            case emotionList = "emotion_list"
            case strongNewbieList = "strong_newbie_list"
        }
    }
    
    /// (OneBot) 获取 Cookies 返回的参数结构
    public struct GetCookies: Codable {
        public let cookies: String
        public let bkn: String
    }
    
    /// (OneBot) 获取 CSRF Token 返回的参数结构
    public struct GetCsrfToken: Codable {
        public let token: String
    }
    
    /// (OneBot) 获取凭证返回的参数结构
    public struct GetCredentials: Codable {
        public let cookies: String
        public let token: String
    }
    
    /// (OneBot) 获取录音返回的参数结构
    public struct GetRecord: Codable {
        public let file: String
        public let url: String
        public let fileSize: String
        public let fileName: String
        public let base64: String
        
        enum CodingKeys: String, CodingKey {
            case file
            case url
            case fileSize = "file_size"
            case fileName = "file_name"
            case base64
        }
    }
    
    /// (OneBot) 获取图片返回的参数结构
    public typealias GetImage = GetRecord
    
    /// (OneBot) 检查是否可以发送图片返回的参数结构
    public struct CanSendImage: Codable {
        public let yes: Bool
    }
    
    /// (OneBot) 检查是否可以发送录音返回的参数结构
    public struct CanSendRecord: Codable {
        public let yes: Bool
    }
    
    /// (OneBot) 获取状态返回的参数结构
    public struct GetStatus: Codable {
        public let online: Bool
        public let good: Bool
        public let stat: [String: JSON]
        
        enum CodingKeys: String, CodingKey {
            case online
            case good
            case stat
        }
    }
    
    /// (OneBot) 获取版本信息返回的参数结构
    public struct GetVersionInfo: Codable {
        public let appName: String
        public let protocolVersion: String
        public let appVersion: String
        
        enum CodingKeys: String, CodingKey {
            case appName = "app_name"
            case protocolVersion = "protocol_version"
            case appVersion = "app_version"
        }
    }
    
    /// (go-cqhttp) 设置 QQ 个人资料返回的参数结构
    public struct SetQQProfile: Codable {
        public let result: Int
        public let errMsg: String
    }
    
    /// (go-cqhttp) 获取在线客户端列表返回的参数结构
    public typealias GetOnlineClients = [Any]
    
    /// (go-cqhttp) 标记消息已读返回的参数结构
    public struct MarkMsgAsRead: Codable {}
    
    /// (go-cqhttp) 发送群转发消息返回的参数结构
    public typealias SendGroupForwardMsg = SendMsg
    
    /// (go-cqhttp) 发送私聊转发消息返回的参数结构
    public typealias SendPrivateForwardMsg = SendMsg
    
    /// (go-cqhttp) 获取群消息历史记录返回的参数结构
    public struct GetGroupMsgHistory: Codable {
        public let messages: [GetMsg]
    }
    
    /// (go-cqhttp) OCR 图片识别返回的参数结构
    public struct OCRImage: Codable {
        public struct Point: Codable {
            public let x: String
            public let y: String
        }
        
        public struct CharBox: Codable {
            public struct Box: Codable {
                public let pt1: Point
                public let pt2: Point
                public let pt3: Point
                public let pt4: Point
            }
            
            public let charText: String
            public let charBox: Box
        }
        
        public let text: String
        public let pt1: Point
        public let pt2: Point
        public let pt3: Point
        public let pt4: Point
        public let charBox: [CharBox]
        public let score: String
    }
    
    /// (go-cqhttp) 获取群系统消息返回的参数结构
    public struct GetGroupSystemMsg: Codable {
        public struct Request: Codable {
            public let requestId: Int
            public let invitorUin: Int
            public let invitorNick: String
            public let groupId: Int
            public let groupName: String
            public let checked: Bool
            public let actor: Int
            
            enum CodingKeys: String, CodingKey {
                case requestId = "request_id"
                case invitorUin = "invitor_uin"
                case invitorNick = "invitor_nick"
                case groupId = "group_id"
                case groupName = "group_name"
                case checked
                case actor
            }
        }
        
        public let invitedRequest: [Request]
        public let joinRequests: [Request]
        
        enum CodingKeys: String, CodingKey {
            case invitedRequest = "InvitedRequest"
            case joinRequests = "join_requests"
        }
    }
    
    /// (go-cqhttp) 获取群精华消息列表返回的参数结构
    public struct GetEssenceMsgList: Codable {
        public let msgSeq: Int
        public let msgRandom: Int
        public let senderId: Int
        public let senderNick: String
        public let operatorId: Int
        public let operatorNick: String
        public let messageId: Int
        public let operatorTime: Int
        public let content: [NCSendMessage] // This should be replaced with actual message content type
        
        enum CodingKeys: String, CodingKey {
            case msgSeq = "msg_seq"
            case msgRandom = "msg_random"
            case senderId = "sender_id"
            case senderNick = "sender_nick"
            case operatorId = "operator_id"
            case operatorNick = "operator_nick"
            case messageId = "message_id"
            case operatorTime = "operator_time"
            case content
        }
    }
    
    /// (go-cqhttp) 设置群头像返回的参数结构
    public struct SetGroupPortrait: Codable {
        public let result: Int
        public let errMsg: String
    }
    
    /// (go-cqhttp) 设置群精华消息返回的参数结构
    public struct SetEssenceMsg: Codable {
        public let errCode: Int
        public let errMsg: String
    }
    
    /// (go-cqhttp) 删除群精华消息返回的参数结构
    public typealias DeleteEssenceMsg = SetEssenceMsg
    
    /// (go-cqhttp) 发送群公告返回的参数结构
    public struct SendGroupNotice: Codable {}
    
    /// (go-cqhttp) 获取群公告返回的参数结构
    public struct GetGroupNotice: Codable {
        public struct Image: Codable {
            public let id: String
            public let height: String
            public let width: String
        }
        
        public struct Message: Codable {
            public let text: String
            public let image: [Image]
        }
        
        public let noticeId: String
        public let senderId: Int
        public let publishTime: Int
        public let message: Message
        
        enum CodingKeys: String, CodingKey {
            case noticeId = "notice_id"
            case senderId = "sender_id"
            case publishTime = "publish_time"
            case message
        }
    }
    
    /// (go-cqhttp) 上传群文件返回的参数结构
    public struct UploadGroupFile: Codable {}
    
    /// (go-cqhttp) 删除群文件返回的参数结构
    public struct DeleteGroupFile: Codable {
        public struct Result: Codable {
            public let retCode: Int
            public let retMsg: String
            public let clientWording: String
        }
        
        public struct TransGroupFileResult: Codable {
            public let result: Result
            public let successFileIdList: [String]
            public let failFileIdList: [String]
        }
        
        public let result: Int
        public let errMsg: String
        public let transGroupFileResult: TransGroupFileResult
    }
    
    /// (go-cqhttp) 创建群文件夹返回的参数结构
    public struct CreateGroupFileFolder: Codable {
        public struct Result: Codable {
            public let retCode: Int
            public let retMsg: String
            public let clientWording: String
        }
        
        public struct FolderInfo: Codable {
            public let folderId: String
            public let parentFolderId: String
            public let folderName: String
            public let createTime: Int
            public let modifyTime: Int
            public let createUin: String
            public let creatorName: String
            public let totalFileCount: Int
            public let modifyUin: String
            public let modifyName: String
            public let usedSpace: String
        }
        
        public struct GroupItem: Codable {
            public let peerId: String
            public let type: Int
            public let folderInfo: FolderInfo
            public let fileInfo: String?
        }
        
        public let result: Result
        public let groupItem: GroupItem
    }
    
    /// (go-cqhttp) 删除群文件夹返回的参数结构
    public struct DeleteGroupFolder: Codable {
        public let retCode: Int
        public let retMsg: String
        public let clientWording: String
    }
    
    /// (go-cqhttp) 获取群文件系统信息返回的参数结构
    public struct GetGroupFileSystemInfo: Codable {
        public let fileCount: Int
        public let limitCount: Int
        public let usedSpace: Int
        public let totalSpace: Int
        
        enum CodingKeys: String, CodingKey {
            case fileCount = "file_count"
            case limitCount = "limit_count"
            case usedSpace = "used_space"
            case totalSpace = "total_space"
        }
    }
    
    /// (go-cqhttp) 获取群根目录文件列表返回的参数结构
    public struct GetGroupRootFiles: Codable {
        public struct File: Codable {
            public let groupId: Int
            public let fileId: String
            public let fileName: String
            public let busid: Int
            public let size: Int
            public let uploadTime: Int
            public let deadTime: Int
            public let modifyTime: Int
            public let downloadTimes: Int
            public let uploader: Int
            public let uploaderName: String
            
            enum CodingKeys: String, CodingKey {
                case groupId = "group_id"
                case fileId = "file_id"
                case fileName = "file_name"
                case busid
                case size
                case uploadTime = "upload_time"
                case deadTime = "dead_time"
                case modifyTime = "modify_time"
                case downloadTimes = "download_times"
                case uploader
                case uploaderName = "uploader_name"
            }
        }
        
        public struct Folder: Codable {
            public let groupId: Int
            public let folderId: String
            public let folder: String
            public let folderName: String
            public let createTime: Int
            public let creator: Int
            public let creatorName: String
            public let totalFileCount: Int
            
            enum CodingKeys: String, CodingKey {
                case groupId = "group_id"
                case folderId = "folder_id"
                case folder
                case folderName = "folder_name"
                case createTime = "create_time"
                case creator
                case creatorName = "creator_name"
                case totalFileCount = "total_file_count"
            }
        }
        
        public let files: [File]
        public let folders: [Folder]
    }
    
    /// (go-cqhttp) 获取群文件列表返回的参数结构
    public typealias GetGroupFilesByFolder = GetGroupRootFiles
    
    /// (go-cqhttp) 获取群文件 URL 返回的参数结构
    public struct GetGroupFileUrl: Codable {
        public let url: String
    }
    
    /// (go-cqhttp) 上传私聊文件返回的参数结构
    public struct UploadPrivateFile: Codable {}
    
    /// (go-cqhttp) 下载文件返回的参数结构
    public struct DownloadFile: Codable {
        public let file: String
    }
    
    /// (NapCat) ArkShare 点对点分享返回的参数结构
    public struct ArkSharePeer: Codable {
        public let errCode: Int
        public let errMsg: String
        public let arkJson: String
    }
    
    /// (NapCat) ArkShare 群组分享返回的参数结构
    public typealias ArkShareGroup = String
    
    /// (NapCat) 获取机器人 UIN 范围返回的参数结构
    public struct GetRobotUinRange: Codable {
        public let minUin: String
        public let maxUin: String
    }
    
    /// (NapCat) 设置在线状态返回的参数结构
    public struct SetOnlineStatus: Codable {}
    
    /// (NapCat) 获取带分类的好友列表返回的参数结构
    public struct GetFriendsWithCategory: Codable {
        public let categoryId: Int
        public let categorySortId: Int
        public let categoryName: String
        public let categoryMbCount: Int
        public let onlineCount: Int
        public let buddyList: [GetFriendListItem]
    }
    
    /// (NapCat) 设置 QQ 头像返回的参数结构
    public struct SetQQAvatar: Codable {}
    
    /// (NapCat) 获取文件返回的参数结构
    public typealias GetFile = GetRecord
    
    /// (NapCat) 转发好友单条消息返回的参数结构
    public struct ForwardFriendSingleMsg: Codable {}
    
    /// (NapCat) 转发群组单条消息返回的参数结构
    public struct ForwardGroupSingleMsg: Codable {}
    
    /// (NapCat) 英文到中文翻译返回的参数结构
    public typealias TranslateEn2Zh = [String]
    
    /// (NapCat) 设置消息表情回应返回的参数结构
    public struct SetMsgEmojiLike: Codable {}
    
    /// (NapCat) 发送转发消息返回的参数结构
    public struct SendForwardMsg: Codable {
        public let messageId: Int
        public let resId: String
        
        enum CodingKeys: String, CodingKey {
            case messageId = "message_id"
            case resId = "res_id"
        }
    }
    
    /// (NapCat) 标记私聊消息已读返回的参数结构
    public struct MarkPrivateMsgAsRead: Codable {}
    
    /// (NapCat) 标记群组消息已读返回的参数结构
    public struct MarkGroupMsgAsRead: Codable {}
    
    /// (NapCat) 获取好友消息历史返回的参数结构
    public struct GetFriendMsgHistory: Codable {
        public let messages: [GetMsg]
    }
    
    /// (NapCat) 创建收藏返回的参数结构
    public struct CreateCollection: Codable {}
    
    /// (NapCat) 获取收藏列表返回的参数结构
    public struct GetCollectionList: Codable {}
    
    /// (NapCat) 设置个性签名返回的参数结构
    public struct SetSelfLongnick: Codable {
        public let result: Int
        public let errMsg: String
    }
    
    /// (NapCat) 获取最近联系人返回的参数结构
    public struct GetRecentContact: Codable {
        public let lastestMsg: GetMsg
        public let peerUin: String
        public let remark: String
        public let msgTime: String
        public let chatType: Int
        public let msgId: String
        public let sendNickName: String
        public let sendMemberName: String
        public let peerName: String
    }
    
    /// (NapCat) 标记所有消息为已读返回的参数结构
    public struct MarkAllAsRead: Codable {}
    
    /// (NapCat) 获取点赞资料返回的参数结构
    public struct GetProfileLike: Codable {
        public let uid: String
        public let src: Int
        public let latestTime: Int
        public let count: Int
        public let giftCount: Int
        public let customId: Int
        public let lastCharged: Int
        public let bAvailableCnt: Int
        public let bTodayVotedCnt: Int
        public let nick: String
        public let gender: Int
        public let age: Int
        public let isFriend: Bool
        public let isvip: Bool
        public let isSvip: Bool
        public let uin: Int
    }
    
    /// (NapCat) 获取自定义表情返回的参数结构
    public typealias FetchCustomFace = [String]
    
    /// (NapCat) 获取表情点赞返回的参数结构
    public struct FetchEmojiLike: Codable {
        public struct EmojiLike: Codable {
            public let tinyId: String
            public let nickName: String
            public let headUrl: String
        }
        
        public let result: Int
        public let errMsg: String
        public let emojiLikesList: [EmojiLike]
        public let cookie: String
        public let isLastPage: Bool
        public let isFirstPage: Bool
    }
    
    /// (NapCat) 设置输入状态返回的参数结构
    public struct SetInputStatus: Codable {
        public let result: Int
        public let errMsg: String
    }
    
    /// (NapCat) 获取扩展群信息返回的参数结构
    public struct GetGroupInfoEx: Codable {
        public struct GroupOwner: Codable {
            public let memberUin: String
            public let memberUid: String
            public let memberQid: String
        }
        
        public struct GuildIds: Codable {
            public let guildIds: [String]
        }
        
        public struct FlameData: Codable {
            public let switchState: Int
            public let state: Int
            public let dayNums: [String]
            public let version: Int
            public let updateTime: String
            public let isDisplayDayNum: Bool
        }
        
        public struct ExtInfo: Codable {
            public let groupInfoExtSeq: Int
            public let reserve: Int
            public let luckyWordId: String
            public let lightCharNum: Int
            public let luckyWord: String
            public let starId: Int
            public let essentialMsgSwitch: Int
            public let todoSeq: Int
            public let blacklistExpireTime: Int
            public let isLimitGroupRtc: Int
            public let companyId: Int
            public let hasGroupCustomPortrait: Int
            public let bindGuildId: String
            public let groupOwnerId: GroupOwner
            public let essentialMsgPrivilege: Int
            public let msgEventSeq: String
            public let inviteRobotSwitch: Int
            public let gangUpId: String
            public let qqMusicMedalSwitch: Int
            public let showPlayTogetherSwitch: Int
            public let groupFlagPro1: String
            public let groupBindGuildIds: GuildIds
            public let viewedMsgDisappearTime: String
            public let groupExtFlameData: FlameData
            public let groupBindGuildSwitch: Int
            public let groupAioBindGuildId: String
            public let groupExcludeGuildIds: GuildIds
            public let fullGroupExpansionSwitch: Int
            public let fullGroupExpansionSeq: String
            public let inviteRobotMemberSwitch: Int
            public let inviteRobotMemberExamine: Int
            public let groupSquareSwitch: Int
        }
        
        public let groupCode: String
        public let resultCode: Int
        public let extInfo: ExtInfo
    }
    
    /// (NapCat) 获取群忽略添加请求返回的参数结构
    public struct GetGroupIgnoreAddRequest: Codable {
        public struct Request: Codable {
            public let requestId: Int
            public let requesterUin: Int
            public let requesterNick: String
            public let groupId: Int
            public let groupName: String
            public let checked: Bool
            public let actor: Int
            
            enum CodingKeys: String, CodingKey {
                case requestId = "request_id"
                case requesterUin = "requester_uin"
                case requesterNick = "requester_nick"
                case groupId = "group_id"
                case groupName = "group_name"
                case checked
                case actor
            }
        }
        
        public let joinRequests: [Request]
        
        enum CodingKeys: String, CodingKey {
            case joinRequests = "join_requests"
        }
    }
    
    /// (NapCat) 删除群公告返回的参数结构
    public struct DelGroupNotice: Codable {}
    
    /// (NapCat) 获取用户资料点赞返回的参数结构
    public typealias FetchUserProfileLike = String
    
    /// (NapCat) 好友戳一戳返回的参数结构
    public struct FriendPoke: Codable {}
    
    /// (NapCat) 群组戳一戳返回的参数结构
    public struct GroupPoke: Codable {}
    
    /// (NapCat) 获取数据包状态返回的参数结构
    public struct NCGetPacketStatus: Codable {}
    
    /// (NapCat) 获取用户状态返回的参数结构
    public struct NCGetUserStatus: Codable {
        public let status: Int
        public let extStatus: Int
        
        enum CodingKeys: String, CodingKey {
            case status
            case extStatus = "ext_status"
        }
    }
    
    /// (NapCat) 获取 RKey 返回的参数结构
    public struct NCGetRKey: Codable {
        public let rkey: String
        public let time: Int
        public let type: Int
    }
    
    /// (NapCat) 获取群禁言列表返回的参数结构
    public struct GetGroupShutList: Codable {}
}
