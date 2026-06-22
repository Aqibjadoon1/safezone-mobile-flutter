# SafeZone Mobile Flutter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a polished cyberpunk SafeZone Flutter application that mirrors the existing SafeZone web product with mobile-first resident, authority, admin, map, FIR, SOS, Kanban, notification, and landing experiences.

**Architecture:** Create a feature-first Flutter app with Riverpod state, GoRouter navigation, Dio API seams, local demo repositories, and reusable cyberpunk design-system widgets. The first milestone ships a functional demo/local app that can later point at the existing ASP.NET Core backend through the same repository interfaces.

**Tech Stack:** Flutter, Dart, Material 3, Riverpod, GoRouter, Dio, SharedPreferences, Flutter Secure Storage, flutter_map, geolocator, permission_handler, intl, uuid, file_picker, image_picker, local notifications, SignalR package where available.

---

## File Structure

- `pubspec.yaml`: app metadata and dependencies.
- `analysis_options.yaml`: Flutter linting.
- `README.md`: setup, demo credentials, backend reference, build/test notes.
- `.env.example`: runtime configuration keys.
- `lib/main.dart`: app bootstrap and ProviderScope.
- `lib/app/safezone_app.dart`: MaterialApp.router, theme, router.
- `lib/app/router.dart`: role-aware GoRouter routes.
- `lib/core/theme/*`: colors, typography, theme, effects.
- `lib/core/models/*`: enums and domain models.
- `lib/core/utils/*`: status/severity presentation and validators.
- `lib/core/network/*`: API config and Dio client.
- `lib/core/storage/*`: token and settings storage.
- `lib/data/demo/*`: seeded demo data.
- `lib/data/repositories/*`: repository interfaces and demo implementations.
- `lib/shared/widgets/*`: reusable buttons, cards, badges, app shells, inputs, states.
- `lib/features/landing/*`: cinematic landing page.
- `lib/features/auth/*`: splash, onboarding, login, register, forgot password.
- `lib/features/resident/*`: resident dashboard and workflows.
- `lib/features/authority/*`: command dashboard and authority workflows.
- `lib/features/admin/*`: user management and admin analytics.
- `lib/features/ai_calling/*`: ElevenLabs support screen.
- `test/*`: focused unit/widget tests.

## Task 1: Scaffold Flutter Project

**Files:**
- Create/Modify: Flutter project files at repository root.
- Create: `.env.example`
- Create: `README.md`

- [ ] **Step 1: Generate the Flutter project**

Run:

```powershell
flutter create . --project-name safezone_mobile --platforms android,ios,web
```

Expected: Flutter creates `lib/main.dart`, platform folders, `pubspec.yaml`, and test scaffolding.

- [ ] **Step 2: Replace `pubspec.yaml` dependencies**

Use these dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.5.1
  go_router: ^14.2.7
  dio: ^5.7.0
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.3.2
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  geolocator: ^13.0.1
  permission_handler: ^11.3.1
  signalr_netcore: ^1.4.0
  firebase_messaging: ^15.1.3
  flutter_local_notifications: ^17.2.3
  image_picker: ^1.1.2
  file_picker: ^8.1.2
  intl: ^0.19.0
  uuid: ^4.5.1
  google_fonts: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

- [ ] **Step 3: Fetch packages**

Run:

```powershell
flutter pub get
```

Expected: dependencies resolve successfully.

- [ ] **Step 4: Commit scaffold**

Run:

```powershell
git add .
git commit -m "chore: scaffold Flutter project"
```

## Task 2: Build Core Domain And Presentation Utilities

**Files:**
- Create: `lib/core/models/safezone_enums.dart`
- Create: `lib/core/models/safezone_models.dart`
- Create: `lib/core/utils/status_presenter.dart`
- Test: `test/status_presenter_test.dart`

- [ ] **Step 1: Add enum/model definitions**

Define roles, statuses, severities, emergency types, users, incidents, FIRs, SOS logs, alerts, notifications, dashboard stats, and map points.

- [ ] **Step 2: Add status presenter tests**

Test that `IncidentStatus.inProgress` becomes `In Progress`, `FirStatus.underReview` becomes `Under Review`, and unknown fallback labels become `Unknown`.

- [ ] **Step 3: Implement status presenter**

Implement centralized label, color key, icon key, and urgency helpers.

- [ ] **Step 4: Run tests and commit**

Run:

```powershell
flutter test test/status_presenter_test.dart
git add lib/core test/status_presenter_test.dart
git commit -m "feat: add SafeZone domain presentation models"
```

## Task 3: Build Theme And Shared Widgets

**Files:**
- Create: `lib/core/theme/safezone_colors.dart`
- Create: `lib/core/theme/safezone_theme.dart`
- Create: `lib/shared/widgets/cyber_button.dart`
- Create: `lib/shared/widgets/glass_card.dart`
- Create: `lib/shared/widgets/status_badge.dart`
- Create: `lib/shared/widgets/metric_card.dart`
- Create: `lib/shared/widgets/empty_state.dart`
- Create: `lib/shared/widgets/loading_state.dart`
- Test: `test/status_badge_test.dart`

- [ ] **Step 1: Write badge widget test**

Test that a badge for `In Progress` renders friendly text and never renders `InProgress`.

- [ ] **Step 2: Implement theme**

Add dark Material 3 theme with Space Grotesk/Inter fonts, black surfaces, red/cyan/green accents, rounded cards, and button styles.

- [ ] **Step 3: Implement reusable widgets**

Add reusable cards, badges, buttons, loading shimmer approximation, metric cards, and empty states.

- [ ] **Step 4: Run tests and commit**

Run:

```powershell
flutter test test/status_badge_test.dart
git add lib/core/theme lib/shared test/status_badge_test.dart
git commit -m "feat: add cyberpunk design system"
```

## Task 4: Add Demo Repositories And App State

**Files:**
- Create: `lib/data/demo/demo_seed.dart`
- Create: `lib/data/repositories/safezone_repository.dart`
- Create: `lib/data/repositories/demo_safezone_repository.dart`
- Create: `lib/data/providers.dart`
- Create: `lib/core/network/api_client.dart`
- Create: `lib/core/storage/session_store.dart`
- Test: `test/demo_repository_test.dart`

- [ ] **Step 1: Write repository tests**

Test login, incident creation, FIR creation, SOS creation, Kanban transition validation, and notification read state.

- [ ] **Step 2: Implement repository interfaces**

Define auth, incident, FIR, SOS, alert, notification, map, analytics, and user management methods.

- [ ] **Step 3: Implement demo repository**

Use in-memory seeded data and `ChangeNotifier`/Riverpod state objects to make submitted incidents/FIRs/SOS records appear in lists immediately.

- [ ] **Step 4: Add API client seams**

Create Dio client configuration with base URL, authorization interceptor placeholder, and friendly error mapping.

- [ ] **Step 5: Run tests and commit**

Run:

```powershell
flutter test test/demo_repository_test.dart
git add lib/data lib/core/network lib/core/storage test/demo_repository_test.dart
git commit -m "feat: add SafeZone demo data repositories"
```

## Task 5: Build Router, Shells, Auth, And Landing

**Files:**
- Create: `lib/app/safezone_app.dart`
- Create: `lib/app/router.dart`
- Replace: `lib/main.dart`
- Create: `lib/features/auth/*`
- Create: `lib/features/landing/*`
- Create: `lib/shared/widgets/app_shell.dart`
- Test: `test/router_auth_test.dart`

- [ ] **Step 1: Write router tests**

Test unauthenticated users redirect to login for app routes, residents land on resident dashboard, and authority users land on command dashboard.

- [ ] **Step 2: Implement auth controller**

Support splash, demo login, register, forgot password success state, logout, and current role.

- [ ] **Step 3: Implement GoRouter**

Add public landing/auth routes and protected role-aware app routes.

- [ ] **Step 4: Implement landing page**

Build the dark hero, floating alert cards, radar visual, white rounded content section, dark stats, dashboard previews, and final CTA.

- [ ] **Step 5: Implement auth screens**

Build splash, onboarding, login, register, and forgot password with cyberpunk styling and validation.

- [ ] **Step 6: Run tests and commit**

Run:

```powershell
flutter test test/router_auth_test.dart
git add lib/main.dart lib/app lib/features/auth lib/features/landing lib/shared/widgets/app_shell.dart test/router_auth_test.dart
git commit -m "feat: add routing landing and auth flows"
```

## Task 6: Build Resident Workflows

**Files:**
- Create: `lib/features/resident/dashboard/*`
- Create: `lib/features/resident/incidents/*`
- Create: `lib/features/resident/firs/*`
- Create: `lib/features/resident/sos/*`
- Create: `lib/features/resident/map/*`
- Create: `lib/features/resident/notifications/*`
- Create: `lib/features/resident/profile/*`
- Test: `test/resident_workflows_test.dart`

- [ ] **Step 1: Write workflow tests**

Test incident validation, successful incident submission, FIR wizard validation, successful FIR submission, SOS creation, and notification read action.

- [ ] **Step 2: Implement resident dashboard**

Show metric cards, SOS status, safety status, quick actions, recent incidents, and notifications.

- [ ] **Step 3: Implement incident reporting**

Build category, severity, title, description, location selector, anonymous toggle, submission, and success screen.

- [ ] **Step 4: Implement FIR wizard**

Build five-step wizard, evidence attachment UI, declaration checkbox, review, and success screen.

- [ ] **Step 5: Implement SOS**

Build large animated red SOS button, emergency type picker, location/manual fallback, and confirmation state.

- [ ] **Step 6: Implement map and lists**

Build `flutter_map` screen with markers, marker details sheet, My Incidents, My FIRs, notifications, profile, and settings.

- [ ] **Step 7: Run tests and commit**

Run:

```powershell
flutter test test/resident_workflows_test.dart
git add lib/features/resident test/resident_workflows_test.dart
git commit -m "feat: add resident SafeZone workflows"
```

## Task 7: Build Authority, Admin, And AI Workflows

**Files:**
- Create: `lib/features/authority/dashboard/*`
- Create: `lib/features/authority/field_reports/*`
- Create: `lib/features/authority/kanban/*`
- Create: `lib/features/authority/firs/*`
- Create: `lib/features/authority/sos_logs/*`
- Create: `lib/features/authority/alerts/*`
- Create: `lib/features/admin/*`
- Create: `lib/features/ai_calling/*`
- Test: `test/authority_workflows_test.dart`

- [ ] **Step 1: Write authority tests**

Test Kanban allowed/blocked transitions, FIR review state, SOS handled state, broadcast alert creation, and user activation toggle.

- [ ] **Step 2: Implement authority dashboard**

Show command metrics, active alerts, recent incidents, and quick actions.

- [ ] **Step 3: Implement field reports and dispatch map**

Add filters, search, incident detail, status updates, response notes, and map markers.

- [ ] **Step 4: Implement Kanban**

Add responsive columns, draggable cards on wide screens, tap-to-move on mobile, transition validation, and snackbars.

- [ ] **Step 5: Implement FIR management and SOS logs**

Add filters, details, accept/reject/close actions, review remarks, handled status, and map links.

- [ ] **Step 6: Implement alerts, admin, and AI calling**

Add broadcast alert form, user management, analytics/settings panels, and ElevenLabs web/native fallback screen.

- [ ] **Step 7: Run tests and commit**

Run:

```powershell
flutter test test/authority_workflows_test.dart
git add lib/features/authority lib/features/admin lib/features/ai_calling test/authority_workflows_test.dart
git commit -m "feat: add authority admin and AI workflows"
```

## Task 8: Polish, Verify, And Publish

**Files:**
- Modify: `README.md`
- Modify: `.env.example`
- Modify: `.gitignore`

- [ ] **Step 1: Add documentation**

Document demo accounts:

```text
resident@safezone.local / password123
authority@safezone.local / password123
admin@safezone.local / password123
superadmin@safezone.local / password123
```

- [ ] **Step 2: Run formatting and analysis**

Run:

```powershell
dart format lib test
flutter analyze
flutter test
flutter build web
```

Expected: all commands complete successfully.

- [ ] **Step 3: Fix failures**

For any analyzer/test/build failure, update the relevant file and rerun the failing command until it passes.

- [ ] **Step 4: Commit final polish**

Run:

```powershell
git add .
git commit -m "chore: polish SafeZone Flutter delivery"
```

- [ ] **Step 5: Create and push public GitHub repository**

If GitHub CLI authentication is available, run:

```powershell
gh repo create Aqibjadoon1/safezone-mobile-flutter --public --source . --remote origin --push
```

If GitHub CLI is not authenticated, run `gh auth login` first or create the empty public repository manually and push:

```powershell
git remote add origin https://github.com/Aqibjadoon1/safezone-mobile-flutter.git
git branch -M main
git push -u origin main
```

## Self-Review

- Spec coverage: landing, auth, resident, authority, admin, AI calling, map, FIR, SOS, Kanban, notifications, status rendering, demo mode, API seams, docs, and repository publishing are covered.
- Placeholder scan: no implementation step relies on TBD/TODO language.
- Type consistency: enum/status terminology follows the reference SafeZone backend and the approved design spec.

