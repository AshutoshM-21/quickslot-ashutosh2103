# QuickSlot Frontend

Flutter mobile app for browsing sports venues, viewing available time slots, and managing bookings.

## Features

- **User selection** — Pick a demo user (Ashu or Test User) to simulate multi-user booking
- **Venue list** — Browse available sports venues
- **Slot booking** — Select a date, view available slots, and book a time slot
- **My bookings** — View and cancel your bookings
- **Responsive UI** — Works across phone and tablet screen sizes

## Tech Stack

- **Framework:** Flutter
- **State management:** flutter_bloc (Cubit)
- **Navigation:** go_router
- **Networking:** Dio
- **Architecture:** Feature-based clean architecture (data / domain / presentation)

## Prerequisites

- Flutter SDK 3.9+
- A running QuickSlot backend at `http://localhost:3000` (see [server/README.md](../server/README.md))
- iOS Simulator, Android Emulator, or a physical device

## Setup

1. Install dependencies:

```bash
cd quickslot_app
flutter pub get
```

2. Confirm the API base URL in `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'http://localhost:3000';
```

For Android emulator, use `http://10.0.2.2:3000` instead of `localhost`.

For a physical device, use your machine's local IP (e.g. `http://192.168.1.x:3000`).

## Run Locally

1. Start the backend first:

```bash
cd server
npm run dev
```

2. Run the Flutter app:

```bash
cd quickslot_app
flutter run
```

## Demo Flow (for video)

1. Open the app → select a user (e.g. **Ashu**)
2. Browse venues on the home screen
3. Tap a venue → pick a date → select an available slot
4. Confirm the booking
5. Go to **My Bookings** to view or cancel it
6. Switch to another user to show separate booking lists

## Project Structure

```
quickslot_app/lib/
├── app.dart                    # Root MaterialApp
├── main.dart                   # Entry point
├── core/
│   ├── constants/              # App-wide constants (API URL, timeouts)
│   ├── di/                     # Dependency injection
│   ├── network/                # Dio API client
│   ├── router/                 # go_router routes
│   ├── theme/                  # Colors and theme
│   ├── utils/                  # Date/time helpers
│   └── widgets/                # Shared UI components
└── features/
    ├── auth/                   # User selection
    ├── venues/                 # Venue list, detail, slots
    └── bookings/               # Create, list, cancel bookings
```

Each feature follows:

```
feature/
├── data/           # Models, repositories (API calls)
├── domain/         # Entities
└── presentation/   # Cubits, pages, widgets
```

## API Integration

The app talks to these backend endpoints:

| Action | Endpoint |
|--------|----------|
| List venues | `GET /venues` |
| Get slots | `GET /venues/:id/slots?date=YYYY-MM-DD` |
| Create booking | `POST /bookings` (header: `X-User-Id`) |
| List user bookings | `GET /bookings/user/:userId` |
| Cancel booking | `DELETE /bookings/:bookingId` |

## Run Tests

```bash
flutter test
```
