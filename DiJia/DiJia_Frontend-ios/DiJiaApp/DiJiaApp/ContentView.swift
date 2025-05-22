import SwiftUI
import AVFoundation
import FirebaseAuth


let testIAListe: [IA] = [
    IA(id: 1, name: "Gollum", description: "Un être malicieux", avatar_url: "http://static.wikia.nocookie.net/seigneur-des-anneaux/images/4/41/Gollum_hobbit.jpg/revision/latest?cb=20140824092651&path-prefix=fr"),
    IA(id: 2, name: "Jarvis", description: "Assistant intelligent", avatar_url: "https://www.marvel-cineverse.fr/pages/mcu/encyclopedie/objets/jarvis.html"),
    IA(id: 3, name: "Athena", description: "Déesse des IA", avatar_url: "https://static.wikia.nocookie.net/percy-jackson/images/f/ff/RR_Viria_-_Ath%C3%A9na.jpg/revision/latest?cb=20231005185220&path-prefix=fr"),
    IA(id: 4, name: "Neo", description: "Le choix de la Matrice", avatar_url: "https://www.premiere.fr/Cinema/News-Cinema/La-theorie-qui-tue-Neo-na-jamais-ete-lelu-dans-Matrix")
]


struct ContentView: View {
    @StateObject private var socketManager = WebSocketManager()
    @State private var inputText: String = ""
    @State private var isTyping = false
    @State private var showMessages = true
    @State private var selectedIA: IA? = nil
    @State private var isIASelected = false
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        SplashView()
        Group {
            if authVM.isAuthenticated {
                if isIASelected {
                    if let selectedIA = selectedIA {
                        HomeView(ia: selectedIA)
                    } else {
                        Text("Erreur : aucune IA sélectionnée")
                    }// Tu passes l’IA sélectionnée ici
                } else {
                    IASelectionView(selectedIA: $selectedIA, isIASelected: $isIASelected, iaList: testIAListe)
                }
            } else {
                AuthView()
            }
        }
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
                        if !authVM.isEmailVerified {
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
