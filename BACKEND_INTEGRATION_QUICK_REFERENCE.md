# Backend Integration - Quick Reference

## ✅ What's Been Done

1. **Added Dependencies**
   - `http: ^1.1.0` - API client
   - `flutter_secure_storage: ^9.0.0` - Secure token storage
   - `shared_preferences: ^2.2.0` - Local preferences

2. **Created Authentication Services**
   - `ApiService` - Handles HTTP requests to backend
   - `AuthManager` - High-level auth management

3. **Integrated Authentication Screens**
   - ✅ Login Screen - Connects to `/api/auth/login`
   - ✅ Sign Up Screen - Connects to `/api/auth/register-donor` 
   - ✅ Profile Screen - Logout functionality
   - ✅ Splash Screen - Auto-routing based on auth status

4. **Security Features**
   - Secure token storage on device
   - JWT token management
   - Automatic cleanup on logout
   - Input validation

---

## 🔧 Required Setup Steps

### 1. Update Backend URL
**File:** `lib/services/api_service.dart` (Line 5)

```dart
// Change this:
static const String baseUrL = 'https://api.bloodlink.com';

// To your actual backend URL:
static const String baseUrL = 'https://your-backend-domain.com';
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Test the Integration

**Test Registration:**
1. Run the app
2. Tap "Register" on login screen
3. Fill in:
   - Full Name
   - Email
   - Phone Number
   - Birth Date (select from picker)
   - Address (optional)
   - Password (min 8 characters)
   - Confirm Password
4. Tap "Create Account"

**Test Login:**
1. After registration, login with credentials
2. Should navigate to home screen
3. Should see loading state during login

**Test Logout:**
1. Navigate to Profile screen (bottom navigation)
2. Tap "Logout" button
3. Should return to login screen

**Test Auto-Routing:**
1. Kill the app
2. Restart the app
3. If logged in → Should show home screen
4. If logged out → Should show welcome screen

---

## 📱 Backend API Endpoints

All requests to these endpoints:

```
POST /api/auth/register-donor
POST /api/auth/login
POST /api/logout (requires Bearer token)
GET /api/protected/profile (requires Bearer token)
PATCH /api/protected/profile (requires Bearer token)
```

**Base URL:** Insert your backend URL

---

## 🔐 Token Storage

Tokens are securely stored on device:
- Access Token → `access_token`
- Refresh Token → `refresh_token`
- User Email → `user_email`
- User Role → `user_role`

These are automatically managed by `AuthManager`.

---

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Connection refused" | Update backend URL in `api_service.dart` |
| "CORS error" | Configure CORS on backend |
| Tokens not saving | Enable device unlock credentials (required for secure storage) |
| 404 errors | Verify endpoint URLs match backend exactly |
| Timeout errors | Check network connectivity, increase timeout if needed |

---

## 📋 Files Created

```
lib/services/
├── api_service.dart      (NEW)
└── auth_manager.dart     (NEW)
```

## 📝 Files Modified

```
lib/screens/
├── login_screen.dart       (Updated)
├── sign_up_screen.dart     (Updated)
├── profile_screen.dart     (Updated)
└── splash_screen.dart      (Updated)

Root:
├── pubspec.yaml           (Updated - dependencies added)
└── BACKEND_INTEGRATION_GUIDE.md (NEW)
```

---

## 🚀 Next Steps (Optional)

1. **Add Profile Screen Integration**
   - `GET /api/protected/profile`
   - Display user profile data

2. **Implement Token Refresh**
   - Auto-refresh access token when expired
   - Retry failed requests with new token

3. **Add Password Reset**
   - `POST /api/auth/forgot-password`
   - Email verification flow

4. **Complete Profile Endpoint**
   - `PATCH /api/protected/profile`
   - Allow users to update their information

5. **Add Analytics**
   - Track login/registration success rates
   - Monitor error patterns

---

## ✨ Features Implemented

| Feature | Status | Location |
|---------|--------|----------|
| User Registration | ✅ | Sign Up Screen |
| User Login | ✅ | Login Screen |
| User Logout | ✅ | Profile Screen |
| Token Storage | ✅ | AuthManager |
| Session Persistence | ✅ | Splash Screen |
| Error Handling | ✅ | All screens |
| Loading States | ✅ | All screens |
| Input Validation | ✅ | All screens |
| Secure Storage | ✅ | ApiService |

---

## 📞 Support

For help:
1. Check `BACKEND_INTEGRATION_GUIDE.md` for detailed documentation
2. Review error messages in the app
3. Check backend API documentation
4. Verify network requests using browser DevTools

---

**Ready to test!** 🚀

Just update the backend URL and run:
```bash
flutter run
```
