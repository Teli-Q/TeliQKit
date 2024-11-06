//
//  NCMessageBuilder.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/05.
//

import Foundation


/// 消息构建器，用于构建消息结构体
public enum NCMessageBuilder {
    
    // MARK: - Text
    /// 发送文字消息
    /// - Parameter text: 要发送的文字
    /// - Returns: 文字消息结构体
    public static func text(_ text: String) -> NCSendMessage {
        .text(TextMessage(data: .init(text: text)))
    }
    
    // MARK: - At
    /// @某人
    /// - Parameter qq: 要@的QQ号，可以是具体QQ号或"all"来@全体成员
    /// - Returns: @消息结构体
    public static func at(_ qq: String) -> NCSendMessage {
        .at(AtMessage(data: .init(qq: qq)))
    }
    
    /// @某人
    /// - Parameter qq: 要@的QQ号
    /// - Returns: @消息结构体
    public static func at(_ qq: Int) -> NCSendMessage {
        at(String(qq))
    }
    
    // MARK: - Reply
    /// 回复消息
    /// - Parameter id: 回复的消息id
    /// - Returns: 回复消息结构体
    public static func reply(_ id: String) -> NCSendMessage {
        .reply(ReplyMessage(data: .init(id: id)))
    }
    
    /// 回复消息
    /// - Parameter id: 回复的消息id
    /// - Returns: 回复消息结构体
    public static func reply(_ id: Int) -> NCSendMessage {
        reply(String(id))
    }
    
    // MARK: - Face
    /// 发送QQ表情
    /// - Parameter id: QQ表情ID
    /// - Returns: QQ表情消息结构体
    public static func face(_ id: String) -> NCSendMessage {
        .face(FaceMessage(data: .init(id: id)))
    }
    
    /// 发送QQ表情
    /// - Parameter id: QQ表情ID
    /// - Returns: QQ表情消息结构体
    public static func face(_ id: Int) -> NCSendMessage {
        face(String(id))
    }
    
    // MARK: - MFace
    /// 发送QQ表情包
    /// - Parameters:
    ///   - emojiId: 表情id
    ///   - emojiPackageId: 表情包id
    ///   - key: 表情key(必要)
    ///   - summary: 表情简介(可选)
    /// - Returns: QQ表情包消息结构体
    public static func mface(
        emojiId: String,
        emojiPackageId: String,
        key: String,
        summary: String? = nil
    ) -> NCSendMessage {
        .mface(MFaceMessage(data: .init(
            emojiId: emojiId,
            emojiPackageId: emojiPackageId,
            key: key,
            summary: summary
        )))
    }
    
    // MARK: - Image
    /// 发送图片
    /// - Parameters:
    ///   - file: 图片文件路径、URL或Base64数据
    ///   - name: 图片名称(可选)
    ///   - summary: 图片简介(可选)
    ///   - subType: 图片类型(可选)
    /// - Returns: 图片消息结构体
    public static func image(
        _ file: String,
        name: String? = nil,
        summary: String? = nil,
        subType: String? = nil
    ) -> NCSendMessage {
        .image(SendImageMessage(data: .init(
            file: file,
            name: name,
            summary: summary,
            subType: subType
        )))
    }
    
    /// 发送图片(Data版本)
    /// - Parameters:
    ///   - data: 图片数据
    ///   - name: 图片名称(可选)
    ///   - summary: 图片简介(可选)
    ///   - subType: 图片类型(可选)
    /// - Returns: 图片消息结构体
    public static func image(
        data: Data,
        name: String? = nil,
        summary: String? = nil,
        subType: String? = nil
    ) -> NCSendMessage {
        image(
            "base64://\(data.base64EncodedString())",
            name: name,
            summary: summary,
            subType: subType
        )
    }
    
    // MARK: - File
    /// 发送文件
    /// - Parameters:
    ///   - file: 文件路径、URL或Base64数据
    ///   - name: 文件名称(可选)
    /// - Returns: 文件消息结构体
    public static func file(
        _ file: String,
        name: String? = nil
    ) -> NCSendMessage {
        .file(SendFileMessage(data: .init(
            file: file,
            name: name
        )))
    }
    
    /// 发送文件(Data版本)
    /// - Parameters:
    ///   - data: 文件数据
    ///   - name: 文件名称(可选)
    /// - Returns: 文件消息结构体
    public static func file(
        data: Data,
        name: String? = nil
    ) -> NCSendMessage {
        file(
            "base64://\(data.base64EncodedString())",
            name: name
        )
    }
    
    // MARK: - Video
    /// 发送视频
    /// - Parameters:
    ///   - file: 视频文件路径、URL或Base64数据
    ///   - name: 视频名称(可选)
    ///   - thumb: 视频预览图(可选)
    /// - Returns: 视频消息结构体
    public static func video(
        _ file: String,
        name: String? = nil,
        thumb: String? = nil
    ) -> NCSendMessage {
        .video(SendVideoMessage(data: .init(
            file: file,
            name: name,
            thumb: thumb
        )))
    }
    
    // MARK: - Record
    /// 发送语音
    /// - Parameters:
    ///   - file: 语音文件路径、URL或Base64数据
    ///   - name: 语音名称(可选)
    /// - Returns: 语音消息结构体
    public static func record(
        _ file: String,
        name: String? = nil
    ) -> NCSendMessage {
        .record(SendRecordMessage(data: .init(
            file: file,
            name: name
        )))
    }
    
    // MARK: - JSON
    /// 发送JSON消息
    /// - Parameter data: JSON字符串
    /// - Returns: JSON消息结构体
    public static func json(_ data: String) -> NCSendMessage {
        .json(JSONMessage(data: .init(data: data)))
    }
    
    // MARK: - Dice & RPS
    /// 发送骰子魔法表情
    /// - Returns: 骰子消息结构体
    public static func dice() -> NCSendMessage {
        .dice(DiceMessageSend(data: .init()))
    }
    
    /// 发送猜拳魔法表情
    /// - Returns: 猜拳消息结构体
    public static func rps() -> NCSendMessage {
        .rps(RPSMessageSend(data: .init()))
    }
    
    // MARK: - Music
    /// 音乐平台类型
    public enum MusicPlatform: String {
        case qq = "qq"
        case netease = "163"
        case kugou = "kugou"
        case migu = "migu"
        case kuwo = "kuwo"
    }
    
    /// 发送音乐分享
    /// - Parameters:
    ///   - platform: 音乐平台
    ///   - id: 音乐ID
    /// - Returns: 音乐分享消息结构体
    public static func music(
        platform: MusicPlatform,
        id: String
    ) -> NCSendMessage {
        .music(MusicMessage(data: .platform(.init(
            type: platform.rawValue,
            id: id
        ))))
    }
    
    /// 发送自定义音乐分享
    /// - Parameters:
    ///   - url: 点击后跳转的URL
    ///   - audio: 音频URL
    ///   - title: 标题
    ///   - image: 图片URL(可选)
    ///   - singer: 歌手名(可选)
    /// - Returns: 自定义音乐分享消息结构体
    public static func customMusic(
        url: String,
        audio: String,
        title: String,
        image: String? = nil,
        singer: String? = nil
    ) -> NCSendMessage {
        .music(MusicMessage(data: .custom(.init(
            url: url,
            audio: audio,
            title: title,
            image: image,
            singer: singer
        ))))
    }
    
    // MARK: - Node
    /// 转发消息节点
    /// - Parameter id: 消息ID
    /// - Returns: 转发节点消息结构体
    public static func node(_ id: String) -> NCSendMessage {
        .node(NodeMessage(data: .id(id)))
    }
    
    /// 自定义转发消息节点
    /// - Parameter content: 消息内容数组
    /// - Returns: 自定义转发节点消息结构体
    public static func customNode(_ content: [NCSendMessage]) -> NCSendMessage {
        .node(NodeMessage(data: .content(content)))
    }
    
    // MARK: - Forward
    /// 转发消息
    /// - Parameter messageId: 消息ID
    /// - Returns: 转发消息结构体
    public static func forward(_ messageId: Int) -> NCSendMessage {
        .forward(ForwardMessage(data: .init(id: String(messageId), content: nil)))
    }
    
    // MARK: - Contact
    /// 发送联系人名片(仅限好友)
    /// - Parameter userId: 联系人QQ号
    /// - Returns: 联系人名片消息结构体
    public static func contact(_ userId: Int) -> NCSendMessage {
        .contact(ContactMessage(data: .init(id: String(userId))))
    }
}
