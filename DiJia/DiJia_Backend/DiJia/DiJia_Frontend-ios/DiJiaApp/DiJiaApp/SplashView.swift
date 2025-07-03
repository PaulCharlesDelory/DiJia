import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            AuthView()
        } else {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Image("Splashscreen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)

                    Text("DiJia")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

//
//  SplashView.swift
//  DiJiaApp
//
//  Created by Paul Delory on 22/05/2025.
//

