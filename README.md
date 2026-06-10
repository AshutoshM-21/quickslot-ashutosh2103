# QuickSlot

Sports venue slot booking app — browse venues, book time slots, and manage reservations.

## Project Structure

```
quickSlot/
├── server/          # Express.js REST API (Node.js + PostgreSQL)
└── quickslot_app/   # Flutter mobile app
```

## Quick Start (Local)

### 1. Backend

```bash
cd server
npm install
# create .env with DATABASE_URL
npm run dev
```

API runs at **http://localhost:3000**. for now

### 2. Frontend

```bash
cd quickslot_app
flutter pub get
flutter run
```

Make sure the backend is running before launching the app.

## Documentation

- [Backend README](server/README.md) — API setup, endpoints, database
- [Frontend README](quickslot_app/README.md) — Flutter setup, features, demo flow
