# Instructions

记录该项目的一些难点





## Overview








##【经验】如何保存数据

当编辑应用数据时需要用到“保存”，但往往不希望在进行每个操作（例如输入字母）时都触发保存。因为频繁写入磁盘会消耗 CPU。那么如何才能确保数据安全保存，同时避免过多的触发呢？
一种想法是将代码附加到视图的 onDisappear 修饰符中，这样可以检测“当用户离开当前 view 时”，保存更改。但这没有考虑到，如果用户直接退出应用程序而不是先离开视图，那么数据将永远不会保存。
另外当程序遭遇错误时，最坏的情况下，用户可能会在编辑了有价值的信息后，意外地返回主屏幕，数据也没有被保存。
保存太频繁是浪费，但保存太少可能会丢失数据。因此，一个好的保存机制需要找到中间立场：

1. 在数据模型 DataController 中创建新保存任务，在调用 save() 之前等待三秒钟。如果用户在这段时间内进行了更多修改，则取消上一个任务并再创建一个新任务
2. 每当 issue 数据的任何部分发生变化时，从 IssueView 视图中调用该方法。这意味着当用户在输入时，我们会定期创建和取消新任务，但这比更新磁盘上的核心数据存储要节省资源
    - 对于第2点，使用 onReceive() 来监视对象的 objectWillChange 属性。 .onReceive(issue.objectWillChange) { _ in }
    - 这里使用 .onChange(of: issue) 无效，因为 issue 内的属性变化，不代表 issue 对象发生变化
3. 每当应用程序离开前台活动状态时，都会立即调用“保存”，以防后续用户打算退出
    - 对于第3点，读取 @Environment(\.scenePhase) 的值，用 onChange 进行监视




##【经验】过滤 CoreData 数据

如果想支持 “用户按标题或内容搜索特定对象” 或 “让用户使用搜索令牌同时搜索一个或多个标签”，该怎么办？
该项目需要支持 “在具体 tag 过滤器中按文本进行过滤” 的能力，以及 “按令牌进行过滤” 的能力（即用户可以看到可供选择的建议 tag 列表，点击搜索，不必手动键入搜索词）。

1. 这种情况肯定要引入动态参数，根据输入的参数进行计算。但如果使用 “计算属性” 则无法再引用另外一个参数，因此要把 “计算属性” 改成 方法
2. 在具体 tag 过滤器中按文本进行过滤，需要做到：
    - 在 DataController 中创建一个 @Published 属性 filterText 来存储用户当前键入的任何内容
    - 将 filterText 绑定到 ContentView 的 searchable() 修饰符参数中
    - 用 filterText 来过滤返回对象
        - 这里最简单的做法是保持原有的代码不变，还是获取所有对象，然后再在获取结果中进行过滤；但该做法比较浪费资源，并且会与后面的按令牌过滤冲突；
        - 更聪明的方法是：将多个谓词应用于查询，以便 fetch 请求只返回屏幕上实际显示的内容，这里用到了 NSCompoundPredicate 
3. 按令牌进行过滤，需要做到：
    - 发回所有可能的令牌列表。如果需要，可以对其进行过滤，但不需要这样做
    - 创建存储来保存用户当前选择的令牌
    - 将两者都绑定到 searchable() 修饰符，包括告诉 SwiftUI 如何显示令牌，这意味着添加三个新参数并调整现有参数：
        - 该 tokens 参数应绑定到我们的 filterTokens 属性，以存储用户的当前令牌
        - 参数 suggestedTokens 应该绑定到 suggestedFilterTokens ，有一个小的 catch：这需要是一个绑定，所以我们在这里将它包装在一个常量绑定中。
        - 需要一个尾随闭包来告诉 SwiftUI 如何将一个 Tag 实例转换为一些可见的 UI。我们将使用包含其名称的简单 Text 视图，但欢迎您尝试更高级的视图
        - 需要调整的一点是：提示文本应该告诉用户以“#”开头来触发标签。
    - 调整 issuesForSelectedFilter() 方法以考虑这些令牌




## 【经验】直接获得CoreData对象的个数

我们可以直接通过 NSFetchRequest 的 count 方法向视图上下文询问某个对象的数量，而不需要读取所有可能对象
container.viewContext.count(for: fetchRequest)
