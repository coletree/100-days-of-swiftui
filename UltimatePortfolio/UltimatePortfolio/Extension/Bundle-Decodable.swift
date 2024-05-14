//
//  Bundle-Decodable.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/5/8.
//

import Foundation


// MARK: - 创建 Bundle 扩展
// 它可以适用于任何类型的 JSON 数据，把它放入任何项目中即可以使用
// 1. 支持从 App 的特定捆绑包 Bundle 中查找特定文件名，加载 JSON
// 2. 支持将该文件加载到 Data 实例中
// 3. 支持将该 Data 实例转换为特定类型的 Swift 对象，如果解码失败，则显示有用的出错提示


extension Bundle {

    // 方法：通用的解码方法
    // 由于不知道将使用哪种类型的数据，因此提供泛型类型参数，它只要符合 Decodable 协议
    func decode<T: Decodable>(

        // 第1个参数：文件名，我们需要知道要加载哪个文件。该文件应存在于正在使用的任何捆绑包中
        _ file: String,

        // 第2个参数：T.Type。T 是某种未知类型的占位符
        /*
         当正常使用 Codable 时，你往往会写这样的东西：let items = JSONDecoder().decode(WishList.self, from: jsonData)
         这意味着我们想要将新事物解码为对象 WishList ，而不是解码为已经拥有的特定 WishList 值。
         例如 44、444 和 44,444,444 它们都是 Int 类型的实例。当我们想泛指所有整数，而不是一个特定的数字时，写作 Int.self

         所以 Int.self 指的是 Int 类型本身，就像 WishList.self 指的是 WishList 类型本身一样。
         当我们说某个方法接受 T.Type 参数时，请记住 T 是我们的占位符，它可能是整数、字符串或其他内容。
         Type 表示这属于类型，而不是类型的实例（意味着写入的是 Int.self 或 WishList.self ，而不是 5 或特定的 WishList 对象）。
         所以，T.Type 放在一起意味着 “某种符合 Decodable 协议的类型“。我们可以让它加载任何类型的可解码数据。

         为了使事情稍微复杂一些（其实只是更易于使用！），该 type 参数的默认值为 T.self 。
         结合起来的意思是 “告诉我要解码的类型，并且如果可能的话，尝试根据上下文弄清楚“ 。
         所以这意味着：如果 Swift 知道我们将返回一个字符串数组（例如已经将某个属性声明为该类型），那么就可以不设置该参数；但如果 Swift 不知道要解码什么类型，就需要填写明确
         */
        as type: T.Type = T.self,

        // 第3个参数：一种日期解码策略，我们可以以对这个 JSON 文件有意义的方式处理日期。默认为 .deferredToDate ，这和 Codable 的默认一致
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,

        // 第4个参数：一个关键的解码策略，我们可以在 蛇形命名 和 骆驼命名 之间切换。同样，这和 Codable 的默认一致
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys

    ) -> T {

        // 1. 首先在当前捆绑包中找到请求文件的实际 URL ，如果失败，则调用 fatalError() 以使应用程序崩溃
        // 这不是从互联网下载的某个随机文件，而是包含在应用程序捆绑包中的 JSON 文件，因此应该严格保证其准确性，如果有错误直接退出是可以接受的
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        // 2. 接下来从 URL 加载数据到 Data 实例中，如果它无法读取 bundle 中的文件，也算是严重的错误。同样可以直接崩溃退出
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        // 3. 设置解码器
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        // 4， 最重要的部分：将该数据解码为请求的任何类型。我们已经传入了某种类型，因此我们可以在代码中引用 T.self 该类型。
        // 在解码数据时可能会抛出很多错误。因此如果我们单独捕获它们，可以通过 fatalError() 调用有意义的数据，使得查找和修复错误 JSON 的过程变得更加容易。
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }

    }


}
