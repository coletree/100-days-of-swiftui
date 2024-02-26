//
//  ProspectDetailView.swift
//  HotProspects
//
//  Created by coletree on 2024/2/23.
//
import SwiftData
import SwiftUI



struct ProspectDetailView: View {
    
    
    //MARK: - 属性
    
    //1. 属性是swiftData 对象，该类是从别的视图传过来的，需要加上 @Bindable 才能做绑定
    @Bindable var prospect : Prospect
    
    
    
    //MARK: - 视图
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                TextField("Name", text: $prospect.name)
                    .textContentType(.name)
                    .font(.title2)

                TextField("Email address", text: $prospect.emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title2)

                
            }
            .navigationTitle("Your code")
        }
        
    }
    
    
    //MARK: - 方法
    
    
    
}




//MARK: - 预览
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Prospect.self, configurations: config)
        let example = Prospect(name: "hello", emailAddress: "coletree@163.com", isContacted: true)
        return ProspectDetailView(prospect: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
