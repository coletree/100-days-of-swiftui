//
//  SignInView.swift
//  UltimatePortfolio
//
//  Created by coletree on 2024/6/12.
//


// 导入 AuthenticationServices，这是包含 SignInWithAppleButton 的框架
import AuthenticationServices
import SwiftUI


struct SignInView: View {


    // MARK: - 属性

    // 枚举：跟踪当前的授权状态。不过这个枚举不需要在应用的其他任何地方使用，因此可以将其设为嵌套枚举，放置在 SignInView 内
    enum SignInStatus {
        case unknown
        case authorized
        case failure(Error?)
    }

    // 状态属性：跟踪该状态枚举
    @State private var status = SignInStatus.unknown

    // 环境属性：获取主题
    @Environment(\.colorScheme) var colorScheme

    // 环境属性：点击后面的“关闭”按钮时，应该隐藏视图
    @Environment(\.presentationMode) var presentationMode




    // MARK: - 视图
    var body: some View {

        NavigationView {
            Group {
                switch status {

                case .unknown:
                    VStack(alignment: .leading) {

                        ScrollView {
                            Text("""
                                    In order to keep our community safe, we ask that you sign in before commenting on a project.

                                    We don't track your personal information; your name is used only for display purposes.

                                    Please note: we reserve the right to remove messages that are inappropriate or offensive.
                                    """)
                        }

                        Spacer()

                        // 创建 SignInWithAppleButton 是通过附加前面定义的两个方法来完成的
                        // 给 SignInWithAppleButton 按钮定义了准确的高度，否则它将占用所有可用空间
                        SignInWithAppleButton(onRequest: configureSignIn, onCompletion: completeSignIn)
                            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                            .frame(height: 44)

                        // 关闭按钮提供一个关闭视图的闭包
                        Button("Cancel", action: close)
                            .frame(maxWidth: .infinity)
                            .padding()

                    }

                // 如果用户获得授权，我们将显示一条成功消息
                case .authorized:
                    Text("You're all set!")

                // 如果授权失败，我们将显示一条错误消息
                case .failure(let error):
                    if let error = error {
                        Text("Sorry, there was an error: \(error.localizedDescription)")
                    } else {
                        Text("Sorry, there was an error.")
                    }
                }

            }
            .padding()
            .navigationTitle("Please sign in")
        }
    }


    // 方法：一个用于处理 SIWA 请求的配置
    func configureSignIn(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName]
    }

    // 方法：一个用于处理成功完成请求或以其他方式完成请求
    func completeSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            // success
            if let appleID = auth.credential as? ASAuthorizationAppleIDCredential {
                if let fullName = appleID.fullName {
                    let formatter = PersonNameComponentsFormatter()
                    var username = formatter.string(from: fullName).trimmingCharacters(in: .whitespacesAndNewlines)
                    if username.isEmpty {
                        // Refuse to allow empty string names
                        username = "User-\(Int.random(in: 1001...9999))"
                    }
                    UserDefaults.standard.set(username, forKey: "username")
                    // 这行代码将 username 的值存储到 iCloud 的键值存储区中，并将其与键 "username" 相关联
                    NSUbiquitousKeyValueStore.default.set(username, forKey: "username")
                    status = .authorized
                    close()
                    return
                }
            }
            status = .failure(nil)
        case .failure(let error):
            // failure
            if let error = error as? ASAuthorizationError {
                if error.errorCode == ASAuthorizationError.canceled.rawValue {
                    status = .unknown
                    return
                }
            }
            status = .failure(error)
        }
    }

    // 方法：用于取消按钮关闭视图
    func close() {
        presentationMode.wrappedValue.dismiss()
    }


}




// MARK: - 预览
#Preview {
    SignInView()
}
