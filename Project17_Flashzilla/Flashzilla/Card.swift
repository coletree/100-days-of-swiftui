//
//  Card.swift
//  Flashzilla
//
//  Created by coletree on 2024/2/27.
//

import Foundation


//对于大多数项目来说，明智的起点是定义我们想要使用的数据模型：例如一张信息卡

/*
 我们将设计一个 EditCards 视图来将 Card 数组编码和解码为 UserDefaults
 在这样做之前，希望 Card 结构能够符合 Codable 协议
*/

struct Card: Codable, Identifiable, Equatable{
    
    var id: UUID = UUID()
    var prompt: String
    var answer: String

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
