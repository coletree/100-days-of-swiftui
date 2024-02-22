//
//  ProspectsView.swift
//  HotProspects
//
//  Created by coletree on 2024/2/21.
//

import SwiftData
import SwiftUI




struct ProspectsView: View {

    
    //MARK: - 属性
    
    //【重点】该 ProspectsView 是要对应 3 个实例的，因此它里面肯定要区分不同实例的不同内容
    
    //这里主要是靠 FilterType 这个枚举进行区分
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    //定义 FilterType 属性，没有赋值，因此要在初始化时赋值
    let filter: FilterType
    
    //定义了计算属性：它根据 FilterType 属性自动计算得出
    var title: String {
        switch filter {
            case .none:
                "Everyone"
            case .contacted:
                "Contacted people"
            case .uncontacted:
                "Uncontacted people"
        }
    }
    
    //获取 prospects 数据：执行 Prospect 对象的查询
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    
    //默认情况下，这将加载所有 Prospect 模型对象，并按名称对它们进行排序
    //虽然这对于“Everyone”选项卡来说很好，但对于其他两个选项卡来说还不够
    //这里有三个 ProspectsView 实例，它们仅根据从选项卡视图传入的 FilterType 属性而变化
    //我们已经使用 FilterType 来设置每个视图的标题，我们也可以使用它来过滤查询
    //我们已经有一个默认查询，如果添加一个初始值设定项，就可以在设置过滤器时覆盖它
    
    
    
    //创建模型上下文 ，以便写入 Prospect 对象
    @Environment(\.modelContext) var modelContext
    
    

    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            
            List(prospects) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.emailAddress)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("People: \(prospects.count)")
                .navigationTitle(title)
                .toolbar {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        let prospect = Prospect(name: "Paul Hudson", emailAddress: "paul@hackingwithswift.com", isContacted: false)
                        modelContext.insert(prospect)
                    }
                }
        }
        
    }
    
    
    //MARK: - 方法
    
    //自定义初始化方法
    init(filter: FilterType) {
        self.filter = filter
        if filter != .none {
            let showContactedOnly = filter == .contacted
            //这里用了$0代表第一个闭包参数
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: [SortDescriptor(\Prospect.name)])
        }
    }

    
    
    
}




//MARK: - 预览

#Preview {
    do{

        //1.由于并不希望创建的模型容器实际存储任何内容；则需要创建【自定义配置】，告诉 SwiftData 仅将信息存储在内存中
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        //2.使用刚刚的【自定义配置】，来创建一个模型容器
        let container = try ModelContainer(for: Prospect.self, configurations: config)
        
        //3. 这是准备好的对象数据（这个不能放到前面，顺序不能换）
        let example = Prospect(name: "peopleName", emailAddress: "coletree@163.com", isContacted: true)
        
        //4.返回以下内容给Preview
        return ProspectsView(filter: .none).modelContainer(for: Prospect.self)
        
    }
    catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
