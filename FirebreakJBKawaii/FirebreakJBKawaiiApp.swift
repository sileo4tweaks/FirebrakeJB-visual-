//
//  FirebreakJBKawaiiApp.swift
//  FirebreakJBKawaii
//
//  Kawaii candy-themed jailbreak installer concept app ♥
//  Pure SwiftUI. No real exploits, no private APIs.
//

import SwiftUI

@main
struct FirebreakJBKawaiiApp: App {
    var body: some Scene {
        WindowGroup {
            JailbreakView()
                .preferredColorScheme(.light)
        }
    }
}
