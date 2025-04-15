//
//  ContentView.swift
//  DiJiaApp
//
//  Created by DELORY on 08/04/2025.
//

import SwiftUI
import AVFoundation
import FirebaseAuth

struct ContentView: View {
    @StateObject private var socketManager = WebSocketManager()
    @State private var inputText: String = ""
    @State private var isTyping = false
    @EnvironmentObject var authVM: AuthViewModel
    
    
    var body: some View {
        Group {
            if authVM.isAuthenticated {
                mainChatView
            } else {
                AuthView()
            }
        }
    }
    
    private var mainChatView: some View {
        VStack {
            if !authVM.isEmailVerified{
                HStack {
                    VStack(alignment: .leading) {
                        Text("📬 Vérifie ton email")
                            .bold()
                        Text("Clique pour confirmer ton email afin de sauvegarder ton compte.")
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
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack {
                        ForEach(socketManager.messages.indices, id: \.self) { index in
                            let msg = socketManager.messages[index]
                            HStack {
                                if msg.contains("Moi :") {
                                    Spacer()
                                }
                                
                                Text(msg)
                                    .padding()
                                    .background(msg.contains("Moi :") ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                    .transition(.move(edge: msg.contains("Moi :") ? .trailing : .leading).combined(with: .opacity))
                                    .animation(.easeOut(duration: 0.3), value: socketManager.messages)
                                
                                if msg.contains("Moi :") == false {
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .id(index) // Important pour scroller automatiquement
                        }
                    }
                }
                .onChange(of: socketManager.messages.count) {
                    // Scrolle automatiquement vers le dernier message reçu
                    withAnimation {
                        scrollProxy.scrollTo(socketManager.messages.count - 1, anchor: .bottom)
                    }
                }
            }
            
            if isTyping {
                HStack {
                    Circle().frame(width: 8, height: 8).foregroundColor(.gray).opacity(0.8)
                    Circle().frame(width: 8, height: 8).foregroundColor(.gray).opacity(0.6)
                    Circle().frame(width: 8, height: 8).foregroundColor(.gray).opacity(0.4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .transition(.opacity)
            }
            
            HStack {
                TextField("Écris quelque chose...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Envoyer") {
                    AudioServicesPlaySystemSound(1104)
                    socketManager.sendMessage(inputText)
                    inputText = ""
                }
            }
            .padding(.horizontal)
            .padding()
            
            Button("Se déconnecter") {
                authVM.logout()
            }
            .foregroundColor(.red)
            .padding(.top, 10)
        }
    }
    
    }
