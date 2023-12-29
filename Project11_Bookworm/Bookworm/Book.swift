//
//  Book.swift
//  Bookworm
//
//  Created by coletree on 2023/12/27.
//

import SwiftData
import Foundation


@Model
class Book : Hashable{
    
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var createDate : Date = Date.now
    
    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
    
}
