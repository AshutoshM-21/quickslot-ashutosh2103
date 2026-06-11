# QuickSlot — Flutter App

Flutter mobile client for the QuickSlot sports venue booking platform.

**Production API:** `https://quickslot-ashutosh2103-production.up.railway.app`

---

## Download APK

**[Download app-release.apk](docs/apk/app-release.apk)**

Install on a physical Android device (enable unknown sources if prompted).

To rebuild and update the committed APK:

```bash
cd quickslot_app
flutter pub get
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk docs/apk/
```

---

## Screenshots

App screenshots are in [`docs/screenshots/`](docs/screenshots/):

| Screen | File |
|--------|------|
| User selection | `3d0ea47b-3e2c-4cbd-9d6c-f5d3c667e276.JPG` |
| Home — venues | `54dbefe8-9cee-409e-b3fe-9fa39d91f949.JPG` |
| Venue detail — slots | `2bceddec-64ca-4e3c-9ae2-08556bbd5859.JPG` |
| Review booking | `326daf35-b8ba-463e-a57b-fd306cdc9a0d.JPG` |
| My bookings | `c81fa746-acb3-49f0-8300-5c8cbe225ec1.JPG` |

![Home screen](docs/screenshots/54dbefe8-9cee-409e-b3fe-9fa39d91f949.JPG)

---

## Features

- **User selection** — Pick a demo user (Ashu or Test User) to simulate multi-user booking
- **Venue list** — Browse venues with cover images and sport tags
- **Multi-sport filtering** — Filter slots by sport at multi-sport venues
- **Slot booking** — Date picker, time-of-day filters, cult.fit-style schedule list
- **Live slot updates** — WebSocket pushes availability when another user books
- **My bookings** — View, cache, and cancel reservations
- **Dark theme** — Cult.fit-inspired teal UI

---

## Tech stack

- **Framework:** Flutter
- **State management:** flutter_bloc (Cubit)
- **Navigation:** go_router
- **Networking:** Dio + Socket.IO client
- **Local storage:** Hive
- **Architecture:** Feature-based clean architecture (data / domain / presentation)

---

## Prerequisites

- Flutter SDK 3.9+
- Android SDK (for APK builds)
- Running QuickSlot backend (local or Railway)

---

## Setup

```bash
cd quickslot_app
flutter pub get
```

API URLs are configured in `lib/core/constants/app_constants.dart` (defaults to Railway).

**Local backend:**

```bash
flutter run \
  --dart-define=API_BASE_URL=http://localhost:3000 \
  --dart-define=SOCKET_URL=http://localhost:3000
```

**Android emulator:** use `http://10.0.2.2:3000` for both values.

**Physical device + local backend:** use your machine's LAN IP.

---

## Run locally

1. Start the backend:

```bash
cd server
npm run dev
```

2. Run the app:

```bash
cd quickslot_app
flutter run
```

---

## Demo flow

1. Open the app → select a user (e.g. **Ashu**)
2. Browse venues on the home screen
3. Tap a venue → pick a date → filter sport/time → select a slot
4. Confirm the booking
5. Go to **My Bookings** to view or cancel
6. Switch to another user to show separate booking lists

---

## Project structure

```
lib/
├── app.dart                    # Root MaterialApp
├── main.dart                   # Entry point
├── core/
│   ├── constants/              # API URL, venue images
│   ├── di/                     # Dependency injection
│   ├── network/                # Dio API client
│   ├── router/                 # go_router routes
│   ├── theme/                  # Dark theme, sport visuals
│   └── widgets/                # Shared UI components
└── features/
    ├── auth/                   # User selection
    ├── venues/                 # Venue list, detail, slots
    └── bookings/               # Create, list, cancel bookings
```

---

## API integration

| Action | Endpoint |
|--------|----------|
| List venues | `GET /venues` |
| Get slots | `GET /venues/:id/slots?date=YYYY-MM-DD&sport=Badminton` |
| Create booking | `POST /bookings` (header: `X-User-Id`) |
| List user bookings | `GET /bookings/user/:userId` |
| Cancel booking | `DELETE /bookings/:bookingId` |
| Live updates | WebSocket `slot-updated` event |

---

## Tests

```bash
flutter test
```

---

## Related docs

- [Project README](../README.md) — Full project overview, screenshots, APK
- [Backend README](../server/README.md) — API, database, Railway deploy
