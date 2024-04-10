//
//  Prospect.swift
//  HotProspects
//
//  Created by coletree on 2024/2/21.
//


import SwiftData


@Model class Prospect{
    
    var name: String
    var emailAddress: String
    var isContacted: Bool
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
    
}
