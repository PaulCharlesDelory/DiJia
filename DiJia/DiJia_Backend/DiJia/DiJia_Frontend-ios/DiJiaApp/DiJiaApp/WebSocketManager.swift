import Foundation
import SocketIO

class WebSocketManager: ObservableObject {
    private var manager: SocketManager!
    private var socket: SocketIOClient!

    @Published var messages: [String] = []

    init() {
        // Remplace l'IP par celle de ton Mac si tu testes sur un iPhone réel
        manager = SocketManager(socketURL: URL(string: "http://localhost:8088")!, config: [.log(true), .compress])
        socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { _, _ in
            print("✅ Connecté à DiJia WebSocket")
        }
        
        
        socket.on(clientEvent: .disconnect) { _, _ in
            print("⚠️ Déconnecté de DiJia WebSocket")
        }

        socket.on(clientEvent: .error) { data, _ in
            print("❌ Erreur WebSocket :", data)
        }

        socket.on(clientEvent: .statusChange) { data, _ in
            print("🔁 Statut WebSocket :", data)
        }

        socket.on("message") { data, _ in
            if let msg = data.first as? String {
                DispatchQueue.main.async {
                    self.messages.append("DiJia : \(msg)")
                    
                    if self.messages.count > 100 {
                        self.messages.removeFirst()
                    }
                }
            }
        }

        socket.connect()
    }

    func sendMessage(_ text: String) {
        messages.append("Moi : \(text)")
        socket.emit("message", text)
    }
    
    private func addMessage(from sender: String, content: String) {
            let formatted = "\(sender) : \(content)"
            messages.append(formatted)
        }
    
}
