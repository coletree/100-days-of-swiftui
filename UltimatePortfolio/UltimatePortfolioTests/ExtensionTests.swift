//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by coletree on 2024/5/14.
//

import CoreData
import XCTest

// 引入原 target，代表可以访问原 target 的所有类
@testable import UltimatePortfolio

/// 关于扩展的测试用例
/// 例如：是否能按照预期读取或写入基础 Core Data 属性值
final class ExtensionTests: BaseTestCase {

    /// 测试用例：检查对 IssueTitle 的解包和写入是否有效
    func testIssueTitleUnwrap() {
        let issue = Issue(context: managedObjectContext)
        // 设置 issue 实例的标题，然后断言解包的标题和原标题两者是否一致
        issue.title = "Example issue"
        XCTAssertEqual(issue.issueTitle, "Example issue", "Changing title should also change issueTitle.")
        // 设置 issue 实例的标题，然后断言解包的标题和原标题两者是否一致
        issue.issueTitle = "Updated issue"
        XCTAssertEqual(issue.title, "Updated issue", "Changing issueTitle should also change title.")
    }

    /// 测试用例：检查对 IssueContent 的解包和写入是否有效
    func testIssueContentUnwrap() {
        let issue = Issue(context: managedObjectContext)
        issue.content = "Example issue"
        XCTAssertEqual(issue.issueContent, "Example issue", "Changing content should also change issueContent.")
        issue.issueContent = "Updated issue"
        XCTAssertEqual(issue.content, "Updated issue", "Changing issueContent should also change content.")
    }

    /// 测试用例：检查对 IssueCreation 的解包是否有效（该属性无法写入）
    func testIssueCreationDateUnwrap() {
        // Given 给定
        let issue = Issue(context: managedObjectContext)
        let testDate = Date.now
        // When 判断
        issue.creationDate = testDate
        // Then 断言
        XCTAssertEqual(issue.issueCreationDate, testDate, "Changing creationDate should also change issueCreationDate.")
    }

    /// 测试用例：检查对 IssueTags 的解包是否有效
    func testIssueTagsUnwrap() {
        // 创建了一个 tag 和一个 issue，彼此并无关联
        let tag = Tag(context: managedObjectContext)
        let issue = Issue(context: managedObjectContext)
        // 断言 issue 中的 issueTags 属性应该为 0
        XCTAssertEqual(issue.issueTags.count, 0, "A new issue should have no tags.")
        // 将 issue 添加到 tag
        issue.addToTags(tag)
        // 断言 issue 中的 issueTags 属性应该为 1
        XCTAssertEqual(issue.issueTags.count, 1, "Adding 1 tag to an issue should result in issueTags having count 1.")
    }

    /// 测试用例：检查 IssueTagsList 数组能否正常生成
    func testIssueTagsList() {
        let issue = Issue(context: managedObjectContext)
        let tag = Tag(context: managedObjectContext)
        tag.name = "My Tag"
        // issue.addToTags(tag)
        tag.addToIssues(issue)
        // 断言 issue 中的 issueTagsList 数组属性应该为 1
        XCTAssertEqual(issue.issueTagsList, "My Tag", "Adding 1 tag to an issue should make issueTagsList be My Tag.")
    }

    /// 测试用例：测试排序稳定性。如果我们在对数组进行排序时总是得到相同的项目顺序，这称为稳定排序。
    func testIssueSortingIsStable() {
        // 创建 3 个不同的 issue
        let issue1 = Issue(context: managedObjectContext)
        issue1.title = "B Issue"
        issue1.creationDate = .now

        let issue2 = Issue(context: managedObjectContext)
        issue2.title = "B Issue"
        issue2.creationDate = .now.addingTimeInterval(1)

        let issue3 = Issue(context: managedObjectContext)
        issue3.title = "A Issue"
        issue3.creationDate = .now.addingTimeInterval(100)

        // 对 3 个 issue 进行排序
        let allIssues = [issue1, issue2, issue3]
        let sorted = allIssues.sorted()

        // 断言排序的结果，和理应正确的结果应该一致
        XCTAssertEqual([issue3, issue1, issue2], sorted, "Sorting issue arrays should use name then creation date.")
    }

    /// 测试用例：检查对 tagID 的解包和写入是否有效
    func testTagIDUnwrap() {
        let tag = Tag(context: managedObjectContext)
        tag.id = UUID()
        XCTAssertEqual(tag.tagID, tag.id, "Changing id should also change tagID.")
    }

    /// 测试用例：检查对 tagName 的解包和写入是否有效
    func testTagNameUnwrap() {
        let tag = Tag(context: managedObjectContext)
        tag.name = "Example Tag"
        XCTAssertEqual(tag.tagName, "Example Tag", "Changing name should also change tagName.")
    }

    /// 测试用例：检查对 tagActiveIssues 的解包是否有效，确保里面只包含活跃问题
    func testTagActiveIssuesUnwrap() {

        let tag = Tag(context: managedObjectContext)

        let issue1 = Issue(context: managedObjectContext)
        issue1.completed = true

        let issue2 = Issue(context: managedObjectContext)
        issue2.completed = false

        XCTAssertEqual(tag.tagActiveIssues.count, 0, "A new tag should have 0 active issues.")

        issue1.addToTags(tag)
        XCTAssertEqual(tag.tagActiveIssues.count, 0, "A new tag with 1 completed issue should have 0 active issue.")

        issue2.addToTags(tag)
        XCTAssertEqual(tag.tagActiveIssues.count, 1, "Tag with 1 completed & 1 new should have 1 active issues.")

    }

    /// 测试用例：测试排序稳定性。(如果两个标签具有相同的名称，排序依赖于 UUID)
    func testTagSortingIsStable() {

        // 创建 3 个不同的 tag
        let tag1 = Tag(context: managedObjectContext)
        tag1.name = "B Tag"
        tag1.id = UUID()

        let tag2 = Tag(context: managedObjectContext)
        tag2.name = "B Tag"
        tag2.id = UUID(uuidString: "FFFFFFFF-900A-4F96-88D7-72D3DEFB33B2")

        let tag3 = Tag(context: managedObjectContext)
        tag3.name = "A Tag"
        tag3.id = UUID()

        // 对 3 个 tag 进行排序
        let allTags = [tag1, tag2, tag3]
        let sortedTags = allTags.sorted()

        // 断言排序的结果，和理应正确的结果应该一致
        XCTAssertEqual([tag3, tag1, tag2], sortedTags, "Sorting tag arrays should use name then UUID string.")
    }

    /// Bundle 扩展可以处理任何类型的 Decodable 数据，因此除了测试解码 Award 类型，还应测试其他一些数据
    /// 我们不希望测试文件出现在主项目中，因此将这些文件直接添加到测试目标中

    /// 测试用例：检查 Bundle 的读取徽章数据是否有效
    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode("Awards.json", as: [Award].self)
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")

    }

    /// 测试解码测试文件：DecodableString.json
    func testDecodingString() {
        // 首先通过 ExtensionTests 类本身，找到所在 Bundle
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableString.json", as: String.self)
        XCTAssertEqual(data, "Never ask a starfish for directions.", "The string must match DecodableString.json.")
    }

    /// 测试解码测试文件：DecodableDictionary.json
    func testDecodingDictionary() {
        // 首先通过 ExtensionTests 类本身，找到所在 Bundle
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableDictionary.json", as: [String: Int].self)
        XCTAssertEqual(data.count, 3, "The dict must has 3 elements.")
        XCTAssertEqual(data["Two"], 2, "The second element must be 2.")
    }

}
