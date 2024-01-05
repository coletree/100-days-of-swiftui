//
//  Friend.swift
//  FriendFace
//
//  Created by coletree on 2024/1/5.
//

import Foundation



//好友模型
struct Friend: Codable, Identifiable, Hashable, Equatable{
    var id : UUID
    var name : String
}
