//
//  AnimatedHeroView.swift
//  EcosortAI
//

import SwiftUI

struct AnimatedHeroView: View {
    @State private var float = false
    @State private var tilt = false
    @Namespace private var hero

    var body: some View {
        Image(systemName: "arrow.2.circlepath")
            .font(.system(size: 72, weight: .semibold))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.green)
            .rotationEffect(.degrees(tilt ? 6 : -6))
            .offset(y: float ? -6 : 6)
            .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: float)
            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: tilt)
            .onAppear {
                float = true
                tilt = true
            }
    }
}
