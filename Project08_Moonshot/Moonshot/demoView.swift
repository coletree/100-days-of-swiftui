//
//  demoView.swift
//  Moonshot
//
//  Created by coletree on 2024/3/21.
//

import SwiftUI

struct demoView: View {
    
    
    var body: some View {
        
        
        Text("Hello, World!")
        Button("Decode JSON") {
            let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """

            // more code to come
            let data = Data(input.utf8)
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                print(user.address.street)
            }
        }
        
        
    }
    
    
}



struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}







#Preview {
    demoView()
}



