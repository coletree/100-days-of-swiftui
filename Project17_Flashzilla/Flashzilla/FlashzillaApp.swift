//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by coletree on 2024/2/26.
//

import SwiftUI


/*
 In this project we’re going to build an app that helps users learn things using flashcards
 cards with one thing written on such as “to buy”, and another thing written on the other side, such as “comprar”.
 Of course, this is a digital app so we don’t need to worry about “the other side”,
 and can instead just make the detail for the flash card appear when it’s tapped.
 在这个项目中，我们希望用户看到一张卡片，上面有一些提示文本，可以回答他们想要学习的任何内容，例如“苏格兰的首都是什么？”，当他们点击它时，我们会显示答案，在本例中就是这样当然是爱丁堡。
*/
 

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
