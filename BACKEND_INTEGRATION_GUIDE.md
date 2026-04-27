# Backend API Integration Guide

## Overview
This document describes the successful integration of the BloodLink backend authentication API with the Flutter donor mobile application. The integration includes login, registration, and logout functionality.

## Backend API Reference
**Backend Repository:** https://github.com/salemhabte/Bloodlink_Backend

### Authentication Endpoints

#### 1. Register Donor
- **URL:** `POST /api/auth/register-donor`
- **Auth Required:** No
- **Request Body:**
```json
{
  "full_name": "Jane Doe",
  "email": "jane.doe@example.com",
  "phone": "+251911223344",
  "password": "StrongPassword123!",
  "address": "Bole, Addis Ababa",
  "birth_date": "1995-08-22T00:00:00Z"
}
```
- **Response:** `201 Created`
```json
{
  "message": "Donor registered successfully. You can now login."
}
```

#### 2. Login
- **URL:** `POST /api/auth/login`
- **Auth Required:** No
- **Request Body:**
```json
{
  "email": "jane.doe@example.com",
  "password": "StrongPassword123!"
}
```
- **Response:** `200 OK`
```json
{
  "message": "Login successful",
  "access_token": "eyJhbGci...",
  "refresh_token": "eyJhbGci...",
  "role": "donor"
}
```

#### 3. Logout
- **URL:** `POST /api/logout`
- **Auth Required:** Yes (Bearer Token)
- **Response:** `200 OK`
```json
{
  "message": "Logged out successfully"
}
```

---

## Mobile App Integration Implementation

### 1. Dependencies Added (`pubspec.yaml`)

```yaml
dependencies:
  http: ^1.1.0                          # HTTP client for API calls
  flutter_secure_storage: ^9.0.0        # Secure token storage
  shared_preferences: ^2.2.0            # Local preferences backup
```

### 2. Service Layer

#### `ApiService` (`lib/services/api_service.dart`)
- Handles low-level HTTP requests to backend
- Manages token storage in secure storage
- Methods:
  - `registerDonor()` - Register new donor
  - `login()` - Authenticate user
  - `logout()` - Sign out user
  - `getAccessToken()` - Retrieve stored access token
  - `getRefreshToken()` - Retrieve stored refresh token
  - `isLoggedIn()` - Check if user has valid session
  - `clearCredentials()` - Clear stored tokens

**Key Features:**
- Secure storage of JWT tokens using `FlutterSecureStorage`
- 30-second timeout on all API calls
- Comprehensive error handling with meaningful messages
- Support for both error and success scenarios

#### `AuthManager` (`lib/services/auth_manager.dart`)
- High-level authentication management
- Wraps `ApiService` for cleaner UI integration
- Manages user session state
- Methods mirror `ApiService` with additional state management
- Stores user email and role for local reference

### 3. Screen Integration

#### Login Screen (`lib/screens/login_screen.dart`)
- **Changes:**
  - Replaced hardcoded credentials with backend API calls
  - Added loading state management
  - Shows error messages from backend
  - Button disabled during login
  - Validates email and password before sending

- **Features:**
  - Email and password input fields
  - Loading indicator during authentication
  - Error message display
  - Navigation to signup on successful login
  - Link to registration screen

#### Sign Up Screen (`lib/screens/sign_up_screen.dart`)
- **Changes:**
  - Integrated with backend registration endpoint
  - Added birth date picker (required by API)
  - Added address field (optional)
  - Enhanced password validation (8 character minimum)
  - Loading state during registration

- **Features:**
  - Full name, email, phone input
  - Birth date selection with DatePicker
  - Address field (optional)
  - Password confirmation
  - Validation before submission
  - Navigation to login after successful registration
  - Success notification

#### Profile Screen (`lib/screens/profile_screen.dart`)
- **Changes:**
  - Converted from `StatelessWidget` to `StatefulWidget`
  - Integrated logout functionality
  - Added loading state for logout
  - Proper token cleanup on logout

- **Features:**
  - Logout button with loading indicator
  - Navigation to login screen after logout
  - Error handling with user feedback

#### Splash Screen (`lib/screens/splash_screen.dart`)
- **Changes:**
  - Added authentication check on app startup
  - Routes authenticated users to home, others to welcome
  - Maintains existing 3-second splash animation

- **Features:**
  - Checks `AuthManager.isLoggedIn()` on startup
  - Auto-routes based on authentication status
  - Smooth transition with animation

### 4. Authentication Flow

```
App Start
    ↓
Splash Screen (3 seconds)
    ↓
Check if Logged In?
    ├─ Yes → Navigate to /home (MainNavigationScreen)
    └─ No → Navigate to /welcome (WelcomeScreen)
    
Login/Register Flow:
Login Screen → API Call → Success → Navigate to /profile (/home)
           ↓                         
           Error → Show Error Message
           
Register Flow:
Sign Up Screen → API Call → Success → Navigate to /login
              ↓
              Error → Show Error Message
```

---

## Configuration

### API Base URL
- **Location:** `lib/services/api_service.dart`
- **Current:** `https://api.bloodlink.com`
- **Update Required:** Change to your actual backend URL

```dart
static const String baseUrL = 'https://api.bloodlink.com';
```

### Token Storage
- **Secure Storage:** All tokens stored in device's secure storage
- **Keys Used:**
  - `access_token` - JWT access token
  - `refresh_token` - JWT refresh token
  - `user_email` - Logged-in user's email
  - `user_role` - User's role (e.g., "donor")

---

## Usage Examples

### Login
```dart
final authManager = AuthManager();
final result = await authManager.login(
  email: 'user@example.com',
  password: 'password123',
);

if (result['success']) {
  // Navigate to home
} else {
  // Show error: result['message']
}
```

### Register
```dart
final authManager = AuthManager();
final result = await authManager.registerDonor(
  fullName: 'John Doe',
  email: 'john@example.com',
  phone: '+251911223344',
  password: 'SecurePass123!',
  address: 'Addis Ababa',
  birthDate: DateTime(1995, 8, 22),
);

if (result['success']) {
  // Navigate to login
} else {
  // Show error: result['message']
}
```

### Logout
```dart
final authManager = AuthManager();
final result = await authManager.logout();

if (result['success']) {
  // Navigate to login
} else {
  // Handle error
}
```

### Check Authentication Status
```dart
final authManager = AuthManager();
final isLoggedIn = await authManager.isLoggedIn();

if (isLoggedIn) {
  final email = await authManager.getCurrentUserEmail();
  final token = await authManager.getAccessToken();
}
```

---

## Error Handling

### Network Errors
- Timeout: 30 seconds per request
- Connection errors: Descriptive messages returned
- Offline handling: Local error messages displayed

### Authentication Errors
- Invalid credentials: "Invalid email or password"
- User not found: Backend response message
- Server errors: Generic error with status code

### Validation Errors
- Empty fields: "Please fill in all fields"
- Password mismatch: "Passwords do not match"
- Invalid email format: Standard email validation
- Short password: "Password must be at least 8 characters"

---

## Security Features

1. **Secure Token Storage**
   - Tokens stored in platform-specific secure storage
   - Android: Encrypted SharedPreferences
   - iOS: Keychain

2. **Token Management**
   - Automatic token clearing on logout
   - Local cleanup even if server request fails
   - Tokens used in Authorization header: `Bearer <token>`

3. **Input Validation**
   - Client-side validation before API calls
   - Password strength requirements
   - Email format validation
   - Date of birth validation (18+ years)

---

## Next Steps

### 1. Update Backend URL
Replace the API base URL in `ApiService` with your actual backend endpoint:
```dart
static const String baseUrL = 'your-backend-url';
```

### 2. Run Dependencies
```bash
flutter pub get
```

### 3. Handle Additional Endpoints
When ready, extend `ApiService` with:
- Profile retrieval: `GET /api/protected/profile`
- Profile update: `PATCH /api/protected/profile`
- Password reset: `POST /api/auth/forgot-password`
- Token refresh: Implement refresh token logic

### 4. Add Error Logging
Consider adding analytics or crash reporting:
```dart
// Add Firebase Crashlytics or similar
FirebaseCrashlytics.instance.recordError(e, stackTrace);
```

### 5. Implement Token Refresh
Add automatic token refresh when access token expires:
```dart
Future<String> _getValidToken() async {
  final token = await getAccessToken();
  // Check if expired and refresh if needed
  return token;
}
```

---

## Testing

### Test Credentials
Use the test endpoints and credentials provided by your backend:
```
Email: test@example.com
Password: TestPassword123!
```

### Manual Testing Checklist
- [ ] Registration with valid data succeeds
- [ ] Login with valid credentials succeeds
- [ ] Invalid credentials show error message
- [ ] Logout clears session and navigates to login
- [ ] App routes logged-in users to home on startup
- [ ] App routes logged-out users to welcome on startup
- [ ] Error messages are clear and helpful
- [ ] Loading states show during API calls
- [ ] Network timeouts handled gracefully

---

## Files Modified/Created

### Created Files:
- `lib/services/api_service.dart` - API communication
- `lib/services/auth_manager.dart` - Authentication management

### Modified Files:
- `pubspec.yaml` - Added dependencies
- `lib/screens/login_screen.dart` - Backend integration
- `lib/screens/sign_up_screen.dart` - Backend integration & date picker
- `lib/screens/profile_screen.dart` - Logout integration
- `lib/screens/splash_screen.dart` - Auth check on startup

---

## Troubleshooting

### Issue: Connection Refused
- **Solution:** Verify backend URL in `api_service.dart` is correct
- **Solution:** Ensure backend server is running

### Issue: Tokens Not Persisting
- **Solution:** Check `FlutterSecureStorage` permissions are set (Android/iOS)
- **Solution:** Ensure device has unlock credentials set (required for secure storage)

### Issue: CORS Errors
- **Solution:** Configure CORS on backend to accept mobile app requests
- **Solution:** Add appropriate headers in API calls if needed

### Issue: Password Validation Failing
- **Solution:** Ensure password meets 8-character minimum requirement
- **Solution:** No special character restrictions on frontend

---

## Support

For issues or questions:
1. Check backend API documentation: https://github.com/salemhabte/Bloodlink_Backend
2. Review error messages in app
3. Check network logs using Flutter DevTools
4. Verify token storage using secure storage inspection tools

---

**Integration Complete!** 🎉

Your BloodLink Donor app now has full backend authentication integration.
Update the API base URL and test with your backend server.
