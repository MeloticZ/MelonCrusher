//
//  ContentView.swift
//  Crushmelon
//
//  Created by Korgo on 9/6/25.
//

import SwiftUI

struct Achievement: View {
    let achievementImage: String
    let achievementName: String
    @State private var offsetY: CGFloat = -120
    @State private var opacity: CGFloat = 0.0
    
    var body: some View {
        VStack {
            HStack (spacing: 12) {
                Image(achievementImage)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                VStack (alignment: .leading) {
                    Text("Achievement Unlocked!").bold().fontDesign(.serif)
                    Text(achievementName).fontDesign(.serif)
                }
                Spacer()
            }
            .padding(12)
            .glassEffect(.regular.tint(.gray.opacity(0.2)).interactive())
            .opacity(opacity)
            .offset(y: offsetY)
            .onAppear {
                withAnimation(.spring(.bouncy)) {
                    offsetY = 0
                    opacity = 1
                }
            }
            .onDisappear {
                withAnimation(.spring(.bouncy)) {
                    offsetY = -120
                    opacity = 0
                }
            }
            
            Spacer()
        }
    }
}

class AchievementStore: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    
    init(image: String, title: String) {
        self.image = image
        self.title = title
    }
}

struct GameView: View {
    @AppStorage("stickyHands") private var stickyHands: Int = 0
//    @AppStorage("gmoHandTier") private var gmoHandTier: Int = 1
//    @AppStorage("achievementCrush") private var achievementCrush: Bool = false
//    @AppStorage("achievementHandsOfGod") private var achievementHandsOfGod: Bool = false
    @State private var gmoHandTier: Int = 1
    @State private var achievementCrush: Bool = false
    @State private var achievementHandsOfGod: Bool = false
    
    @State private var isPunching: Bool = false
    @State private var effectiveOpacity: Double = 0.0
    @State private var achievements: [AchievementStore] = []
    private var initialGMOHandUpgradeCost = 100
    private var rotations = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0]
    private var melonAnimationDuration = 0.3
    
    var body: some View {
        let currrentGMOHandUpgradeCost: Int = gmoHandTier * gmoHandTier * gmoHandTier * initialGMOHandUpgradeCost
        VStack {
            ZStack {
                // note we cant handle multiple achievement popups yet
                ForEach (achievements) {achievenment in
                    Achievement(achievementImage: achievenment.image, achievementName: achievenment.title)
                }
                
                VStack {
                    Text("hand stickiness: \(stickyHands)")
                    ZStack {
                        Text("🍉")
                            .font(Font.system(size: 128))
                            .scaleEffect(isPunching ? 1.1 : 1)
                            .rotationEffect(Angle(degrees: isPunching ? -50.0 : 0.0))
                            .animation(.easeOut(duration: melonAnimationDuration), value: isPunching)
                        ForEach (rotations, id: \.self) { rotation in
                            Text(rotation.truncatingRemainder(dividingBy: 10) == 0 ? "🩸" : "💧")
                                .offset(y: isPunching ? 150 : 0)
                                .rotationEffect(Angle(degrees: rotation))
                                .scaleEffect(isPunching ? 0.7 : 1.3)
                                .opacity(effectiveOpacity)
                                .rotationEffect(Angle(degrees: isPunching ? 90.0 : 0.0))
                                .animation(isPunching ? .easeInOut(duration: melonAnimationDuration) : .none, value: isPunching)
                                .font(Font.system(size: 32))
                        }
                        Text("crush the melon :p")
                            .foregroundStyle(Color.white)
                            .bold(true)
                            .padding(10)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .blendMode(BlendMode.difference)
                    }.onTapGesture {
                        stickyHands += gmoHandTier
                        // Unlock Melon Crusher Achievement
                        if (!achievementCrush) {
                            achievements.insert(AchievementStore(image: "achievement_melon-crusher", title: "You having a crush on melon"), at: 0)
                            achievementCrush = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                withAnimation {
                                    achievements.removeAll { $0.image == "achievement_melon-crusher" }
                                }
                            }
                        }
                        
                        // Play Crushing Animations
                        if (isPunching) {
                            return
                        }
                        
                        withAnimation(.none) {
                            effectiveOpacity = 1.0
                        }
                        isPunching = true
                        
                        withAnimation(.easeOut(duration: melonAnimationDuration + 0.05)) {
                            effectiveOpacity = 0.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + melonAnimationDuration + 0.05) {
                            withAnimation(.none) {
                                isPunching = false
                                effectiveOpacity = 0.0
                            }
                        }
                    }
                }
                
                // Upgrade menus
                VStack {
                    Spacer()
                    HStack {
                        // GMO Hand Upgrades
                        VStack {
                            VStack {
                                Image(systemName: "hand.rays.fill")
                                    .font(.system(size: 32))
                                    .padding(2)
                                Text("GMO Hand")
                                HStack {
                                    Text("T\(gmoHandTier + 1)").bold(true)
                                    Text("\(currrentGMOHandUpgradeCost) 🍉")
                                }
                            }
                            .opacity(stickyHands >= currrentGMOHandUpgradeCost ? 1.0 : 0.3)
                            .onTapGesture {
                                // Unlock GMO Hand Achievement
                                if (!achievementHandsOfGod) {
                                    achievements.insert(AchievementStore(image: "achievement_hands-of-god", title: "The hands of god"), at: 0)
                                    achievementCrush = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                        withAnimation {
                                            achievements.removeAll { $0.image == "achievement_hands-of-god" }
                                        }
                                    }
                                }
                                
                                if stickyHands >= currrentGMOHandUpgradeCost {
                                    stickyHands -= currrentGMOHandUpgradeCost
                                    gmoHandTier += 1
                                }
                            }
                        }
                        
                        // Other upgrades
                        
                    }
                }
                
            }
            .fontDesign(.serif)
        }
        .padding()
    }
}

#Preview {
    GameView()
}
