//
//  User.swift
//  SwiftDataProject
//
//  Created by coletree on 2023/12/29.
//

import Foundation
import SwiftData


@Model
class User {
    
    var name: String
    var city: String
    var joinDate: Date
    
    @Relationship(deleteRule: .cascade) var jobs = [Job]()
    //此时，job有一个所有者，而user有一系列作业 - 这种关系是双向的，这通常是一个好主意，因为它使您的数据更易于使用。
    //更好的是，下次应用程序启动时，SwiftData 会默默地将 jobs 属性添加到所有现有用户，默认情况下为他们提供一个空数组。
    //这称为迁移：当在模型中添加或删除属性时，随着需求随着时间的推移而变化,SwiftData 可以自动执行像这样的简单迁移。随着您进步，您将了解如何创建自定义迁移来处理更大的模型更改。

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
    
}
