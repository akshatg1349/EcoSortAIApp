//
//  EcoSortAIApp.swift
//  EcosortAI
//

import SwiftUI

@main
struct EcoSortAIApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Eco Lens", systemImage: "camera.viewfinder")
                }
            AskAIChatView()
                .tabItem {
                    Label("Ask AI", systemImage: "message.fill")
                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "leaf.fill")
                }
            
            }
    }
}
