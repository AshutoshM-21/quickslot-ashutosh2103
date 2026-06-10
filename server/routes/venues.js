const express = require("express");
const router = express.Router();
const pool = require("../db/pool");

//Get all venues endpoint
router.get("/", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT *
      FROM venues
      ORDER BY id
    `);

    res.status(200).json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch venues",
    });
  }
});

//Venue slots endpoint
router.get("/:id/slots", async (req, res) => {
  try {
    const venueId = parseInt(req.params.id);
    const date = req.query.date;

    if (!date) {
      return res.status(400).json({
        success: false,
        message: "Date is required",
      });
    }

    const result = await pool.query(
      `
      SELECT
        id,
        start_time,
        end_time,
        status
      FROM slots
      WHERE venue_id = $1
      AND slot_date = $2
      ORDER BY start_time
      `,
      [venueId, date]
    );

    res.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch slots",
    });
  }
});
module.exports = router;
