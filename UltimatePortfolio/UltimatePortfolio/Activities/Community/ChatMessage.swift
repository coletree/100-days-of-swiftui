//
//  ChatMessage.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/6/13.
//

import Foundation
import CloudKit



/// 首先定义基本数据模型：聊天消息中应该包含什么？至少有以下四个属性：
/// 唯一的标识符（以便可以在 SwiftUI 中循环消息）、编写消息的人的姓名、编写消息的日期，以及实际的消息本身。
struct ChatMessage: Identifiable {
    let id: String
    let from: String
    let text: String
    let date: Date
}



// 创建对象的新方法：在扩展中定义新的初始化方法，该方法接受 CKRecord 参数，并在这里完成 CloudKit 字段读取
// 经过这一微小的更改，现在可以使用 ChatMessage(id:from:text:date) 以及 ChatMessage(from:) 两种方法来创建实例
extension ChatMessage {
    init(from record: CKRecord) {
        id = record.recordID.recordName
        from = record["from"] as? String ?? "No author"
        text = record["text"] as? String ?? "No text"
        date = record.creationDate ?? Date()
    }
}


