const express = require("express");
const router = express.Router();
const pool = require("../db/pool");
const { formatVenueRow } = require("../db/sport-utils");

// Get all venues endpoint
router.get("/", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT *
      FROM venues
      ORDER BY id
    `);

    res.status(200).json({
      success: true,
      data: result.rows.map(formatVenueRow),
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch venues",
    });
  }
});

// Venue slots endpoint
router.get("/:id/slots", async (req, res) => {
  try {
    const venueId = parseInt(req.params.id);
    const date = req.query.date;
    const sport = req.query.sport;

    if (!date) {
      return res.status(400).json({
        success: false,
        message: "Date is required",
      });
    }

    const params = [venueId, date];
    let sportClause = "";

    if (sport) {
      params.push(sport);
      sportClause = `AND COALESCE(s.sport, v.sport, 'Sports') = $${params.length}`;
    }

    const result = await pool.query(
      `
      SELECT
        s.id,
        s.start_time,
        s.end_time,
        s.status,
        COALESCE(s.sport, v.sport, 'Sports') AS sport
      FROM slots s
      JOIN venues v ON v.id = s.venue_id
      WHERE s.venue_id = $1
      AND s.slot_date = $2
      ${sportClause}
      ORDER BY s.start_time, sport
      `,
      params
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
