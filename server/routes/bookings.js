const express = require("express");
const router = express.Router();
const pool = require("../db/pool");
const { emitSlotUpdate } = require("../realtime");

router.post("/", async (req, res) => {
  const client = await pool.connect();

  try {
    const { slotId } = req.body;
    const userId = req.header("X-User-Id");

    if (!slotId || !userId) {
      return res.status(400).json({
        success: false,
        message: "slotId and X-User-Id required",
      });
    }

    await client.query("BEGIN");

    const slotResult = await client.query(
      `
      SELECT *
      FROM slots
      WHERE id = $1
      FOR UPDATE
      `,
      [slotId]
    );

    if (slotResult.rows.length === 0) {
      await client.query("ROLLBACK");

      return res.status(404).json({
        success: false,
        message: "Slot not found",
      });
    }

    const slot = slotResult.rows[0];

    if (slot.status === "BOOKED") {
      await client.query("ROLLBACK");

      return res.status(409).json({
        success: false,
        message: "Slot already booked",
      });
    }

    const bookingResult = await client.query(
      `
      INSERT INTO bookings(user_id, slot_id)
      VALUES ($1,$2)
      RETURNING *
      `,
      [userId, slotId]
    );

    await client.query(
      `
      UPDATE slots
      SET status='BOOKED'
      WHERE id=$1
      `,
      [slotId]
    );

    await client.query("COMMIT");

    emitSlotUpdate({
      venueId: slot.venue_id,
      slotId: slot.id,
      date: slot.slot_date,
      status: "BOOKED",
    });

    return res.status(201).json({
      success: true,
      data: bookingResult.rows[0],
    });

  } catch (error) {
    await client.query("ROLLBACK");

    console.error(error);

    return res.status(500).json({
      success: false,
      message: "Booking failed",
    });
  } finally {
    client.release();
  }
});

router.get("/user/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    const result = await pool.query(
      `
      SELECT
        b.id,
        b.created_at,
        v.name as venue_name,
        s.slot_date,
        s.start_time,
        s.end_time
      FROM bookings b
      JOIN slots s ON b.slot_id = s.id
      JOIN venues v ON s.venue_id = v.id
      WHERE b.user_id = $1
      ORDER BY b.created_at DESC
      `,
      [userId]
    );

    res.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch bookings",
    });
  }
});
router.delete("/:bookingId", async (req, res) => {
  const client = await pool.connect();

  try {
    const { bookingId } = req.params;

    await client.query("BEGIN");

    const bookingResult = await client.query(
      `
      SELECT b.*, s.venue_id, s.slot_date
      FROM bookings b
      JOIN slots s ON b.slot_id = s.id
      WHERE b.id = $1
      FOR UPDATE OF b
      `,
      [bookingId]
    );

    if (bookingResult.rows.length === 0) {
      await client.query("ROLLBACK");

      return res.status(404).json({
        success: false,
        message: "Booking not found",
      });
    }

    const booking = bookingResult.rows[0];

    await client.query(
      `
      UPDATE slots
      SET status='AVAILABLE'
      WHERE id=$1
      `,
      [booking.slot_id]
    );

    await client.query(
      `
      DELETE FROM bookings
      WHERE id=$1
      `,
      [bookingId]
    );

    await client.query("COMMIT");

    emitSlotUpdate({
      venueId: booking.venue_id,
      slotId: booking.slot_id,
      date: booking.slot_date,
      status: "AVAILABLE",
    });

    res.json({
      success: true,
      message: "Booking cancelled",
    });

  } catch (error) {
    await client.query("ROLLBACK");

    console.error(error);

    res.status(500).json({
      success: false,
      message: "Cancellation failed",
    });
  } finally {
    client.release();
  }
});
module.exports = router;