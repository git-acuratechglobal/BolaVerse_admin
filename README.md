# BolaVersa Admin

Full Flutter Admin Panel dashboard application for the **BolaVersa** football prediction and league management platform.

## Features

- **Admin Authentication**: Static preview credentials:
  - **Email**: `Admin@yomail.com`
  - **Password**: `Admin@123`
- **Dashboard Overview**: Key performance indicators (Total Users, Active Leagues, Live Matches, Predictions Today), recent signups, and live fixtures.
- **Users Management**: Filterable user roster displaying XP, global rank, nationality, join date, status pills (Active/Suspended), and actions.
- **Leagues Management**: Filter leagues by type (Public, Private, Global, Challenge) with member count progression and management tools.
- **Competitions**: Track tournament seasons, status, match counts, and branding across Premier League, UEFA Champions League, La Liga, Serie A, etc.
- **Live & Upcoming Fixtures**: Match monitoring with score reporting, kickoff timestamps, and status pills (LIVE, HT, SCHEDULED, FINISHED).

## Tech Stack

- **Flutter**: Modern Flutter 3.24+ multiplatform app.
- **State Management**: Flutter Riverpod (`flutter_riverpod`).
- **Routing**: GoRouter (`go_router`) with declarative auth guards.
- **Design System**: Dark theme (`#0F1218`) with neon green (`#00DF82`) and cyan accents.

## Getting Started

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Run the application
To run on Chrome (recommended for Admin web panel):
```bash
flutter run -d chrome
```

To run on macOS Desktop:
```bash
flutter run -d macos
```

To run on Android emulator or connected device:
```bash
flutter run -d android
```

### 3. Build for Production Web
```bash
flutter build web --release
```
The output will be generated in `build/web/`.
