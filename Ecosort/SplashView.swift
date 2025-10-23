//
//  SplashView.swift
//  EcosortAI
//

import SwiftUI

struct SplashView: View {
    @State private var show = false
    @State private var navigate = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.green.opacity(0.2), .teal.opacity(0.2)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                AnimatedHeroView()
                    .scaleEffect(show ? 1.0 : 0.7)
                    .opacity(show ? 1 : 0.2)
                    .animation(.spring(response: 0.7, dampingFraction: 0.6), value: show)
                
                Text("EcoSort AI")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.green)
                    .opacity(show ? 1 : 0)
                    .offset(y: show ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: show)
            }
        }
        .onAppear {
            show = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    navigate = true
                }
            }
        }
        .fullScreenCover(isPresented: $navigate) {
            MainTabView()
        }
    }
}
