//
//  SettingView.swift
//  WeSplit
//
//  Created by coletree on 2023/11/23.
//

import SwiftUI


struct SettingView: View {
    
    //MARK: - 属性
    @State private var agreedToTerms = false
    @State private var agreedToPrivacyPolicy = false
    @State private var agreedToEmails = false

    
    
    //MARK: - body 视图
    var body: some View {
        
        //自定义绑定：自定义绑定可以不用直接绑定状态属性，而是通过一个中间值转一道，这样可以在中间添加额外逻辑
        //以下例子中 agreedToAll 就绑定了一个 自定义绑定类型 Binding
        //这段自定义绑定的声明代码，要放在 body 内部
        let agreedToAll = Binding<Bool>(
            get: {
                agreedToTerms && agreedToPrivacyPolicy && agreedToEmails
            },
            set: {
                agreedToTerms = $0
                agreedToPrivacyPolicy = $0
                agreedToEmails = $0
            }
        )

        VStack {
            Toggle("Agree to terms", isOn: $agreedToTerms)
            Toggle("Agree to privacy policy", isOn: $agreedToPrivacyPolicy)
            Toggle("Agree to receive shipping emails", isOn: $agreedToEmails)
            Toggle("Agree to all", isOn: agreedToAll)
        }
    }
}



//MARK: - 预览
#Preview {
    SettingView()
}
