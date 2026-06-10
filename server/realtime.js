let io = null;

function setIo(instance) {
  io = instance;
}

function emitSlotUpdate(payload) {
  if (!io) {
    return;
  }

  io.emit("slot-updated", payload);
}

module.exports = {
  setIo,
  emitSlotUpdate,
};
