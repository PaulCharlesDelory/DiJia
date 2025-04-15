FROM node:18
WORKDIR /app
COPY server.js .
RUN npm install express socket.io axios
EXPOSE 3000
CMD ["node", "server.js"]