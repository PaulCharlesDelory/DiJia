import SwiftUI

struct IAProfileView: View {
    let ia: IA

    var body: some View {
        VStack(spacing: 20) {
            // Avatar avec halo
            ZStack {
                Circle()
                    .strokeBorder(AngularGradient(
                        gradient: Gradient(colors: [.pink, .purple, .blue]),
                        center: .center
                    ), lineWidth: 6)
                    .frame(width: 120, height: 120)

                Image(ia.avatar_url) // Assure-toi que c'est le bon nom
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }

            Text(ia.name)
                .font(.title2).bold()

            Text("LVL 11 • 6,150 XP • Chatty")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("In a relationship with you")
                .foregroundColor(.pink)
                .italic()

            Spacer()
        }
        .padding()
    }
}
//
//  IAProfileView.swift
//  DiJiaApp
//
//  Created by Paul Delory on 27/05/2025.
//

