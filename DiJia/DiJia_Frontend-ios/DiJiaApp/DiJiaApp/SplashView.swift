import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            AuthView() // 👉 Change ici si tu veux une autre vue après
        } else {
            VStack {
                Spacer()
                Image("Splashscreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .onAppear {
                // ⏱️ Délai avant de naviguer vers AuthView
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
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

