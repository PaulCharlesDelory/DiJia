//
//  DiJiaAppApp.swift
//  DiJiaApp
//
//  Created by DELORY on 08/04/2025.
//

import SwiftUI
import Firebase

@main
struct DiJiaAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())
        }
    }
}
