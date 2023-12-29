//
//  Student.swift
//  Bookworm
//
//  Created by coletree on 2023/12/27.
//

import SwiftData
import Foundation


@Model
class Student {
    
    var id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
}
