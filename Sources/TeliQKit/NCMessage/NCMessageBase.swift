//
//  NCMessageBase.swift
//  TeliQKit
//
//  Created by wibus-wee on 2024/11/05.
//

import Foundation

// MARK: - Base Protocols
protocol MessageType: Codable {
    var type: String { get }
}