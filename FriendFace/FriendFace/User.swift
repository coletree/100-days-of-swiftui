//
//  User.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import Foundation





//单个用户模型：
struct User: Codable, Identifiable, Hashable, Equatable{
    
    let id : UUID
    var isActive : Bool
    var name : String
    var age : Int
    var company : String
    var email : String
    var address : String
    var about : String
    //日期类型
    var registered : Date
    var tags : [String]
    var friends : [Friend]
    
}
