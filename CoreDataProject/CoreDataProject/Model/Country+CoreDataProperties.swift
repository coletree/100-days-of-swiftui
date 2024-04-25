//
//  Country+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?
    //因为 country 对 candy 是一对多，该属性是个集合
    @NSManaged public var candy: NSSet?
    
    
    ///对于 country 类，也可以在 shortName 和 fullName 周围创建相同的字符串包装器：
    public var wrappedShortName: String {
        shortName ?? "Unknown Country"
    }

    public var wrappedFullName: String {
        fullName ?? "Unknown Country"
    }
    
    
    //将此计算属性添加到 Country 中：
    public var candyArray: [Candy] {
        let set = candy as? Set<Candy> ?? []
        return set.sorted {
            (a:Candy, b:Candy) in
            a.wrappedName < b.wrappedName
        }
    }

}

// MARK: Generated accessors for candy
// Xcode还生成了一些方法供我们使用。
extension Country {

    @objc(addCandyObject:)
    @NSManaged public func addToCandy(_ value: Candy)

    @objc(removeCandyObject:)
    @NSManaged public func removeFromCandy(_ value: Candy)

    @objc(addCandy:)
    @NSManaged public func addToCandy(_ values: NSSet)

    @objc(removeCandy:)
    @NSManaged public func removeFromCandy(_ values: NSSet)

}

extension Country : Identifiable {

}
