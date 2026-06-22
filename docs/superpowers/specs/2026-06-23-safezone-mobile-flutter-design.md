# SafeZone Mobile Flutter Design

Date: 2026-06-23
Repository: safezone-mobile-flutter
Reference product: Aqibjadoon1/VP_PROJECT_SAFEZONE_NEIGHBOURHOOD-SAFETY

## Goal

Build SafeZone Mobile, a mobile-first Flutter application for Android, iOS, and Flutter Web. The app adapts the existing SafeZone neighbourhood safety platform into a polished cyberpunk emergency command experience.

The existing ASP.NET Core/Blazor SafeZone repository is the domain and API reference. The pasted cyberpunk landing screenshot is the visual reference, adapted for public safety rather than copied content.

## Scope

The first complete build will include:

- Cinematic public landing page.
- Splash, onboarding, login, registration, forgot password, and logout flows.
- Role-aware navigation for Resident, Authority, Admin, and SuperAdmin.
- Resident dashboard, incident reporting, FIR wizard, SOS flow, map, notifications, profile, and settings.
- Authority/Admin command dashboard, field reports, dispatch map, Kanban board, FIR management, SOS logs, broadcast alerts, and user management.
- SuperAdmin command center screens that reuse the authority surfaces with expanded access.
- AI calling screen with Flutter Web support for the ElevenLabs ConvAI embed and native/mobile fallback messaging.
- API client layer shaped around the existing ASP.NET Core endpoints.
- Local demo mode with seeded mock data so the UI remains usable when the backend is not running.
- README, environment template, demo credentials, and build/test instructions.

The new app will not duplicate the backend in the first milestone because the provided repository already contains ASP.NET Core APIs, models, migrations, SignalR hubs, services, tests, and deployment docs. The Flutter app will integrate with that backend contract.

## Visual Direction

SafeZone Mobile should look like a futuristic emergency command system:

- Deep black and charcoal backgrounds.
- Large bold uppercase typography inspired by the reference image.
- White rounded editorial content sections on the landing page.
- Emergency red for danger, SOS, critical incidents, and fire/police urgency.
- Neon green and cyan for safe, active, online, secured, and live monitoring states.
- Glassmorphism cards with thin borders, blur, glow, and subtle hover/press lift.
- Radar rings, map grid lines, alert dots, scan effects, and pulse animations.
- Dashboard cards with big numbers, small technical labels, and compact mini chart motifs.
- No NFT, samurai, or copied image content from the reference. All imagery and motifs must serve neighbourhood safety, emergency response, digital maps, dispatch, and command center themes.

## Landing Page

The landing page will use the reference image structure:

1. Dark full-screen cinematic hero.
   - Top navigation with SafeZone mark/name, Sign In, and Get Started/Menu.
   - Headline such as "DIGITAL SAFETY COMMAND" or "YOUR NEIGHBOURHOOD PROTECTED".
   - Technical subtitle about real-time incident reporting, SOS, FIRs, and authority response.
   - CTA buttons: Join SafeZone and Sign In.
   - Floating glass alert cards: Fire Alert, Zone Secured, Suspicious Activity, Emergency Online.
   - Generated/illustrated tactical city, radar, or emergency responder visual built with Flutter widgets/canvas rather than copied assets.

2. Large white rounded-top editorial section.
   - Big SafeZone explanation with mixed black/gray emphasis.
   - Oversized background word treatment such as PROTECTED or COMMAND.
   - Four feature blocks: Real-time Incident Reporting, Digital FIR System, AI Emergency Calling, Authority Command Center.
   - Safety map/radar/responder visual panel.

3. Dark stats section.
   - Glass stat cards for Total Incidents, Active Authorities, FIRs Processed, and SOS Calls Handled.
   - Large white numbers, small labels, red/cyan/green accents, and mini chart lines.

4. Dashboard preview section.
   - Resident dashboard, Authority dashboard, Map screen, and SOS screen preview cards.
   - Rounded cards with shadows and neon borders.

5. Final CTA.
   - Dark cinematic closing section with "Ready to protect your neighbourhood?"
   - Create Account and Sign In buttons.

## Flutter Architecture

Use a feature-first Flutter structure:

- `core/theme`: colors, typography, spacing, shadows, animations, Material 3 theme.
- `core/router`: GoRouter routes, guards, redirects, role-based shells.
- `core/network`: Dio client, auth interceptors, API error parsing, retry policy where appropriate.
- `core/storage`: secure token storage and shared preferences settings.
- `core/models`: shared enums, status presentation, pagination/result wrappers.
- `shared/widgets`: glass cards, status badges, severity badges, cyber buttons, app shells, form fields, empty/loading/error states.
- `features/auth`: splash, onboarding, login, register, forgot password, auth controller.
- `features/landing`: responsive landing page and hero animation widgets.
- `features/resident`: dashboard, incidents, FIRs, SOS, maps, notifications, settings.
- `features/authority`: command dashboard, field reports, Kanban, FIR management, SOS logs, dispatch map, alerts.
- `features/admin`: user management, analytics, system settings.
- `features/ai_calling`: ElevenLabs web embed/fallback screen.
- `data/demo`: seeded local/demo data and fake repositories.

State management will use Riverpod. Routing will use GoRouter. API calls will use Dio. Secure tokens will use Flutter Secure Storage. Non-sensitive settings will use SharedPreferences.

## Backend Integration

The Flutter API contract will follow the reference backend:

- Auth: register, login, logout, refresh, forgot password.
- Incidents: categories, create, get my incidents, get all, details, update, status update, stats.
- FIRs: create wizard submission, my FIRs, all FIRs, status/review actions.
- SOS: create SOS, list logs, update handled status.
- Alerts: broadcast, list, read/unread.
- Notifications: list, mark read/unread.
- Analytics: dashboard metrics.
- Map: incidents and live map data.
- File uploads: FIR evidence and incident attachments.
- ElevenLabs webhook: backend-owned, surfaced in mobile as AI calling capability.

SignalR real-time updates will be planned through `signalr_netcore` for incident, alert, map, and notification channels. If backend SignalR connectivity is unavailable during development, screens will fall back to polling or demo streams.

## Role Navigation

Residents see:

- Home dashboard.
- Report incident.
- File FIR.
- SOS.
- Map.
- Notifications.
- Profile/settings.

Authority/Admin/SuperAdmin see:

- Command dashboard.
- Field reports.
- Dispatch map.
- Kanban.
- FIR management.
- SOS logs.
- Broadcast alerts.
- User management where role allows it.
- AI calling screen.

Navigation will be mobile-first with bottom navigation for primary app areas and role-aware drawers/menus on tablet/web.

## Core Workflows

### Incident Reporting

Resident selects category and severity, enters title and description, picks current/manual map location, can report anonymously, then submits. The success screen displays an incident number and the incident appears in My Incidents.

### FIR Wizard

Five steps:

1. Complainant details.
2. Incident details.
3. Accused/suspect details.
4. Witness/evidence/details.
5. Review and declaration.

Submitted FIRs receive an FIR number and appear in My FIRs. Authority users can review, accept, reject, close, and add remarks.

### SOS

SOS screen uses a large circular glowing red button, emergency type selection, location capture, permission handling, and manual location fallback. A successful SOS creates a critical emergency record and appears in authority SOS logs.

### Maps

Use `flutter_map` and OpenStreetMap. Maps show user location, incident markers, severity colors, marker pulse for critical incidents, zoom controls, bottom sheet details, and selection mode for forms.

### Kanban

Authority Kanban columns match the backend statuses:

- Pending
- Assigned
- In Progress
- Resolved
- Closed

Cards show incident number, title, category, severity, location, and reported time. Drag/drop validates allowed transitions and updates the backend status endpoint. Mobile fallback uses tap-to-move actions.

## Status Presentation

Status labels must be centralized and user-friendly. The UI must never render raw enum names, numeric status values, raw objects, or code-like strings.

Supported labels include:

- Active
- Pending
- Assigned
- In Progress
- Resolved
- Closed
- Submitted
- Under Review
- Accepted
- Rejected
- Offline
- Warning
- Critical
- Suspended
- Unknown

Each status has a consistent badge color, icon, glow, and accessibility label.

## Error Handling

Every form and network action will include:

- Required field validation.
- Inline field errors.
- Loading states.
- Snackbar/toast feedback.
- Friendly API error messages.
- Empty states.
- Skeleton loading where lists/cards are expected.
- Graceful demo fallback where backend connectivity is missing.

## Testing

Add focused Flutter tests for:

- Status/severity presentation.
- Auth controller state transitions.
- Role-based routing redirects.
- Incident form validation and submission success path.
- FIR wizard validation and review summary.
- SOS permission/manual location fallback state.
- Kanban transition validation.
- Repository/API error handling.

Run `flutter analyze` and `flutter test` before final delivery. Run a Flutter Web build if the installed Flutter SDK supports it.

## Repository And Delivery

Create a public GitHub repository named `safezone-mobile-flutter`.

Because GitHub CLI is currently not authenticated on this machine, pushing will require one of:

- The user authenticates with `gh auth login`, or
- Existing Git HTTPS/SSH credentials are available for `git push`, or
- The user creates the empty GitHub repo and provides the remote.

Final delivery will include:

- Complete Flutter source.
- README setup and build instructions.
- `.env.example` or equivalent config template.
- Demo credentials and demo mode notes.
- Test/build results.
- Public GitHub remote pushed if authentication is available.

## Non-Goals For First Milestone

- Rebuilding the ASP.NET Core backend from scratch.
- Copying NFT/samurai content from the visual reference.
- Shipping placeholder-only screens.
- Depending on a paid map provider.
- Hardcoding secrets or API keys in source code.

