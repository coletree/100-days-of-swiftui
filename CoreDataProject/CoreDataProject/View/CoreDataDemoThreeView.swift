//
//  CoreDataDemoThreeView.swift
//  CoreDataProject
//
//  Created by coletree on 2024/4/25.
//

import SwiftUI

struct CoreDataDemoThreeView: View {
    
    
    //MARK: - 属性
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    
    
    
    
    //MARK: - 视图
    var body: some View {
        
        VStack {
            
            Text("生成一些数据进行保存，约束属性重复的会被合并")
                .font(.caption2)
            
            List {
                ForEach(countries, id: \.self) {
                        country in
                    Section(country.wrappedFullName) {
                        ForEach(country.candyArray, id: \.self) {
                                  candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }

            Button("Add") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"

                let candy2 = Candy(context: moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"

                let candy3 = Candy(context: moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"

                let candy4 = Candy(context: moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"

                try? moc.save()
            }
        }
    }
    
}




//MARK: - 预览
#Preview {
    CoreDataDemoThreeView()
}
