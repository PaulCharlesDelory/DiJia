import SwiftUI
import AVFoundation
import FirebaseAuth


let testIAList: [IA] = [
    IA(id: 1, name: "Gollum", description: "Un être malicieux", avatar_url: "https://static.wikia.nocookie.net/seigneur-des-anneaux/images/4/41/Gollum_hobbit.jpg/revision/latest?cb=20140824092651&path-prefix=fr"),
    IA(id: 2, name: "Jarvis", description: "Assistant intelligent", avatar_url: "https://www.marvel-cineverse.fr/medias/images/jarvis-imgprofil.png"),
    IA(id: 3, name: "Athena", description: "Déesse des IA", avatar_url: "https://static.wikia.nocookie.net/percy-jackson/images/f/ff/RR_Viria_-_Ath%C3%A9na.jpg/revision/latest?cb=20231005185220&path-prefix=fr"),
    IA(id: 4, name: "Neo", description: "Le choix de la Matrice", avatar_url: "https://static.hitek.fr/img/up_s/581957052/matrixneo.webp")
]


struct ContentView: View {
    @StateObject private var socketManager = WebSocketManager()
    let speechSynthesizer = AVSpeechSynthesizer()
    @State private var inputText: String = ""
    @State private var isTyping = false
    @State private var showSplash = true
    @State private var showMessages = true
    @State private var selectedIA: IA? = nil
    @State private var showProfile = false
    @State private var isIASelected = false
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        Group {
            if showSplash {
                SplashView()
            } else if !authVM.isAuthenticated {
                AuthView()
            } else if !isIASelected {
                IASelectionView(
                    selectedIA: $selectedIA,
                    isIASelected: $isIASelected,
                    iaList: testIAList
                )
            } else {
                if selectedIA != nil {
                    VStack {
                        HStack {
                            // ⬅️ Bouton Retour
                            Button(action: {
                                selectedIA = nil
                                isIASelected = false
                            }) {
                                Label("Retour", systemImage: "arrow.left")
                                    .foregroundColor(.blue)
                            }

                            Spacer()

                            // 👤 Bouton Profil
                            Button(action: {
                                showProfile = true
                            }) {
                                Image(systemName: "person.crop.circle")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)

                        mainChatView
                    }
                } else {
                    Text("Erreur : IA non sélectionnée")
                }
            }

        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    self.showSplash = false
                }
            }
        }
        .sheet(isPresented: $showProfile) {
            if let ia = selectedIA {
                IAProfileView(ia: ia)
            }
        }
    }
    
    func speak(_ text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.45
        utterance.volume = 1.0

        // 🔁 Personnalisation en fonction de l'IA
        switch selectedIA?.name {
        case "Jarvis":
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_premium")
            utterance.pitchMultiplier = 1.0

        case "Athena":
            utterance.voice = AVSpeechSynthesisVoice(identifier: "fr-FR")
            utterance.pitchMultiplier = 1.1

        case "Neo":
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Thomas-premium")
            utterance.pitchMultiplier = 0.95

        case "Gollum":
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.pitchMultiplier = 1.6

        default:
            utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
            utterance.pitchMultiplier = 1.1
        }

        speechSynthesizer.speak(utterance)
    }

    private var mainChatView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 🔘 Bouton de toggle toujours visible
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showMessages.toggle()
                        }
                    }) {
                        Image(systemName: showMessages ? "xmark.circle.fill" : "text.bubble.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                // 👇 Partie messages + bannière
                if showMessages {
                    VStack {
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
                                                .onAppear {
                                                    if !msg.contains("Moi :") && index == socketManager.messages.count - 1 {
                                                                speak(msg)
                                                            }
                                                }
                                            
                                            if !msg.contains("Moi :") {
                                                Spacer()
                                            }
                                        }
                                        .padding(.horizontal)
                                        .id(index)
                                    }
                                }
                            }
                            .onChange(of: socketManager.messages.count) {
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
                    }
                }
                
                Spacer()
                
                // ✅ Zone de saisie et bouton de déconnexion (toujours visible)
                VStack(spacing: 10) {
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
                    
                    Button("Se déconnecter") {
                        authVM.logout()
                    }
                    .foregroundColor(.red)
                }
                .padding()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
