//
//  Filter.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/4/28.
//

import Foundation


/*
最左侧侧边栏主要放置智能分类 & 标签，用户选择其中一个后，能在中间视图展示所有 issue。尽管智能分类和标签有很大不同；但从 SwiftUI 角度看它们很相似
因此，我们把“智能分类”和“标签”两个概念结合到一个名为“过滤器”的新类型中。
- 每个过滤器都有一个名称和一个图标，以便可以将其显示在屏幕上
- 每个过滤器都有一个可选的标签实例，以便使用用户的标签之一进行过滤
- 除了这3个属性，还想添加两个属性：一个唯一标识符，以便可以遵守可识别协议，以及一个最近修改日期，以便能够专门查找最近的问题
*/


//结构：创建过滤器结构
struct Filter: Identifiable, Hashable{
    
    
    //MARK: - 数据基本属性
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var tag: Tag?
    
    
    
    
    //MARK: - 创建两个常用过滤器，方便使用
    
    //静态属性：Filter.all
    static var all = Filter(
        id: UUID(),
        name: "All Issues",
        icon: "tray"
    )
    
    //静态属性：Filter.recent
    static var recent = Filter(
        id: UUID(),
        name: "Recents Issues",
        icon: "clock",
        //86400是一天的秒数，乘以-7代表7天前的
        minModificationDate: .now.addingTimeInterval(86400 * -7)
    )
    
    
    
    
    //MARK: - 自定义 Hashable 和 Equatable 协议
    /*
     在比较两个过滤器时，关心的只是它们的 id 属性，对名称、图标、修改日期和标签进行哈希处理是没有意义的；
     事实上，这样做还有可能会导致奇怪的行为，因为标签会随着时间的推移而变化；
     因此，我们将只使用 id 属性去判定两个对象是否相同，添加以下两个方法：
    */
    
    //自定义对象哈希的方式（只加入id）
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    //自定义对象比较是否相等的方式（只比较id）
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
    
    
    
}
