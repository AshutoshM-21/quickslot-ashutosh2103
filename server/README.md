# QuickSlot Backend

REST API + WebSocket server for the QuickSlot sports venue booking app. Built with Express.js, PostgreSQL, and Socket.IO.

## Tech Stack

- **Runtime:** Node.js
- **Framework:** Express 5
- **Database:** PostgreSQL (`pg`)
- **Realtime:** Socket.IO (slot availability updates)
- **Other:** CORS, dotenv

## Prerequisites

- Node.js 18+
- PostgreSQL database (local, Neon, Supabase, or Railway PostgreSQL)

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

3. Run the multi-sport migration:

```sql
ALTER TABLE slots ADD COLUMN IF NOT EXISTS sport VARCHAR(50);
ALTER TABLE venues ADD COLUMN IF NOT EXISTS sports TEXT;
```

Or run the full file:

```bash
psql $DATABASE_URL -f db/migrations/001_add_sport_support.sql
```

4. Ensure your database has seed data. See `db/seed.sql` for multi-sport examples.

## Run Locally (REST + WebSocket)

```bash
npm run dev
```

The API and WebSocket server start at **http://localhost:3000**.

```bash
curl http://localhost:3000/
```

Expected response:

```json
{ "success": true, "message": "QuickSlot API Running", "realtime": true }
```

## Deploy to Railway (REST + WebSocket)

Railway runs the full `server.js` process, so both REST and Socket.IO work.

### 1. Create a Railway project

1. Go to [railway.app](https://railway.app) and create a new project.
2. **Add PostgreSQL** — click **+ New** → **Database** → **PostgreSQL**.
3. **Add the API service** — click **+ New** → **GitHub Repo** → select this repository.
4. Open **Variables** → add a reference variable:
   - `DATABASE_URL` → `${{Postgres.DATABASE_URL}}` (use your Postgres service name)
6. Open **Settings** → **Networking** → **Generate Domain** (e.g. `quickslot-api-production.up.railway.app`).

The repo root `railway.toml` builds and starts the `server/` directory automatically — you do **not** need to set a root directory manually.

If the deploy shows "Application failed to respond", open **Deployments → View Logs** and check for:
- `DATABASE_URL set: false` → link Postgres via a reference variable
- `Cannot find module` → redeploy after pulling latest `railway.toml`
- `EADDRINUSE` → Railway sets `PORT` automatically; do not hardcode it

### 2. Run the DB migration on Railway Postgres

In Railway, open your PostgreSQL service → **Data** → **Query**, and run:

```sql
ALTER TABLE slots ADD COLUMN IF NOT EXISTS sport VARCHAR(50);
ALTER TABLE venues ADD COLUMN IF NOT EXISTS sports TEXT;

UPDATE slots s
SET sport = v.sport
FROM venues v
WHERE s.venue_id = v.id AND s.sport IS NULL AND v.sport IS NOT NULL;

UPDATE venues SET sports = sport WHERE sports IS NULL AND sport IS NOT NULL;
UPDATE slots SET sport = 'Sports' WHERE sport IS NULL;
```

### 3. Point the Flutter app at Railway

```bash
flutter run \
  --dart-define=API_BASE_URL=https://your-app.up.railway.app \
  --dart-define=SOCKET_URL=https://your-app.up.railway.app
```

Use the same Railway domain for both values.

### 4. Verify deployment

```bash
curl https://your-app.up.railway.app/
```

Look for `"realtime": true`.

---

**Note:** The old Vercel deployment (`api/index.js`) is REST-only and does **not** support WebSockets. Use Railway for production.

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/` | Health check (`realtime: true` when WebSocket server is running) |
| `GET` | `/venues` | List all venues (includes `sports` array) |
| `GET` | `/venues/:id/slots?date=YYYY-MM-DD&sport=Badminton` | Get slots, optionally filtered by sport |
| `POST` | `/bookings` | Create a booking |
| `GET` | `/bookings/user/:userId` | Get bookings for a user |
| `DELETE` | `/bookings/:bookingId` | Cancel a booking |

### WebSocket Events

| Event | Direction | Payload |
|-------|-----------|---------|
| `slot-updated` | Server → Client | `{ venueId, slotId, date, status }` |

Emitted when a slot is booked or cancelled.

## Project Structure

```
server/
├── app.js              # Express app setup and routes
├── server.js           # Entry point (REST + Socket.IO)
├── railway.toml        # Railway deploy config
├── Procfile            # Process start command
├── db/
│   ├── pool.js
│   ├── sport-utils.js
│   ├── migrations/
│   └── seed.sql
├── routes/
│   ├── venues.js
│   └── bookings.js
├── realtime.js
└── package.json
```

## Database Schema

- **venues** — `id`, `name`, `location`, `description`, `sport` (legacy), `sports` (comma-separated), `image_url` (cover photo URL)
- **slots** — `id`, `venue_id`, `slot_date`, `start_time`, `end_time`, `status`, `sport`
- **bookings** — `id`, `user_id`, `slot_id`, `created_at`

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start with nodemon (REST + WebSocket) |
| `npm start` | Start production server (used by Railway) |
