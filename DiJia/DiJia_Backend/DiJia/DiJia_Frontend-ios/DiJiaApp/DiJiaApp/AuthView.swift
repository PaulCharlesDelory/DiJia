import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true

    var body: some View {
        VStack(spacing: 20) {
            Text(isLogin ? "Connexion" : "Créer un compte")
                .font(.title)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            SecureField("Mot de passe", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            Button(action: {
                if isLogin {
                    authVM.login(email: email, password: password)
                } else {
                    authVM.signUp(email: email, password: password)
                }
            }) {
                Text(isLogin ? "Se connecter" : "S'inscrire")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Button(action: {
                isLogin.toggle()
            }) {
                Text(isLogin ? "Pas encore inscrit ?" : "Déjà inscrit ? Se connecter")
                    .font(.caption)
            }

            if !authVM.authError.isEmpty {
                Text(authVM.authError)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}//
//  AuthView.swift
//  DiJiaApp
//
//  Created by DELORY on 14/04/2025.
//

