# QuickSlot Backend

REST API for the QuickSlot sports venue booking app. Built with Express.js and PostgreSQL.

## Tech Stack

- **Runtime:** Node.js
- **Framework:** Express 5
- **Database:** PostgreSQL (`pg`)
- **Other:** CORS, dotenv

## Prerequisites

- Node.js 18+
- PostgreSQL database (local or hosted, e.g. Neon, Supabase)

## Setup

1. Install dependencies:

```bash
cd server
npm install
```

2. Create a `.env` file in the `server` directory:

```env
DATABASE_URL=postgresql://user:password@host:5432/dbname
PORT=3000
```

3. Ensure your database has the required tables (`venues`, `slots`, `bookings`) with seed data.

## Run Locally

```bash
npm run dev
```

The API starts at **http://localhost:3000**.

To verify it is running:

```bash
curl http://localhost:3000/
```

Expected response:

```json
{ "success": true, "message": "QuickSlot API Running" }
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/` | Health check |
| `GET` | `/venues` | List all venues |
| `GET` | `/venues/:id/slots?date=YYYY-MM-DD` | Get slots for a venue on a date |
| `POST` | `/bookings` | Create a booking |
| `GET` | `/bookings/user/:userId` | Get bookings for a user |
| `DELETE` | `/bookings/:bookingId` | Cancel a booking |

### Create Booking

```bash
curl -X POST http://localhost:3000/bookings \
  -H "Content-Type: application/json" \
  -H "X-User-Id: 1" \
  -d '{"slotId": 1}'
```

### Get Slots

```bash
curl "http://localhost:3000/venues/1/slots?date=2026-06-10"
```

## Project Structure

```
server/
├── app.js              # Express app setup and routes
├── server.js           # Local dev entry point
├── db/
│   └── pool.js         # PostgreSQL connection pool
├── routes/
│   ├── venues.js       # Venue and slot endpoints
│   └── bookings.js     # Booking endpoints
├── package.json
└── .env                # Environment variables (not committed)
```

## Database Schema

The API expects these tables:

- **venues** — `id`, `name`, `location`, `sport`, etc.
- **slots** — `id`, `venue_id`, `slot_date`, `start_time`, `end_time`, `status` (`AVAILABLE` / `BOOKED`)
- **bookings** — `id`, `user_id`, `slot_id`, `created_at`

Booking creation uses a database transaction with row-level locking (`FOR UPDATE`) to prevent double-booking.

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start with nodemon (auto-reload) |
| `npm start` | Start production server |
