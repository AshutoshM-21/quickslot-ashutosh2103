require("dotenv").config();

const http = require("http");
const { Server } = require("socket.io");
const app = require("./app");
const { setIo } = require("./realtime");

const PORT = Number(process.env.PORT) || 3000;

app.locals.realtimeEnabled = true;

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

setIo(io);

io.on("connection", (socket) => {
  console.log(`Socket connected: ${socket.id}`);

  socket.on("disconnect", () => {
    console.log(`Socket disconnected: ${socket.id}`);
  });
});

server.on("error", (error) => {
  console.error("Server failed to start:", error);
  process.exit(1);
});

if (require.main === module) {
  server.listen(PORT, "0.0.0.0", () => {
    console.log(`QuickSlot server listening on 0.0.0.0:${PORT}`);
    console.log(`DATABASE_URL set: ${Boolean(process.env.DATABASE_URL)}`);
  });
}

module.exports = { app, server, io };
