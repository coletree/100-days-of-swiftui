//
//  Job.swift
//  SwiftDataProject
//
//  Created by coletree on 2024/1/3.
//

import Foundation
import SwiftData




//MARK: - Job数据结构

@Model
class Job {
    
    var name: String
    var priority: Int
    var owner: User?
    
    //请注意 owner 属性直接引用 User 模型 - 明确告诉 SwiftData 这两个模型链接在一起。
    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
    
}
