# BloodLink Donor App

A Flutter web application for blood donors — connecting people to donation campaigns, emergency blood requests, and their personal donation history.

---

## What It Does

BloodLink Donor gives registered blood donors a clean, mobile-first interface to:

- Browse and search active **blood donation campaigns**
- Respond to **emergency blood requests** from nearby hospitals
- Track their personal **donation history** and badges
- Submit and monitor their own **blood requests**
- View **test results** and donation eligibility status
- Stay on top of their session securely with **auto token refresh**

---

## Screens

| Screen | Description |
|---|---|
| Welcome | Public landing page with campaigns preview and "See all" link |
| Login / Sign Up | Auth screens with password visibility toggle and international phone picker |
| Home | Dashboard with eligibility card, shortcuts, and live nearby emergencies |
| Campaigns | Searchable, filterable list of donation drives (All / This Week) |
| Emergencies | Searchable urgent blood requests (All / Critical filter) |
| My Requests | Donor's own blood requests with verification warning banner |
| Blood Request Form | Units stepper + component type selector (6 types) |
| History | Full donation history with detail view |
| Test Results | Latest lab/test results |
| Badges | Earned donor achievement badges |
| Leaderboard | Community donor rankings |
| Profile / Edit Profile | View and update personal details |
| Notifications | In-app notification list |
| About / Privacy / Terms | Informational pages |

---

## Key Features

### Authentication
- Email + password login and registration
- Password show/hide toggle on both login and sign-up screens
- International phone number field with country code dropdown (50+ countries), flag emoji, and per-country digit validation
- Forgot password flow

### Session Management
- **Proactive token refresh** — decodes the JWT `exp` claim on startup and schedules a background timer to refresh the access token 2 minutes before it expires, so users are never interrupted mid-session
- **Force refresh on 401** — if a request returns 401 (e.g. after device sleep), the app silently tries the refresh token before logging anyone out
- **Session expiry redirect** — if refresh fails, credentials are cleared and the user is navigated to the login screen with a clear message
- Refresh timer is cancelled on logout

### Campaigns Page
- Real-time **search** by title, description, or location — activated by tapping the search icon
- **"All"** / **"This Week"** filter pills — This Week shows only campaigns whose dates overlap with the current Monday–Sunday window
- Filters and search work together simultaneously
- Empty states with quick-reset links ("View all campaigns", "Clear search")
### Emergencies Page
- Real-time **search** by hospital name, location, or blood type
- **"All"** / **"Critical"** filter pills
- Same combined search + filter logic
- Animated pill transitions and result count hint while typing

### Blood Requests
- Units stepper (+ / −) for quantity
- Component type dropdown: `WHOLE_BLOOD`, `PRBC`, `PLATELETS`, `PLASMA`, `CRYOPRECIPITATE`, `CRYO_POOR_PLASMA`
- **Ready for Pickup** badge when `can_fulfill = true`
- Verification warning banner for unverified accounts

### UI
- Flat card design — zero elevation across every screen for a clean, modern look
- Animated filter pills (smooth 200ms colour transitions)
- Responsive layout for mobile, tablet, and desktop widths
- Localization support (English, Amharic, Oromo, Tigrinya, Somali)

---

## Project Structure

```
lib/
├── main.dart                   # App entry, MaterialApp, navigator key, token refresh init
├── models/
│   ├── campaign.dart           # Campaign with startDate/endDate, status colour
│   ├── blood_request.dart      # Units, componentType, canFulfill
│   ├── emergency.dart          # Hospital, urgencyLevel, bloodType
│   ├── donation.dart
│   ├── badge.dart
│   ├── leaderboard_entry.dart
│   ├── test_result.dart
│   └── eligibility.dart
├── screens/                    # One file per screen (20 screens)
├── services/
│   ├── api_service.dart        # All API calls; 401 → force refresh or redirect
│   ├── auth_manager.dart       # Login/logout; starts/cancels token refresh
│   ├── token_refresh_service.dart  # Singleton; proactive JWT refresh scheduler
│   ├── notification_service.dart
│   ├── localization_service.dart
│   └── cloudinary_service.dart
├── utils/
│   ├── jwt_utils.dart          # Decode JWT exp claim without a library
│   ├── navigation_service.dart # GlobalKey for navigator — used by token refresh
│   └── responsive_utils.dart
├── widgets/
│   ├── custom_button.dart
│   ├── custom_card.dart        # elevation: 0 globally
│   └── custom_text_field.dart
└── theme/
    ├── app_colors.dart
    └── app_text_styles.dart
```

---

## Backend

- **Base URL:** `https://bloodlink-backend-bpll.onrender.com`
- **Auth:** JWT Bearer tokens (access + refresh)
- **Key endpoints used:**

| Method | Path | Purpose |
|---|---|---|
| POST | `/api/auth/login` | Login |
| POST | `/api/auth/register-donor` | Register |
| POST | `/api/auth/refresh` | Refresh access token |
| POST | `/api/auth/logout` | Logout |
| GET | `/api/protected/profile` | Fetch profile |
| PATCH | `/api/protected/profile` | Update profile |
| GET | `/api/protected/campaigns` | List campaigns |
| GET | `/api/protected/emergencies` | List emergencies |
| GET | `/api/protected/donations` | Donation history |
| POST | `/api/protected/blood-requests` | Submit blood request |
| GET | `/api/protected/blood-requests/my` | My requests |
| GET | `/api/protected/test-results/latest` | Latest test result |
| GET | `/api/protected/badges` | Badges |
| GET | `/api/protected/leaderboard` | Leaderboard |

---

## Running Locally

**Requirements:** Flutter SDK 3.x, Node.js 18+

```bash
# Install dependencies
flutter pub get

# Run in browser (development)
flutter run -d chrome

# Build for web (production)
flutter build web --release

# Serve the built output
node server.js        # serves on port 5000
```

The `server.js` file serves the `build/web` directory as a static site on port 5000.

---

## Environment

No `.env` file needed — the backend URL is set directly in `lib/services/api_service.dart` and `lib/services/token_refresh_service.dart`:

```dart
static const String baseUrl = 'https://bloodlink-backend-bpll.onrender.com';
```

Tokens are stored in `flutter_secure_storage` (encrypted on-device) — never in plain local storage.
