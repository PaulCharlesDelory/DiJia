import express from 'express';
import http from 'http';
import axios from 'axios';
import { Server } from 'socket.io';

const app = express();
const port = process.env.PORT || 8088;
const server = http.createServer(app);


const io = new Server(server, {
  cors: { 
    origin: '*',
  },
});


io.on('connection', (socket) => {
  console.log(`📡 Client connecté : ${socket.id}`);

  socket.on('message', async (msg) => {
    console.log(`📥 Message reçu : "${msg}"`);

    try {
      const response = await axios.post('http://localhost:8000/api/message', {
        user_id: socket.id,
        content: msg
      });

      const aiReply = response.data.response;
      console.log(`🤖 Réponse de l'IA : "${aiReply}"`);

      socket.emit('message', aiReply);
    } catch (err) {
      console.error('❌ Erreur FastAPI →', err.message);
      socket.emit('message', '⚠️ Erreur du serveur IA.');
    }
  });
});

server.listen(port, () => {
  console.log(`🚀 Serveur Node.js en écoute sur le port ${port}`);
});