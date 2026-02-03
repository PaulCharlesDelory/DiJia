# 🤖 DiJia

**DiJia** est une application mobile iOS permettant de discuter en temps réel avec des intelligences artificielles personnalisées.  
L’objectif est de proposer une expérience immersive, fluide et humaine, avec un chat temps réel et une architecture scalable.

---

## ✨ Fonctionnalités

- 💬 Chat temps réel avec une IA via WebSockets
- 🧠 IA basée sur l’API OpenAI
- ⚡ Réponses instantanées
- 📱 Application iOS en SwiftUI
- 🌙 Interface sombre moderne
- 🔊 Feedback sonore à l’envoi des messages
- 🧩 Architecture backend modulaire (Node.js + FastAPI)

---

## 🧱 Architecture du projet

DiJia/
├── ios_app/ # Application iOS SwiftUI
│ ├── ContentView.swift
│ ├── WebSocketManager.swift
│ └── DiJiaAppApp.swift
│
├── fastapi_api/ # Backend IA (Python / FastAPI)
│ ├── main.py
│ └── requirements.txt
│
├── node_backend/ # Serveur WebSocket (Node.js)
│ ├── server.js
│ ├── package.json
│ └── package-lock.json
│
├── nginx.conf # Reverse proxy / load balancing
└── README.md


---

## 🛠️ Technologies utilisées

### Frontend (iOS)
- SwiftUI
- Socket.IO Client
- AVFoundation

### Backend
- **FastAPI** (Python)
- **Node.js + Express**
- **Socket.IO**
- **OpenAI API**

### Infrastructure
- WebSockets
- Nginx (load balancing)
- Docker (prévu)

---

## 🚀 Lancement du projet en local

### 1️⃣ Backend FastAPI

```bash
cd fastapi_api
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
