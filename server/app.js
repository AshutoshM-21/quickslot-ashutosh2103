const express = require("express");
const cors = require("cors");

const app = express();
const venueRoutes = require("./routes/venues");

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "QuickSlot API Running",
  });
});
app.use("/venues", venueRoutes);
module.exports = app;