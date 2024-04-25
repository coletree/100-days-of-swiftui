//
//  Candy+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//
//

import Foundation
import CoreData


extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    //candy 对 country 是多对一
    @NSManaged public var origin: Country?
    
    //使用计算属性进行解包
    public var wrappedName: String {
        name ?? "Unknown Candy"
    }

}

extension Candy : Identifiable {

}
