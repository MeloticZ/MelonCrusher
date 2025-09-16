//
//  OnboardingView.swift
//  Crushmelon
//
//  Created by Korgo on 9/16/25.
//


import SwiftUI
internal import Combine

struct FadeInTextView: View {
    @State private var isVisible = false
    let text: String
    let font: Font
    let duration: Double
    let isActive: Bool

    var body: some View {
        Text(text)
            .font(font)
            .opacity(isVisible ? (isActive ? 1.0 : 0.3) : 0) // start invisible
            .offset(y: isVisible ? -25 : 0)
            .transition(.opacity)
            .multilineTextAlignment(.center)
            .padding(.vertical, 10)
            .onAppear {
                withAnimation(.spring(duration: duration, bounce: 0.5)) {
                    isVisible = true
                }
            }
    }
}

class fadeInTextObject: Identifiable {
    let id = UUID()
    var text: String
    var duration: Double
    var delay: Double
    var font: Font
    
    init(text: String, duration: Double, delay: Double, font: Font) {
        self.text = text
        self.duration = duration
        self.delay = delay
        self.font = font
    }
}

struct TextPopper: View {
    let onFinished: () -> Void
    let textObjects: [fadeInTextObject]
    
    @State private var shownTexts: [fadeInTextObject] = []
    @State private var activeIndex: Int = -1
    
    var body: some View {
        VStack {
            ForEach(Array(shownTexts.enumerated()), id: \.element.id) { index, obj in
                FadeInTextView(
                    text: obj.text,
                    font: obj.font,
                    duration: obj.duration,
                    isActive: index == activeIndex
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .contentShape(Rectangle())
        .onAppear {
            showText()
        }
        .gesture(
            DragGesture(minimumDistance: 10)
                .onEnded { value in
                    if value.translation.height < -40 {
                        if (activeIndex >= textObjects.count - 1) {
                            onFinished()
                        }
                    }
                }
        )
        .padding()
    }
    
    private func showText() {
        var delayBuffer: Double = 0
        for (index, obj) in textObjects.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayBuffer) {
                withAnimation {
                    shownTexts.append(obj)
                    activeIndex = index
                }
            }
            delayBuffer += obj.duration + obj.delay
        }
    }
}

struct OnboardingView: View {
    let onFinished: () -> Void
    
    let introText = [
        fadeInTextObject(text: "Hi there 👋", duration: 1.0, delay: 1.0, font: Font.largeTitle.bold()),
        fadeInTextObject(text: "Welcome to this app 🎉", duration: 1.0, delay: 1.0, font: Font.title.bold()),
        fadeInTextObject(text: "In the next minute, we will figure out how much do you like melons 🍉", duration: 1.0, delay: 2.0, font: Font.title.bold()),
        fadeInTextObject(text: "Excited? 👀", duration: 1.0, delay: 1.0, font: Font.title.bold()),
        fadeInTextObject(text: "Swipe up to get started", duration: 1.0, delay: 1.0, font: Font.title2),
    ]
    
    var body: some View {
        TextPopper(onFinished: onFinished, textObjects: introText)
    }
}

#Preview {
    OnboardingView(onFinished: {})
}
