//
//  LoginView.swift
//  Crushmelon
//
//  Created by Korgo on 9/16/25.
//

import SwiftUI

struct LoginView: View {
    let onFinished: () -> Void
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var titleEffect: Bool = false
    @State private var isLoggingIn: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Crushmelon")
                    .font(.largeTitle).bold()
                    .fontDesign(.serif)
                    .background(
                        Text("🍉")
                            .font(Font.system(size: 60))
                            .rotationEffect(Angle(degrees: 300.0))
                            .offset(x: 30, y: 30),
                        alignment: .bottomTrailing
                    )
                    .background(
                        Text("💦")
                            .font(Font.system(size: 60))
                            .rotationEffect(Angle(degrees: 180.0))
                            .offset(x: -30, y: -30),
                        alignment: .topLeading
                    )
                    .rotationEffect(Angle(degrees: titleEffect ? Double.random(in: -15...15) : 0))
                    .scaleEffect(titleEffect ? 1.1 : 1)
                    .animation(.easeIn(duration: 0.2), value: titleEffect)
                    .onTapGesture {
                        withAnimation {
                            titleEffect = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.none) {
                                    titleEffect = false
                                }
                            }
                        }
                    }
                Spacer()
            }
            .padding(.top, 80)
            
            VStack (alignment: .leading) {
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.username)
                    .padding(10)
                    .padding([.leading, .trailing], 4)
                    .glassEffect(.regular.tint(.gray.opacity(0.15)).interactive())
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.password)
                    .padding(10)
                    .padding([.leading, .trailing], 4)
                    .glassEffect(.regular.tint(.gray.opacity(0.15)).interactive())
                Button() {
                    isLoggingIn = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.none) {
                            onFinished()
                        }
                    }
                } label: {
                    Image(systemName: "airplane")
                    if !isLoggingIn {
                        Text("Login")
                    }
                }
                .padding(4)
                .frame(maxWidth: .infinity, alignment: isLoggingIn ? .trailing : .leading)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLoggingIn)
                
            }
            .frame(maxWidth: 300)
        }
        .hoverEffect()
    }
}
