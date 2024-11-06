//
//  NCMessageSend.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/05.
//

import Foundation

/// 发送消息类型
public enum NCSendMessage: Codable {
    case text(TextMessage)
    case at(AtMessage)
    case reply(ReplyMessage)
    case face(FaceMessage)
    case mface(MFaceMessage)
    case image(SendImageMessage)
    case file(SendFileMessage)
    case video(SendVideoMessage)
    case record(SendRecordMessage)
    case json(JSONMessage)
    case dice(DiceMessageSend)
    case rps(RPSMessageSend)
    case music(MusicMessage)
    case node(NodeMessage)
    case forward(ForwardMessage)
    case contact(ContactMessage)
    
    private enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    // 添加编码实现
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .text(let message):
            try container.encode("text", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .at(let message):
            try container.encode("at", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .reply(let message):
            try container.encode("reply", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .face(let message):
            try container.encode("face", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .mface(let message):
            try container.encode("mface", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .image(let message):
            try container.encode("image", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .file(let message):
            try container.encode("file", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .video(let message):
            try container.encode("video", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .record(let message):
            try container.encode("record", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .json(let message):
            try container.encode("json", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .dice(let message):
            try container.encode("dice", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .rps(let message):
            try container.encode("rps", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .music(let message):
            try container.encode("music", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .node(let message):
            try container.encode("node", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .forward(let message):
            try container.encode("forward", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .contact(let message):
            try container.encode("contact", forKey: .type)
            try container.encode(message.data, forKey: .data)
        }
    }
    
    // 添加解码实现
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "text":
            let data = try container.decode(TextMessage.TextData.self, forKey: .data)
            self = .text(TextMessage(data: data))
        case "at":
            let data = try container.decode(AtMessage.AtData.self, forKey: .data)
            self = .at(AtMessage(data: data))
        case "reply":
            let data = try container.decode(ReplyMessage.ReplyData.self, forKey: .data)
            self = .reply(ReplyMessage(data: data))
        case "face":
            let data = try container.decode(FaceMessage.FaceData.self, forKey: .data)
            self = .face(FaceMessage(data: data))
        case "mface":
            let data = try container.decode(MFaceMessage.MFaceData.self, forKey: .data)
            self = .mface(MFaceMessage(data: data))
        case "image":
            let data = try container.decode(SendImageMessage.SendImageData.self, forKey: .data)
            self = .image(SendImageMessage(data: data))
        case "file":
            let data = try container.decode(SendFileMessage.SendFileData.self, forKey: .data)
            self = .file(SendFileMessage(data: data))
        case "video":
            let data = try container.decode(SendVideoMessage.SendVideoData.self, forKey: .data)
            self = .video(SendVideoMessage(data: data))
        case "record":
            let data = try container.decode(SendRecordMessage.SendRecordData.self, forKey: .data)
            self = .record(SendRecordMessage(data: data))
        case "json":
            let data = try container.decode(JSONMessage.JSONData.self, forKey: .data)
            self = .json(JSONMessage(data: data))
        case "dice":
            let data = try container.decode(DiceMessageSend.DiceData.self, forKey: .data)
            self = .dice(DiceMessageSend(data: data))
        case "rps":
            let data = try container.decode(RPSMessageSend.RPSData.self, forKey: .data)
            self = .rps(RPSMessageSend(data: data))
        case "music":
            let data = try container.decode(MusicMessage.MusicData.self, forKey: .data)
            self = .music(MusicMessage(data: data))
        case "node":
            let data = try container.decode(NodeMessage.NodeData.self, forKey: .data)
            self = .node(NodeMessage(data: data))
        case "forward":
            let data = try container.decode(ForwardMessage.ForwardData.self, forKey: .data)
            self = .forward(ForwardMessage(data: data))
        case "contact":
            let data = try container.decode(ContactMessage.ContactData.self, forKey: .data)
            self = .contact(ContactMessage(data: data))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type,
                in: container,
                debugDescription: "Unknown message type: \(type)")
        }
    }
}
