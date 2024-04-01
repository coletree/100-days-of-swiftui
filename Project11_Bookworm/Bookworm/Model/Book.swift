//
//  Book.swift
//  Bookworm
//
//  Created by coletree on 2023/12/27.
//

import SwiftData
import Foundation



//MARK: - 书籍数据模型

@Model
class Book : Hashable{
    
    //基本属性：
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var createDate : Date = Date.now
    
    
    //初始化方法：
    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
    
}
