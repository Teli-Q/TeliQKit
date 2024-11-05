//
//  NCMessageReceive.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/05.
//

import Foundation

// MARK: - Receive Messages
public enum NCReceiveMessage: Codable {
    case text(TextMessage)
    case at(AtMessage)
    case image(ImageMessage)
    case file(FileMessage)
    case dice(DiceMessageReceive)
    case rps(RPSMessageReceive)
    case face(FaceMessage)
    case reply(ReplyMessage)
    case video(VideoMessage)
    case record(RecordMessage)
    case forward(ForwardMessage)
    case json(JSONMessage)
    case markdown(MarkdownMessage)
    
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
        case .image(let message):
            try container.encode("image", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .file(let message):
            try container.encode("file", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .dice(let message):
            try container.encode("dice", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .rps(let message):
            try container.encode("rps", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .face(let message):
            try container.encode("face", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .reply(let message):
            try container.encode("reply", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .video(let message):
            try container.encode("video", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .record(let message):
            try container.encode("record", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .forward(let message):
            try container.encode("forward", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .json(let message):
            try container.encode("json", forKey: .type)
            try container.encode(message.data, forKey: .data)
        case .markdown(let message):
            try container.encode("markdown", forKey: .type)
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
        case "image":
            let data = try container.decode(ImageData.self, forKey: .data)
            self = .image(ImageMessage(data: data))
        case "file":
            let data = try container.decode(FileData.self, forKey: .data)
            self = .file(FileMessage(data: data))
        case "dice":
            let data = try container.decode(DiceMessageReceive.DiceData.self, forKey: .data)
            self = .dice(DiceMessageReceive(data: data))
        case "rps":
            let data = try container.decode(RPSMessageReceive.RPSData.self, forKey: .data)
            self = .rps(RPSMessageReceive(data: data))
        case "face":
            let data = try container.decode(FaceMessage.FaceData.self, forKey: .data)
            self = .face(FaceMessage(data: data))
        case "reply":
            let data = try container.decode(ReplyMessage.ReplyData.self, forKey: .data)
            self = .reply(ReplyMessage(data: data))
        case "video":
            let data = try container.decode(FileData.self, forKey: .data)
            self = .video(VideoMessage(data: data))
        case "record":
            let data = try container.decode(FileData.self, forKey: .data)
            self = .record(RecordMessage(data: data))
        case "forward":
            let data = try container.decode(ForwardMessage.ForwardData.self, forKey: .data)
            self = .forward(ForwardMessage(data: data))
        case "json":
            let data = try container.decode(JSONMessage.JSONData.self, forKey: .data)
            self = .json(JSONMessage(data: data))
        case "markdown":
            let data = try container.decode(MarkdownMessage.MarkdownData.self, forKey: .data)
            self = .markdown(MarkdownMessage(data: data))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type,
                in: container,
                debugDescription: "Unknown message type: \(type)")
        }
    }
}
