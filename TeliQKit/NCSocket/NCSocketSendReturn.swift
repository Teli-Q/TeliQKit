//
//  NCSocketSendReturn.swift
//  TeliQKit
//
//  Created by Wibus on 2024/11/5.
//

/// Socket通信返回数据的结构体集合
public struct NCSocketSendReturn: Codable {
    /// 消息发送后的返回数据结构
    public struct SendMsgReturn: Codable {
        /// 消息ID
        public let messageId: Int

        enum CodingKeys: String, CodingKey {
            
            case messageId = "message_id"
        }
    }

    /// 获取消息的返回数据结构
    public struct GetMsgReturn: Codable {
        /// 消息类型
        public let messageType: String
        /// 机器人QQ号
        public let selfId: Int
        /// 发送者QQ号
        public let userId: Int
        /// 发送时间戳
        public let time: Int
        /// 消息ID
        public let messageId: Int
        /// 消息序号
        public let messageSeq: Int
        /// 真实消息ID
        public let realId: Int
        /// 原始消息内容
        public let rawMessage: String
        /// 字体
        public let font: Int
        /// 上报类型
        public let postType: PostType
        /// 发送者信息
        public let sender: Sender
        /// 消息子类型
        public let subType: String
        /// 群号(如果是群消息)
        public let groupId: Int?

        enum CodingKeys: String, CodingKey {
            case messageType = "message_type"
            case selfId = "self_id"
            case userId = "user_id"
            case time
            case messageId = "message_id"
            case messageSeq = "message_seq"
            case realId = "real_id"
            case rawMessage = "raw_message"
            case font
            case postType = "post_type"
            case sender
            case subType = "sub_type"
            case groupId = "group_id"
        }

        /// 消息上报类型枚举
        public enum PostType: String, Codable {
            /// 接收消息
            case message
            /// 发送消息
            case messageSent = "message_sent"
        }

        /// 发送者信息结构
        public struct Sender: Codable {
            /// 发送者QQ号
            public let userId: Int
            /// 发送者昵称
            public let nickname: String
            /// 群名片/备注
            public let card: String
            /// 群内角色
            public let role: Role?

            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case nickname
                case card
                case role
            }

            /// 群成员角色枚举
            public enum Role: String, Codable {
                /// 群主
                case owner
                /// 管理员
                case admin
                /// 普通成员
                case member
            }
        }
    }

    /// 获取转发消息的返回数据结构
    public struct GetForwardMsgReturn: Codable {
        /// 转发的消息列表
        public let messages: [GetMsgReturn]
    }

    /// 获取登录信息的返回数据结构
    public struct GetLoginInfoReturn: Codable {
        /// 当前登录账号的QQ号
        public let userId: Int
        /// 当前登录账号的昵称
        public let nickname: String

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case nickname
        }
    }

    /// 获取陌生人信息的返回数据结构
    public struct GetStrangerInfoReturn: Codable {
        /// QQ号
        public let userId: Int
        /// 用户唯一标识
        public let uid: String
        /// 昵称
        public let nickname: String
        /// 年龄
        public let age: Int
        /// QQ的qid
        public let qid: String
        /// QQ等级
        public let qqLevel: Int
        /// 性别
        public let sex: Gender
        /// 个性签名
        public let longNick: String
        /// 注册时间戳
        public let regTime: Int
        /// 是否是QQ会员
        public let isVip: Bool
        /// 是否是年费QQ会员
        public let isYearsVip: Bool
        /// QQ会员等级
        public let vipLevel: Int
        /// 备注名
        public let remark: String
        /// 在线状态
        public let status: Int
        /// 登录天数
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

        /// 性别枚举
        public enum Gender: String, Codable {
            /// 女性
            case female
            /// 男性
            case male
            /// 未知性别
            case unknown
        }
    }

    /// 好友信息的数据结构
    public struct FriendInfo: Codable {
        /// QQ的qid
        public let qid: String
        /// 个性签名
        public let longNick: String
        /// 生日年份
        public let birthdayYear: Int
        /// 生日月份
        public let birthdayMonth: Int
        /// 生日日期
        public let birthdayDay: Int
        /// 年龄
        public let age: Int
        /// 性别
        public let sex: String
        /// 邮箱地址
        public let email: String
        /// 手机号码
        public let phoneNum: String
        /// 好友分组ID
        public let categoryId: Int
        /// 财富等级更新时间
        public let richTime: Int
        /// 财富相关信息
        public let richBuffer: [String: Int]
        /// 用户唯一标识
        public let uid: String
        /// QQ号的字符串形式
        public let uin: String
        /// 昵称简写
        public let nick: String
        /// 备注名
        public let remark: String
        /// QQ号
        public let userId: Int
        /// 昵称
        public let nickname: String
        /// QQ等级
        public let level: Int

        enum CodingKeys: String, CodingKey {
            case qid
            case longNick
            case birthdayYear = "birthday_year"
            case birthdayMonth = "birthday_month"
            case birthdayDay = "birthday_day"
            case age
            case sex
            case email = "eMail"
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

    /// 群信息的数据结构
    public struct GroupInfo: Codable {
        /// 群号
        public let groupId: Int
        /// 群名称
        public let groupName: String
        /// 当前成员数
        public let memberCount: Int
        /// 最大成员数限制
        public let maxMemberCount: Int

        enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case groupName = "group_name"
            case memberCount = "member_count"
            case maxMemberCount = "max_member_count"
        }
    }

    /// 群成员信息返回结构
    public struct GroupMemberInfo: Codable {
        /// 群号
        public let groupId: Int
        /// 成员QQ号
        public let userId: Int
        /// 成员昵称
        public let nickname: String
        /// 群名片/备注
        public let card: String
        /// 性别
        public let sex: Gender
        /// 年龄
        public let age: Int
        /// 地区
        public let area: String
        /// 群等级
        public let level: Int
        /// QQ等级
        public let qqLevel: Int
        /// 加群时间戳
        public let joinTime: Int
        /// 最后发言时间戳
        public let lastSentTime: Int
        /// 专属头衔过期时间戳
        public let titleExpireTime: Int
        /// 是否不良记录成员
        public let unfriendly: Bool
        /// 是否允许修改名片
        public let cardChangeable: Bool
        /// 是否机器人
        public let isRobot: Bool
        /// 禁言到期时间
        public let shutUpTimestamp: Int
        /// 成员角色
        public let role: Role
        /// 专属头衔
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

        /// 性别枚举
        public enum Gender: String, Codable {
            case unknown
            case male
            case female
        }

        /// 角色枚举
        public enum Role: String, Codable {
            case owner
            case admin
            case member
        }
    }

    /// 群荣誉信息返回结构
    public struct GroupHonorInfoReturn: Codable {
        /// 群号
        public let groupId: String
        /// 当前龙王信息
        public let currentTalkative: TalkativeInfo?
        /// 历史龙王列表
        public let talkativeList: [HonorMember]
        /// 群聊之火列表
        public let performerList: [HonorMember]
        /// 群聊传说列表
        public let legendList: [HonorMember]
        /// 群聊情话列表
        public let emotionList: [HonorMember]
        /// 群聊新星列表
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

        /// 龙王信息结构
        public struct TalkativeInfo: Codable {
            /// 用户QQ号
            public let userId: Int
            /// 头像URL
            public let avatar: String
            /// 昵称
            public let nickname: String
            /// 持续天数
            public let dayCount: Int
            /// 描述
            public let description: String

            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case avatar
                case nickname
                case dayCount = "day_count"
                case description
            }
        }

        /// 荣誉成员信息
        public struct HonorMember: Codable {
            /// 用户QQ号
            public let userId: Int
            /// 头像URL
            public let avatar: String
            /// 描述
            public let description: String
            /// 持续天数
            public let dayCount: Int
            /// 昵称
            public let nickname: String

            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case avatar
                case description
                case dayCount = "day_count"
                case nickname
            }
        }
    }

    /// 文件系统信息返回结构
    public struct GroupFileSystemInfo: Codable {
        /// 文件总数
        public let fileCount: Int
        /// 文件数量上限
        public let limitCount: Int
        /// 已使用空间（字节）
        public let usedSpace: Int
        /// 总空间（字节）
        public let totalSpace: Int

        enum CodingKeys: String, CodingKey {
            case fileCount = "file_count"
            case limitCount = "limit_count"
            case usedSpace = "used_space"
            case totalSpace = "total_space"
        }
    }

    /// 群文件信息返回结构
    public struct GroupFileInfo: Codable {
        /// 文件列表
        public let files: [FileInfo]
        /// 文件夹列表
        public let folders: [FolderInfo]

        /// 文件信息
        public struct FileInfo: Codable {
            /// 群号
            public let groupId: Int
            /// 文件ID
            public let fileId: String
            /// 文件名
            public let fileName: String
            /// 业务ID
            public let busid: Int
            /// 文件大小
            public let size: Int
            /// 上传时间
            public let uploadTime: Int
            /// 过期时间
            public let deadTime: Int
            /// 修改时间
            public let modifyTime: Int
            /// 下载次数
            public let downloadTimes: Int
            /// 上传者
            public let uploader: Int
            /// 上传者名字
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

        /// 文件夹信息
        public struct FolderInfo: Codable {
            /// 群号
            public let groupId: Int
            /// 文件夹ID
            public let folderId: String
            /// 文件夹名
            public let folderName: String
            /// 创建时间
            public let createTime: Int
            /// 创建者
            public let creator: Int
            /// 创建者名字
            public let creatorName: String
            /// 子文件数量
            public let totalFileCount: Int

            enum CodingKeys: String, CodingKey {
                case groupId = "group_id"
                case folderId = "folder_id"
                case folderName = "folder_name"
                case createTime = "create_time"
                case creator
                case creatorName = "creator_name"
                case totalFileCount = "total_file_count"
            }
        }
    }

    /// OCR识别结果返回结构
    public struct OCRImageReturn: Codable {
        /// 识别出的文本结果数组
        public let results: [OCRResult]

        /// 单个OCR识别结果
        public struct OCRResult: Codable {
            /// 识别出的文本
            public let text: String
            /// 文本框左上角坐标
            public let pt1: Point
            /// 文本框右上角坐标
            public let pt2: Point
            /// 文本框右下角坐标
            public let pt3: Point
            /// 文本框左下角坐标
            public let pt4: Point
            /// 文字置信度
            public let score: String
            /// 字符级别的识别结果
            public let charBox: [CharBoxInfo]

            /// 坐标点结构
            public struct Point: Codable {
                public let x: String
                public let y: String
            }

            /// 字符级别的识别信息
            public struct CharBoxInfo: Codable {
                /// 识别出的字符
                public let charText: String
                /// 字符的位置信息
                public let charBox: CharPosition

                /// 字符位置信息
                public struct CharPosition: Codable {
                    public let pt1: Point
                    public let pt2: Point
                    public let pt3: Point
                    public let pt4: Point
                }
            }
        }
    }

    /// 群系统消息返回结构
    public struct GroupSystemMsgReturn: Codable {
        /// 邀请请求列表
        public let invitedRequests: [SystemRequest]
        /// 加群请求列表
        public let joinRequests: [SystemRequest]

        enum CodingKeys: String, CodingKey {
            case invitedRequests = "InvitedRequest"
            case joinRequests = "join_requests"
        }

        /// 系统请求信息
        public struct SystemRequest: Codable {
            /// 请求ID
            public let requestId: Int
            /// 邀请者QQ号
            public let invitorUin: Int
            /// 邀请者昵称
            public let invitorNick: String
            /// 群号
            public let groupId: Int
            /// 群名
            public let groupName: String
            /// 是否已经被处理
            public let checked: Bool
            /// 处理者QQ号
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
    }

    /// 精华消息列表返回结构
    public struct EssenceMsgListReturn: Codable {
        /// 消息列表
        public let messages: [EssenceMsg]

        /// 精华消息信息
        public struct EssenceMsg: Codable {
            /// 消息序号
            public let msgSeq: Int
            /// 消息随机数
            public let msgRandom: Int
            /// 发送者QQ号
            public let senderId: Int
            /// 发送者昵称
            public let senderNick: String
            /// 操作者QQ号
            public let operatorId: Int
            /// 操作者昵称
            public let operatorNick: String
            /// 消息ID
            public let messageId: Int
            /// 操作时间
            public let operatorTime: Int
            /// 消息内容
            public let content: [NCReceiveMessage]
            
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
    }

    /// 群公告返回结构
    public struct GroupNoticeReturn: Codable {
        /// 公告列表
        public let notices: [Notice]

        /// 单条公告信息
        public struct Notice: Codable {
            /// 公告ID
            public let noticeId: String
            /// 发送者QQ号
            public let senderId: Int
            /// 发布时间
            public let publishTime: Int
            /// 公告内容
            public let message: NoticeMessage

            enum CodingKeys: String, CodingKey {
                case noticeId = "notice_id"
                case senderId = "sender_id"
                case publishTime = "publish_time"
                case message
            }

            /// 公告内容结构
            public struct NoticeMessage: Codable {
                /// 文本内容
                public let text: String
                /// 图片列表
                public let images: [NoticeImage]

                /// 公告图片信息
                public struct NoticeImage: Codable {
                    /// 图片ID
                    public let id: String
                    /// 图片高度
                    public let height: String
                    /// 图片宽度
                    public let width: String
                }
            }
        }
    }

    /// 在线状态信息返回结构
    public struct OnlineStatusReturn: Codable {
        /// 是否在线
        public let online: Bool
        /// 是否良好
        public let good: Bool
        /// 统计信息
        public let stat: [String: String]

        enum CodingKeys: String, CodingKey {
            case online
            case good
            case stat
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            online = try container.decode(Bool.self, forKey: .online)
            good = try container.decode(Bool.self, forKey: .good)
            // stat 字段可能包含任意内容，这里使用空字典作为默认值
            stat = [:]
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(online, forKey: .online)
            try container.encode(good, forKey: .good)
            try container.encode(stat, forKey: .stat)
        }
    }

    /// 版本信息返回结构
    public struct VersionInfoReturn: Codable {
        /// 应用名称
        public let appName: String
        /// 协议版本
        public let protocolVersion: String
        /// 应用版本
        public let appVersion: String

        enum CodingKeys: String, CodingKey {
            case appName = "app_name"
            case protocolVersion = "protocol_version"
            case appVersion = "app_version"
        }
    }

    /// 凭证信息返回结构
    public struct CredentialsReturn: Codable {
        /// Cookies字符串
        public let cookies: String
        /// CSRF Token
        public let token: String
    }

    /// 最近联系人返回结构
    public struct RecentContactReturn: Codable {
        /// 最近联系人列表
        public let contacts: [RecentContact]

        /// 单个联系人信息
        public struct RecentContact: Codable {
            /// 最新消息
            public let latestMsg: GetMsgReturn
            /// 对方QQ号
            public let peerUin: String
            /// 备注名
            public let remark: String
            /// 消息时间
            public let msgTime: String
            /// 聊天类型（1私聊，2群聊）
            public let chatType: Int
            /// 消息ID
            public let msgId: String
            /// 发送者昵称
            public let sendNickName: String
            /// 发送者群名片
            public let sendMemberName: String
            /// 对方昵称
            public let peerName: String
            enum CodingKeys: String, CodingKey {
                case latestMsg = "lastestMsg"
                case peerUin
                case remark
                case msgTime
                case chatType
                case msgId
                case sendNickName
                case sendMemberName
                case peerName
            }
        }
    }

    /// 个人资料点赞信息返回结构
    public struct ProfileLikeReturn: Codable {
        /// QQ号的唯一标识
        public let uid: String
        /// 来源
        public let src: Int
        /// 最新时间
        public let latestTime: Int
        /// 点赞数
        public let count: Int
        /// 礼物数
        public let giftCount: Int
        /// 自定义ID
        public let customId: Int
        /// 最后充值时间
        public let lastCharged: Int
        /// 可用点赞数
        public let availableCnt: Int
        /// 今日已投票数
        public let todayVotedCnt: Int
        /// 昵称
        public let nick: String
        /// 性别（0未知，1男，2女）
        public let gender: Int
        /// 年龄
        public let age: Int
        /// 是否好友
        public let isFriend: Bool
        /// 是否VIP
        public let isVip: Bool
        /// 是否SVIP
        public let isSvip: Bool
        /// QQ号
        public let uin: Int
        enum CodingKeys: String, CodingKey {
            case uid
            case src
            case latestTime
            case count
            case giftCount
            case customId
            case lastCharged
            case availableCnt = "bAvailableCnt"
            case todayVotedCnt = "bTodayVotedCnt"
            case nick
            case gender
            case age
            case isFriend
            case isVip = "isvip"
            case isSvip
            case uin
        }
    }

    /// 表情点赞列表返回结构
    public struct EmojiLikeReturn: Codable {
        /// 结果码
        public let result: Int
        /// 错误信息
        public let errMsg: String
        /// 点赞列表
        public let emojiLikesList: [EmojiLiker]
        /// Cookie信息
        public let cookie: String
        /// 是否最后一页
        public let isLastPage: Bool
        /// 是否第一页
        public let isFirstPage: Bool
        enum CodingKeys: String, CodingKey {
            case result
            case errMsg
            case emojiLikesList
            case cookie
            case isLastPage
            case isFirstPage
        }

        /// 点赞用户信息
        public struct EmojiLiker: Codable {
            /// 用户标识
            public let tinyId: String
            /// 昵称
            public let nickName: String
            /// 头像URL
            public let headUrl: String
        }
    }

    /// 群扩展信息返回结构
    public struct GroupInfoExReturn: Codable {
        /// 群号
        public let groupCode: String
        /// 结果码
        public let resultCode: Int
        /// 扩展信息
        public let extInfo: GroupExtInfo
        /// 群扩展信息
        public struct GroupExtInfo: Codable {
            /// 群信息扩展序号
            public let groupInfoExtSeq: Int
            /// 保留字段
            public let reserve: Int
            /// 幸运字符ID
            public let luckyWordId: String
            /// 炫彩字符数量
            public let lightCharNum: Int
            /// 幸运字符
            public let luckyWord: String
            /// 星标ID
            public let starId: Int
            /// 精华消息开关
            public let essentialMsgSwitch: Int
            /// TODO序号
            public let todoSeq: Int
            /// 黑名单过期时间
            public let blacklistExpireTime: Int
            /// 是否限制群RTC
            public let isLimitGroupRtc: Int
            /// 公司ID
            public let companyId: Int
            /// 是否有群自定义头像
            public let hasGroupCustomPortrait: Int
            /// 绑定的频道ID
            public let bindGuildId: String
            /// 群主信息
            public let groupOwnerId: GroupOwner
            /// 精华消息权限
            public let essentialMsgPrivilege: Int
            /// 消息事件序号
            public let msgEventSeq: String
            /// 群主信息结构
            public struct GroupOwner: Codable {
                /// 成员QQ号
                public let memberUin: String
                /// 成员UID
                public let memberUid: String
                /// 成员QID
                public let memberQid: String
            }
        }
    }
}
