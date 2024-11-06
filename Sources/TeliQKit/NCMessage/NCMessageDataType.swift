//
//  NCMessageDataType.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/05.
//

import Foundation

// MARK: - Common Data Types
public struct ImageData: Codable {
    let summary: String?
    let file: String
    let subType: String?
    let fileId: String?
    let url: String?
    let path: String?
    let fileSize: String?
    let fileUnique: String?
    
    enum CodingKeys: String, CodingKey {
        case summary
        case file
        case subType = "sub_type"
        case fileId = "file_id"
        case url
        case path
        case fileSize = "file_size"
        case fileUnique = "file_unique"
    }
}

public struct FileData: Codable {
    let file: String
    let path: String?
    let url: String?
    let fileId: String?
    let fileSize: String?
    let fileUnique: String?
    
    enum CodingKeys: String, CodingKey {
        case file
        case path
        case url
        case fileId = "file_id"
        case fileSize = "file_size"
        case fileUnique = "file_unique"
    }
}



public struct SendFileMessage: MessageType {
    var type = "file"
    let data: SendFileData
    
    public struct SendFileData: Codable {
        let file: String
        let name: String?
    }
}

public struct SendVideoMessage: MessageType {
    var type = "video"
    let data: SendVideoData
    
    public struct SendVideoData: Codable {
        let file: String
        let name: String?
        let thumb: String?
    }
}

public struct SendRecordMessage: MessageType {
    var type = "record"
    let data: SendRecordData
    
    public struct SendRecordData: Codable {
        let file: String
        let name: String?
    }
}

// MARK: - Message public structs
public struct TextMessage: MessageType {
    var type = "text"
    let data: TextData
    
    public struct TextData: Codable {
        let text: String
    }
}

public struct AtMessage: MessageType {
    var type = "at"
    let data: AtData
    
    public struct AtData: Codable {
        let qq: String // "all" 或 QQ号
    }
}

public struct ImageMessage: MessageType {
    var type = "image"
    let data: ImageData
}

public struct SendImageMessage: MessageType {
    var type = "image"
    let data: SendImageData
    
    public struct SendImageData: Codable {
        let file: String
        let name: String?
        let summary: String?
        let subType: String?
        
        enum CodingKeys: String, CodingKey {
            case file, name, summary
            case subType = "sub_type"
        }
    }
}

public struct MFaceMessage: MessageType {
    var type = "mface"
    let data: MFaceData
    
    public struct MFaceData: Codable {
        let emojiId: String
        let emojiPackageId: String
        let key: String
        let summary: String?
        
        enum CodingKeys: String, CodingKey {
            case emojiId = "emoji_id"
            case emojiPackageId = "emoji_package_id"
            case key, summary
        }
    }
}

public struct MusicMessage: MessageType {
    var type = "music"
    let data: MusicData
    
    enum MusicData: Codable {
        case platform(PlatformMusic)
        case custom(CustomMusic)
        
        public struct PlatformMusic: Codable {
            var type: String // "qq" | "163" | "kugou" | "migu" | "kuwo"
            let id: String
        }
        
        public struct CustomMusic: Codable {
            var type: String = "custom"
            let url: String
            let audio: String
            let title: String
            let image: String?
            let singer: String?
        }
    }
}

public struct NodeMessage: MessageType {
    var type = "node"
    let data: NodeData
    
    enum NodeData: Codable {
        case content([NCSendMessage])
        case id(String)
    }
}

public struct ContactMessage: MessageType {
    var type = "contact"
    let data: ContactData
    
    public struct ContactData: Codable {
        let id: String
    }
}

// 其他基本消息类型
public struct FileMessage: MessageType {
    var type = "file"
    let data: FileData
}

public struct DiceMessageReceive: MessageType {
    var type = "dice"
    let data: DiceData
    
    public struct DiceData: Codable {
        let result: String?
    }
}

// { type: 'dice', data: {} }
public struct DiceMessageSend: MessageType {
    var type: String = "dice"
    let data: DiceData

    struct DiceData: Codable {}
}

public struct RPSMessageReceive: MessageType {
    var type = "rps"
    let data: RPSData
    
    public struct RPSData: Codable {
        let result: String?
    }
}

public struct RPSMessageSend: MessageType {
    var type = "rps"
    let data: RPSData
    
    public struct RPSData: Codable {}
}

public struct FaceMessage: MessageType {
    var type = "face"
    let data: FaceData
    
    public struct FaceData: Codable {
        let id: String
    }
}

public struct ReplyMessage: MessageType {
    var type = "reply"
    let data: ReplyData
    
    public struct ReplyData: Codable {
        let id: String
    }
}

public struct VideoMessage: MessageType {
    var type = "video"
    let data: FileData
}

public struct RecordMessage: MessageType {
    var type = "record"
    let data: FileData
}

public struct ForwardMessage: MessageType {
    var type = "forward"
    let data: ForwardData
    
    public struct ForwardData: Codable {
        let id: String
        let content: [NCReceiveMessage]?
    }
}

public struct JSONMessage: MessageType {
    var type = "json"
    let data: JSONData
    
    public struct JSONData: Codable {
        let data: String
    }
}

public struct MarkdownMessage: MessageType {
    var type = "markdown"
    let data: MarkdownData
    
    public struct MarkdownData: Codable {
        let content: String
    }
}
