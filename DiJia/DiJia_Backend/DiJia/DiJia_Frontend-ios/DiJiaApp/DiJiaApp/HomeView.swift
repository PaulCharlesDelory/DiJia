import SwiftUI

struct HomeView: View {
    var ia: IA
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        
        VStack(spacing: 20) {
            if !authVM.isEmailVerified {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("📬 Vérifie ton email")
                            .bold()
                        Text("Ton email n’est pas encore vérifié. Clique ci-dessous pour renvoyer le lien.")
                            .font(.caption)
                    }

                    Spacer()

                    Button("Renvoyer") {
                        authVM.sendVerificationEmail()
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(8)
                .padding(.horizontal)
            }

            Text("Bienvenue dans DiJia avec \(ia.name) 🧠")
                .font(.title)

            Button("Se déconnecter") {
                authVM.logout()
            }
            .foregroundColor(.red)
        }
        .onAppear {
            authVM.checkIfUserIsAuthenticated()
        }
        .padding()
    }
}//
//  HomeView.swift
//  DiJiaApp
//
//  Created by DELORY on 14/04/2025.
//

