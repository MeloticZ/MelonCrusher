//
//  ContentView.swift
//  Crushmelon
//
//  Created by Korgo on 9/16/25.
//
import SwiftUI

struct ContentView: View {
    @State private var display = "login"
    var body: some View {
        ZStack {
            switch display {
            case "login":
                LoginView(onFinished: {self.display = "onboard"})
                    .transition(.move(edge: .leading).combined(with: .opacity))
            case "onboard":
                OnboardingView(onFinished: {self.display = "game"})
                    .transition(.move(edge: .top).combined(with: .opacity))
            case "game":
                GameView()
            default:
                LoginView(onFinished: {self.display = "onboard"})
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }.animation(.easeInOut(duration: 0.5), value: display)
    }
    
}

#Preview {
    ContentView()
}
