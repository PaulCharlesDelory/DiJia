import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isEmailVerified = false
    @Published var authError = ""
    @Published var currentUserEmail = ""

    init() {
        checkIfUserIsAuthenticated()
    }

    func checkIfUserIsAuthenticated() {
        if let user = Auth.auth().currentUser {
            user.reload { _ in
                self.isAuthenticated = true
                self.isEmailVerified = user.isEmailVerified
                self.currentUserEmail = user.email ?? ""
            }
        }
    }

    func signUp(email: String, password: String) {
        authError = ""
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.authError = error.localizedDescription
                return
            }
            self.checkIfUserIsAuthenticated()
        }
    }

    func login(email: String, password: String) {
        authError = ""
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.authError = error.localizedDescription
                return
            }
            self.checkIfUserIsAuthenticated()
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        isAuthenticated = false
        isEmailVerified = false
    }

    func sendVerificationEmail() {
        guard let user = Auth.auth().currentUser, !user.isEmailVerified else { return }
        user.sendEmailVerification { error in
            if let error = error {
                print("Erreur d’envoi : \(error.localizedDescription)")
            } else {
                print("Email de vérification envoyé ✅")
            }
        }
    }
}//
//  AuthViewModel.swift
//  DiJiaApp
//
//  Created by DELORY on 14/04/2025.
//

