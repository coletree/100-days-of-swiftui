//
//  DataController.swift
//  UltimatePortfolio
//  Created by coletree on 2024/4/26.
//

import CoreData
import Foundation
import SwiftUI




/// 一个控制核心数据的单体类：它将处理加载数据，本地保存数据，同步到CloudKit，等工作
/// 这里要用 ObservableObject，不能用 Observable ，不然后面 delete 方法的 objectWillChange 属性就无法用
class DataController: ObservableObject {


    // MARK: - 属性

    // 常量属性：创建容器，加载 Model 数据模型
    // let container = NSPersistentContainer(name: "Model")

    // 常量属性：创建 CloudKit 的容器（前面已经在 CoreData 编辑器的配置中勾选了 used with Cloudkit）
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer


    // @Published属性：声明变量来存储用户选择的过滤器，它会通知订阅者。默认为“所有”
    @Published var selectedFilter: Filter? = Filter.all

    // @Published属性：声明变量来存储用户选择的 Issue 问题，它会通知订阅者
    @Published var selectedIssue: Issue?

    // @Published属性：声明变量存储用户输入的 tag 列表过滤关键词
    @Published var filterText = ""

    // @Published属性：要为用户选择的令牌列表（tag列表）提供存储的地方。这将是一个空 Tag 数组，但会在添加或删除标签时自动调整
    @Published var filterTokens = [Tag]()


    // 计算属性：根据用户是否输入 # 号决定是否展示建议的 tag
    var suggestedFilterTokens: [Tag] {

        // 确保用户输入内容中是否以 # 开头，否则返回
        guard filterText.starts(with: "#") else {
            return []
        }

        // 如果是以#号开头，则舍弃第一个字母，并格式化
        let trimmedFilterText = String(filterText.dropFirst()).trimmingCharacters(in: .whitespaces)

        // 创建获取 tag 的 fetchRequest
        let request = Tag.fetchRequest()

        // 设置 request 的谓词，必须包含格式化字符
        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
        }

        // 加载符合条件的 tag 内容
        print( (try? container.viewContext.fetch(request).sorted()) ?? [] )
        return (try? container.viewContext.fetch(request).sorted()) ?? []

    }

    // @Published属性：储存这个新的过滤系统是启用还是禁用
    @Published var filterEnabled = false

    // @Published属性：储存数据的排序方式
    @Published var sortType = SortType.dateCreated

    // @Published属性：储存正反序
    @Published var sortNewestFirst = true

    // @Published属性：储存想要显示的问题状态
    @Published var filterStatus = Status.all

    // @Published属性：储存想要显示的问题优先级（-1 作为特殊优先级，即“任何优先级”）
    @Published var filterPriority = -1

    // 私有变量属性：Task 实例来处理保存。它没有返回值，因为只是调用 save() 的方法；但它可能会引发错误，因为在调用 save() 之前会要求任务休眠一段时间。
    // 因此，将其声明为 Task<Void, Error> 符合需求，并且将它设置为可选，因为它一开始并不存在
    private var saveTask: Task<Void, Error>?


    /// 静态属性：创建单体
    static let model: NSManagedObjectModel = {
        // 确认资源包里有 Model.momd 数据库文件
        guard let url = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        // 确认可以用 Model.momd 文件地址作为数据库
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        return managedObjectModel
    }()


    // Spotlight集成：需要一个属性来存储一个活跃的 Core Spotlight 索引器
    var spotlightDelegate: NSCoreDataCoreSpotlightDelegate?

    // UserDefaults 的本地实例，用于测试
    let defaults: UserDefaults




    // MARK: - 方法

    /// 自定义初始化：在内存中初始化数据控制器（用于临时使用，例如测试和预览）或永久存储（用于常规应用程序运行。）默认为永久存储。
    /// 
    /// 这是什么
    /// - Parameter inMemory: 一个布尔值决定是否将此数据存储在临时内存中
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        
        // 给属性赋值
        self.defaults = defaults

        // 给容器属性赋值（后面 Model 就是告诉程序要加载的数据库）
        // container = NSPersistentCloudKitContainer(name: "Model")
        // 给容器属性赋值（后面 Model 就是告诉程序要加载的数据库），并且指定使用前面静态属性 model 定义的数据库
        // 确保实体将只会被加载一次，跨测试和实际代码
        container = NSPersistentCloudKitContainer(name: "Model", managedObjectModel: Self.model)


        // 为了测试和预览目的，创建一个写入 /dev/null 的临时内存数据库
        // 所以我们的数据在应用程序运行完成后就会被销毁
        // 如果布尔值参数为真，则使用它（于是不支持持久化存储）
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }

        // 设置：自动将【底层持久性存储发生的更改】应用于视图
        container.viewContext.automaticallyMergesChangesFromParent = true

        // 设置：合并策略为属性合并 mergeByPropertyObjectTrump，它允许将来自本地对象的更改与来自远程对象的更改按属性组合在一起
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump


        // 确保关注 iCloud 进行所有更改
        // 绝对确保我们在发生事件时保持本地 UI 同步
        // 发生远程更改

        // 设置：告诉 Core Data 在存储发生更改时收到通知
        container.persistentStoreDescriptions.first?.setOption(
                true as NSNumber,
                forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )

        // 设置：告诉系统在发生更改时调用新 remoteStoreChanged() 方法
        NotificationCenter.default.addObserver(
                forName: .NSPersistentStoreRemoteChange,
                object: container.persistentStoreCoordinator,
                queue: .main,
                using: remoteStoreChanged
        )

        // 设置：容器读取数据库中的数据
        container.loadPersistentStores { [weak self] storeDescription, error in
            // 如果发生错误，则退出程序。error 是 optional 类型，所以用 if let 解包
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            // 当运行到 if let error = error 代码时，代表核心数据已加载完成，无论是成功还是失败
            // 1. 一旦持久存储加载完毕，就可以为 spotlight 配置持久性历史记录跟踪
            if let description = self?.container.persistentStoreDescriptions.first {

                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

                // 3.需要创建索引委托，将其附加到我们的存储描述和核心数据容器的持久存储协调器
                if let coordinator = self?.container.persistentStoreCoordinator {

                    self?.spotlightDelegate = NSCoreDataCoreSpotlightDelegate(
                        forStoreWith: description, coordinator: coordinator
                    )

                    // 4.我们需要告诉该索引器开始其工作：
                    self?.spotlightDelegate?.startSpotlightIndexing()
                }

            }

            // 为了避免在生产代码中暴露攻击媒介，用 if DEBUG 去限制只在处于调试模式时才做检查（而发布到 AppStore 时不会包含该代码）
            #if DEBUG
            // 这里检查【只有在提供“enable-testing”作为启动参数】时，才需要运行里面的代码。我们在UI测试中配置了此参数
            if CommandLine.arguments.contains("enable-testing") {
                self?.deleteAll()
                print("**********已经删除所有数据**********")
                // 禁用应用程序的所有动画，这使得 UI 测试速度大大加快
                UIView.setAnimationsEnabled(false)
            }
            #endif
        }

    }

    // 方法：输入一个 issue ，然后返回一个包含 "该 issue 缺少的所有标签" 的数组
    // 在内部加载所有可能存在的标签。计算当前未分配给问题的标签；对这些标签进行排序，然后将它们发回
    func missingTags(from issue: Issue) -> [Tag] {

        // 1.首先获取所有 tag，并将其转为集合
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []
        let allTagsSet = Set(allTags)

        // 2.在所有 tag 集合上调用 symmetricDifference，与该issue的标签集合进行对比，返回差异化的tag集合
        let difference = allTagsSet.symmetricDifference(issue.issueTags)

        // 3.对生成的集合进行 sort 排序然后返回
        return difference.sorted()
    }

    // 方法: 立即保存。将上下文中的 live 数据持久化存储下来；存储前先检查是否有变化，节省资源
    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save() {
        // issueView 中的 onReceive 修改器会调用排队保存，onSubmit 修改器立即保存；虽然我们有做 hasChanges 检查，但也会产生一点点重复工作
        // 所以我们在代码层面消除这个重复工作，即当调用 save 的时候，就取消 saveTask
        saveTask?.cancel()
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    // 方法：延迟n秒后保存。该方法将延迟保存更改。这可以通过创建一个新任务来完成，让它休眠几秒钟，然后调用 save()
    func queueSave() {
        // 每次调用排队保存时，先取消之前的 saveTask 属性中的任务（如果有的话），就是之前没有任务也不受影响
        saveTask?.cancel()
        // 1.把新任务赋予 saveTask 属性。这样允许我们在发生其他更改时首先取消任务，确保不会发生任何现有的排队保存。
        saveTask = Task {
            @MainActor in
            // 2. 任务里面是的 sleep 等待时间，选择等待多长时间取决于你，但像 3 秒这样的等待是不错的默认情况
            try await Task.sleep(for: .seconds(3))
            // 3. 休眠任务是一种抛出操作，因为取消任务会导致休眠立即结束并引发错误。这意味着我们的 save() 调用不会被执行
            save()
        }
    }

    // 方法: 删除实体对象。这里只限制对象要符合 NSManagedObject 协议，这样不管是 issue 还是 tag ，都可以用这个方法
    func delete(_ object: NSManagedObject) {
        // objectWillChange 是 SwiftUI 一个重要属性。当 ObservableObject 类型的对象发生变化时，它会自动发送 objectWillChange 消息，通知订阅它的视图进行更新。
        // 也可以手动调用 objectWillChange.send() ，让开发者自主控制视图的更新时机，比如只有在满足某些条件时才更新视图。这种方式比单纯使用 @Published 属性包装器更灵活。
        objectWillChange.send()
        // 删除传入的对象
        container.viewContext.delete(object)
        // 持久化保存下来
        save()
    }

    // 方法：远程数据发生更改时进行以下处理
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }

    // 方法：将之前视图中的 [issue] 计算属性改成方法。返回某个 tag 或者某个智能过滤器下的所有 Issue
    /// 使用各种谓词运行获取请求，这些谓词基于过滤用户的问题
    /// 关于标签、标题和内容文本、搜索标记、优先级和完成状态。
    /// - Returns: 一个所有匹配的 Issue 的数组
    func issuesForSelectedFilter() -> [Issue] {

        // 获取用户选择的过滤器(如果获取不到，就默认是 "过滤器All" )，根据过滤器的 tag 属性去生成后面的 Issues
        let filter = selectedFilter ?? .all

        // 需要支持多条件返回数据，如要将额外的参数 “过滤文本” 考虑在内，因此用到复合谓词
        var predicates = [NSPredicate]()

        // 声明所有Issue数组
        var allIssues: [Issue]

        // 1. 如果 filter 里面存在 tag，则设置谓词为 “对象的 tag 属性是否包含选中的 tag“，然后加入复合谓词数组 predicates
        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)
        }
        // 2. 如果 filter 里面没有 tag，设置谓词为 “大于最近修改时间”， 然后加入复合谓词数组 predicates
        else {
            // 在谓词中通过区分 modificationDate 属性，实现区分 all 和 recent 的效果
            // 告诉 Core Data 仅匹配过滤器的最小修改日期以来修改的对象。as NSDate 这部分是必需的，因为 Core Data 不了解 Swift Date 的类型，而是需要较旧的 NSDate 类型
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }

        // 格式化用户输入的关键词
        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)

        // 3. 如果 filterText 有值，则设置多个谓词，例如“标题是否包含检索词”和“内容是否包含检索词”
        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
            let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", trimmedFilterText)

            // 以上两个谓词条件只需要满足其中之一即可，因此将两个谓词包装在复合谓词 NSCompoundPredicate 中，使用 orPredicateWithSubpredicates 参数
            // NSCompoundPredicate 中的 orPredicateWithSubpredicates 参数后面跟着 [NSPredicate] 数组，or 指数组内元素的关系
            let combinedPredicate = NSCompoundPredicate(
                orPredicateWithSubpredicates: [titlePredicate, contentPredicate]
            )

            // 将这个复合谓词加入 前面定义的谓词数组 predicates
            predicates.append(combinedPredicate)
        }

        // 4. 如果 filterTokens 有值，则设置 token 谓词，并加入复合谓词数组 predicates
        if filterTokens.isEmpty == false {

            // 4.1 该方法是只要满足用户选择 token 的其中之一
            let tokenPredicate = NSPredicate(format: "ANY tags IN %@", filterTokens)
            predicates.append(tokenPredicate)

            // 4.2 该方法是要满足用户选择 token 的所有，那就加入多个谓词，具体自己选择
//            for filterToken in filterTokens {
//                let tokenPredicate = NSPredicate(format: "tags CONTAINS %@", filterToken)
//                predicates.append(tokenPredicate)
//            }

        }

        // 只有当 filterEnabled 为 true 时，优先级和状态过滤器才应该被激活
        if filterEnabled {
            // 仅当优先级大于或等于 0 时，才会添加优先级谓词，因为如果您还记得，我们使用的优先级为 -1 表示“所有优先级”。
            if filterPriority >= 0 {
                let priorityFilter = NSPredicate(format: "priority = %d", filterPriority)
                predicates.append(priorityFilter)
            }
            // 如果用户仅查找已解决的问题，则 lookForClosed 常量将设置为 true，但仅当他们尚未请求所有问题时，才会添加该谓词。
            if filterStatus != .all {
                let lookForClosed = filterStatus == .closed
                let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForClosed))
                predicates.append(statusFilter)
            }
        }

        // fetch 方法用于从持久化存储中获取数据。它接受一个 NSFetchRequest 类型的参数 request,用于定义要获取的数据。
        // NSFetchRequest 可以指定要获取的实体类型、过滤条件、排序等

        let request = Issue.fetchRequest()

        // 请求的 predicate 属性：设置为前面定义的复合谓词数组，关系为 andPredicateWithSubpredicates
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        // 请求的 sortDescriptors 属性：键设置为 sortType.rawValue (即等同于模型中的字段)
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]

        // 第2个零合并：因为发出 fetch 请求可能会失败，所以用 try? 转为 optional 并使用零合并
        allIssues = (try? container.viewContext.fetch(request)) ?? []

        // 返回所有 Issue ，无需再排序，因为前面已经定义了 sortDescriptors
        return allIssues

    }

    // 方法：新建 issue 实例
    func newIssue() {
        // 可使用最低限度信息创建，因为有些属性有默认值
        let issue = Issue(context: container.viewContext)
        // 让默认名称支持本地化，它会去 Localizable 文件里查
        issue.title = NSLocalizedString("New issue", comment: "Create a new issue")
        issue.creationDate = .now
        issue.priority = 1
        // 将当前 filter 的标签分配给新建的 issue
        // 如果当前正在浏览用户创建的标签，请立即将这个新问题添加到标签中，否则它创建完成后不会出现在列表（addToTags方法是自动生成的）
        if let tag = selectedFilter?.tag {
            issue.addToTags(tag)
        }
        // 创建完成，调用save方法
        save()
        // 保存后，将 selectedIssue 设置为刚创建的问题，这将立即触发它被选择，于是可以带入该问题的页面
        selectedIssue = issue
    }

    // 方法：新建 tag 实例
    func newTag() -> Bool {

        var shouldCreate = fullVersionUnlocked
        // 1，先检查权益有没有解锁
        if shouldCreate == false {
            // 2.如果权益没有解锁，再检查当前 tag 是否小于 3
            shouldCreate = count(for: Tag.fetchRequest()) < 3
        }

        // 通过以上两个检查，就可以决定 shouldCreate 的值，是否应该创建...
        // shouldCreate 必须是 true，才往下执行，否则退出，返回 false
        guard shouldCreate else {
            return false
        }

        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        // 让默认名称支持本地化，它会去 Localizable 文件里查
        tag.name = NSLocalizedString("New tag", comment: "Create a new tag")
        save()
        // selectedFilter = Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)

        // 别忘了在末尾添加这一行，因为该方法是有返回值的
        return true

    }


    // 方法：查询某类型的对象总数
    // 读取计数请求，每次都会返回一个可选值，因为有可能查询的类型根本不存在，这里做了个双问号默认值
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    // TODO: - 方法：评估奖励
    // 评估是否得到奖励，有两个重要的值：criterion 和 value，最终返回的是布尔值。因此后续可以用于数组的 filter 过滤
    func hasEarned(award: Award) -> Bool {
        // 首先判断标准 criterion 属于什么情况
        switch award.criterion {

            case "issues":
                // 标准为 issues 的情况下，如果查询到 issue 的数量大于标准值，返回 true
                let fetchRequest = Issue.fetchRequest()
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            case "closed":
                // 标准为 closed 的情况下，如果查询到（状态为已完成的 issue） 的数量大于标准值，返回 true
                let fetchRequest = Issue.fetchRequest()
                // 添加了一个简单的谓词来按已完成的问题进行过滤
                fetchRequest.predicate = NSPredicate(format: "completed = true")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            case "tags":
                // 标准为 tags 的情况下，如果查询到 tag 的数量大于标准值，返回 true
                let fetchRequest = Tag.fetchRequest()
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            default:
                // an unknown award criterion; this should never be allowed
                // fatalError("Unknown award criterion: \(award.criterion)")
                return false

        }
    }

    // 方法：将 Spotlight 搜索结果的唯一标识符转化为 Issue 对象
    func issue(with uniqueIdentifier: String) -> Issue? {

        // 确保可以从 uniqueIdentifier 生成 URL
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }

        // 确保可以从 URL 生成对象 ID
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }

        // 如果 URL 无效，或者如果我们找不到对象 ID，或如果我们以某种方式加载了托管对象但它不是 issue ，那我们都会发回 nil
        // 否则返回正确的 Issue 实例
        return try? container.viewContext.existingObject(with: id) as? Issue

    }




    // MARK: - 测试专用

    // 静态属性：为了方便后面视图的预览，创建一下预处理数据。
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()

    // 方法: 添加测试数据
    func createSampleData() {

        // 常量属性：获取容器的上下文，必须有上下文才能创建/修改数据，context会把数据存到内存
        let viewContext = container.viewContext

        for sampleI in 1...5 {

            // 生成 tag
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(sampleI)"

            for sampleJ in 1...10 {
                // 生成 issue
                let issue = Issue(context: viewContext)
                issue.title = "Issue: \(sampleI) - \(sampleJ)"
                issue.content = "问题的描述在这里"
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
                issue.creationDate = .now
                // modificationDate 已经设置成了派生属性，由程序自动更新，无需自行设置
                // issue.modificationDate = .now

                // 这个 addToIssues 方法是程序自动生成的实体类里带的
                tag.addToIssues(issue)
            }
        }

        // 使用上下文 viewContext，调用 save 方法将数据写入持久化存储设备
        try? viewContext.save()

    }

    // 方法: 创建批量删除所有数据的请求，以方便测试
    /*
     1. 在 Issue 上使用 FetchRequest 方法获取所有的 issue 实体对象（不需要指定任何过滤器）
     2. 将该获取请求包装在【批量删除请求】中，该请求告诉 Core Data 删除与请求匹配的所有对象，即所有 issue
     3. 在视图上下文上执行批量删除请求
     有个问题就是：运行批量删除请求需要读出每个已删除对象的核心数据标识符，然后将它们合并到实时视图上下文中。
     这比预期的工作量要多，所以我们将这部份单独封装在新的 delete() 方法中，这样至少可以重用。
    */
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {

        // 创建批量删除的请求：
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        // 用什么来作为批量删除的唯一识别符呢？这里指定是 ObjectIDs
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        // 然后让上下文执行【批量删除请求】，其执行后的返回结果转型为 NSBatchDeleteResult，赋值给 delete
        // delete 是 optional 类型，因此这里做解包，解包成功后才执行后续代码
        // 当执行批量删除时，我们需要确保读回结果，然后将该结果的所有更改合并回我们的实时视图上下文中，以便两者保持同步
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {

            // changes 是一个字典 [NSDeletedObjectsKey: [ID数组] ]
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? [] ]
            // FIXME: 合并
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }

    }

    // 方法: 批量删除所有数据。（创建两个请求，调用前面的 delete 方法）
    func deleteAll() {

        // 创建 tag 的批量删除请求，并执行
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)

        // 创建 issue 的批量删除请求，并执行
        let request2: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(request2)

        // 保存更改
        save()

    }

}

// 枚举：issue 的排序方式，指按创建日期排序还是按修改日期排序
enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
}

// 枚举：issue 的状态，指打开、关闭或两者兼而有之
enum Status {
    case all, open, closed
}
