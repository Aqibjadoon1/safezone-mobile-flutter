# SafeZone Mobile Flutter

SafeZone Mobile is a Flutter redesign of the SafeZone neighbourhood safety and emergency response system. It uses the existing ASP.NET Core SafeZone repository as the backend/API reference and delivers a cinematic cyberpunk mobile-first UI inspired by the provided design reference.

## Demo Accounts

Use these accounts in demo mode:

- `resident@safezone.local` / `password123`
- `authority@safezone.local` / `password123`
- `admin@safezone.local` / `password123`
- `superadmin@safezone.local` / `password123`

## Setup

Install Flutter, then run:

```powershell
flutter create . --project-name safezone_mobile --platforms android,ios,web
flutter pub get
flutter run -d chrome
```

The committed source files are ready for Flutter. If platform folders are missing, `flutter create .` recreates them without replacing the app source.

## Backend Reference

This app is shaped around:

```text
https://github.com/Aqibjadoon1/VP_PROJECT_SAFEZONE_NEIGHBOURHOOD-SAFETY
```

The first milestone uses local demo repositories so the app is usable without a running backend. API seams are kept in `lib/core/network` and `lib/data/repositories`.

## Verification

Run these commands after Flutter is installed:

```powershell
dart format lib test
flutter analyze
flutter test
flutter build web
```

