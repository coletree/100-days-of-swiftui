//
//  ProspectsView.swift
//  HotProspects
//
//  Created by coletree on 2024/2/21.
//

import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications




struct ProspectsView: View {

    
    //MARK: - 属性
    
    //该 ProspectsView 是要对应 3 个实例的，因此它里面肯定要区分不同实例的不同内容
    //这里主要是靠 FilterType 这个枚举进行区分
    enum FilterType {
        case none, contacted, uncontacted
    }
    

    //默认情况下，这将加载所有 Prospect 模型对象，并按名称对它们进行排序
    //虽然这对于“Everyone”选项卡来说很好，但对于其他两个选项卡来说还不够
    //这里有三个 ProspectsView 实例，它们仅根据从选项卡视图传入的 FilterType 属性而变化
    //我们已经使用 FilterType 来设置每个视图的标题，我们也可以使用它来过滤查询
    //我们已经有一个默认查询，如果添加一个初始值设定项，就可以在设置过滤器时覆盖它
    
    //定义 FilterType 属性，没有赋值，因此要在初始化时赋值
    let filter: FilterType
    
    
    //定义计算属性 - 标题。它根据 FilterType 属性自动计算得出
    var title: String {
        switch filter {
            case .none:
                "Everyone"
            case .contacted:
                "Contacted"
            case .uncontacted:
                "Uncontacted"
        }
    }
    
    //获取 prospects 数据：执行 Prospect 对象的查询
    @Query var prospects: [Prospect]
    
    
    //定义一个计算参数去做过滤和排序，避免了直接在上面 Query 处做动态过滤的麻烦
    var filteredProspects: [Prospect] {
        
//        let result : [Prospect]
//        switch filter {
//        case .none:
//            result = prospects
//        case .contacted:
//            result = prospects.filter{ $0.isContacted }
//        case .uncontacted:
//            result = prospects.filter{ !$0.isContacted }
        
        if sortOrder == .name{
            return prospects.sorted{ $0.name < $1.name}
        }else if sortOrder == .email{
            return prospects.sorted{ $0.emailAddress < $1.emailAddress}
        }else{
            return prospects.reversed()
        }
        
    }
    
    

    
    
    //创建模型上下文 ，以便写入 Prospect 对象
    @Environment(\.modelContext) var modelContext
    
    
    //控制是否弹出扫描窗口
    @State private var isShowingScanner = false
    
    //储存选择的 Prospect
    @State private var selectedProspects = Set<Prospect>()
    

    //定义可能的排序方式，后续可从中选择一个
    enum sortType { case name, email, date }
    
    //设定状态属性 - 排序。默认为 name，后面可以修改
    @State private var sortOrder = sortType.name

    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            
            //名片的List列表
            List(filteredProspects, selection: $selectedProspects) {
                
                prospect in
                
                //设置导航卡片
                NavigationLink {
                    //目标视图
                    ProspectDetailView(prospect: prospect)
                } label: {
                    //导航链接视图
                    HStack(alignment: .center) {
                        
                        //名片基本信息
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        //判断是否在【全列表】，然后根据【是否联系属性】决定是否要展示图标
                        if filter == .none{
                            if prospect.isContacted == true{
                                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40)
                                    .foregroundColor(.green)
                            }
                        }
                        
                    }
                }
                
                //设置滑动动作（只需在属性上调用 toggle 就可翻转布尔值）
                .swipeActions {
                    if prospect.isContacted {
                        Button("标记为 Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            modelContext.delete(prospect)
                        }
                    } else {
                        Button("标记为 Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            modelContext.delete(prospect)
                        }
                    }
                }
                
                //设置每一行的tag，以便标记每一个选择的行
                .tag(prospect)
                
            }
            
            //设置导航标题
            .navigationTitle("\(title): \(prospects.count)")
            
            //设置toolbar
            .toolbar {
                
                //扫描按钮
                Button("Scan", systemImage: "qrcode.viewfinder") {
                    isShowingScanner = true
                }
                
                //删除按钮（当有选择的时候才出现）
                if selectedProspects.isEmpty == false {
                    Button("Delete Selected", action: delete)
                }
                
                //排序按钮
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    //用 tag 修饰符，包裹具体选项的值（可以是任何值）。该值与状态属性绑定
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag(sortType.name)
                        Text("Sort by Email")
                            .tag(sortType.email)
                        Text("Sort by Date")
                            .tag(sortType.date)
                    }
                }
                
                //编辑按钮
                EditButton()
                
            }
            //扫描二维码弹窗（3个参数）
            //1. 要扫描的代码类型的数组。此应用只扫描二维码，因此 [.qr] 就可以了
            //2. 用作模拟数据的字符串。 由于模拟器不支持使用相机扫描代码，因此 CodeScannerView 自动呈现替换 UI，以便我们仍然可以测试一切是否正常。这个替换 UI 将自动发回我们作为模拟数据传入的任何内容。
            //3.要使用的完成函数，这可能是一个闭包。我们刚刚编写了 handleScan() 方法，因此我们将使用它。
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: "Coletree\npaul@hackingwithswift.com",
                    completion: handleScan
                )

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
            })
        }
    }

    
    //方法：完成扫描后的动作
    func handleScan(result: Result<ScanResult, ScanError>) {
        
        //收起扫描弹窗
        isShowingScanner = false
        
        switch result {
            case .success(let result):
                let details = result.string.components(separatedBy: "\n")
                guard details.count == 2 else { return }
                let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
                modelContext.insert(person)
            case .failure(let error):
                print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
    
    
    //方法：在编辑模式下，删除选择的所有 prospect
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
        selectedProspects = Set()
    }
    
    
    //方法：添加本地通知
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            //var dateComponents = DateComponents()
            //dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            //这里使用了 UNCalendarNotificationTrigger 作为触发器，这可以自定义 DateComponents 实例
            //将其设置为 9 小时，意味着它将在下次上午 9 点到来时触发
            //出于测试目的，注释掉该触发代码并将其替换为“五秒后显示警报”
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        //用 getNotificationSettings 获取授权状态
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                //如果已经被授权，那执行【添加本地通知请求】的闭包
                addRequest()
                print("提示已设置")
            } else {
                //如果还没被授权，就先提出请求 - 获取授权
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        //如果授权成功，继续执行【添加本地通知请求】的闭包
                        addRequest()
                        print("提示已设置")
                    } else if let error {
                        //授权不成功，那打印错误信息
                        print(error.localizedDescription)
                    }
                }
            }
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
