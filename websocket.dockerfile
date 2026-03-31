FROM node:lts-alpine
WORKDIR /app

RUN npm init -y && \
    npm install y-websocket ws && \
    sed -i 's/}/, "type": "module"}/' package.json

# 직접 실행 스크립트 작성
RUN echo "import { setupWSConnection } from './node_modules/y-websocket/bin/utils.js'; \
import { WebSocketServer } from 'ws'; \
import http from 'http'; \
const port = process.env.PORT || 1234; \
const server = http.createServer((req, res) => { \
  res.writeHead(200, { 'Content-Type': 'text/plain' }); \
  res.end('WaffleBear Y-Websocket Server Running'); \
}); \
const wsServer = new WebSocketServer({ noServer: true }); \
wsServer.on('connection', (conn, req) => { \
  setupWSConnection(conn, req); \
}); \
server.on('upgrade', (request, socket, head) => { \
  wsServer.handleUpgrade(request, socket, head, (ws) => { \
    wsServer.emit('connection', ws, request); \
  }); \
}); \
server.listen(port, '0.0.0.0', () => { \
  console.log('Y-Websocket server is running on port ' + port); \
});" > /app/server.js

ENV HOST=0.0.0.0
ENV PORT=1234
EXPOSE 1234

CMD ["node", "server.js"]