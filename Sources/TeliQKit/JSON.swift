//
//  JSON.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/06.
//

import Foundation

/// 用于处理动态 JSON 数据的类型
public struct JSON: Codable {
    private var value: Any
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([JSON].self) {
            value = array
        } else if let dict = try? container.decode([String: JSON].self) {
            value = dict
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JSON value")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { JSON($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { JSON($0) })
        default:
            throw EncodingError.invalidValue(value, .init(codingPath: encoder.codingPath, debugDescription: "Invalid JSON value"))
        }
    }
    
    public init(_ value: Any) {
        self.value = value
    }
}