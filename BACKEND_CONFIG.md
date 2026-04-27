# Backend Configuration

## Backend API Base URL Setup

### Current Configuration
- **File:** `lib/services/api_service.dart`
- **Property:** `baseUrL` (Line 5)
- **Current Value:** `https://api.bloodlink.com`

### Update Instructions

1. **For Development/Testing:**
   ```dart
   static const String baseUrL = 'http://localhost:8000';  // Local backend
   // OR
   static const String baseUrL = 'http://192.168.1.x:3000';  // Local network IP
   ```

2. **For Staging:**
   ```dart
   static const String baseUrL = 'https://staging-api.bloodlink.com';
   ```

3. **For Production:**
   ```dart
   static const String baseUrL = 'https://api.bloodlink.com';
   ```

### After Updating URL
```bash
# Clean previous build
flutter clean

# Get latest dependencies
flutter pub get

# Run the app
flutter run
```

---

## Backend Repository Information

**Repository:** https://github.com/salemhabte/Bloodlink_Backend

### Key Endpoints
- `POST /api/auth/register-donor` - Register new donor
- `POST /api/auth/login` - Login user
- `POST /api/logout` - Logout user
- `GET /api/protected/profile` - Get user profile
- `PATCH /api/protected/profile` - Update profile

---

## Environment-Specific Configuration

### Development
```
Base URL: http://localhost:8000
Headers: Content-Type: application/json
Auth: Bearer <token>
Timeout: 30s
```

### Testing
```
Base URL: https://staging-api.bloodlink.com
Headers: Content-Type: application/json
Auth: Bearer <token>
Timeout: 30s
Ensure CORS headers are set for mobile app
```

### Production
```
Base URL: https://api.bloodlink.com
Headers: Content-Type: application/json
Auth: Bearer <token>
Timeout: 30s
SSL/TLS: Enabled
```

---

## API Response Format

### Success Response
```json
{
  "success": true,
  "message": "Operation successful",
  "data": {}
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description"
}
```

---

## Testing with cURL

### Register
```bash
curl -X POST http://backend-url/api/auth/register-donor \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "Test User",
    "email": "test@example.com",
    "phone": "+251911223344",
    "password": "TestPass123!",
    "address": "Addis Ababa",
    "birth_date": "1995-08-22T00:00:00Z"
  }'
```

### Login
```bash
curl -X POST http://backend-url/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123!"
  }'
```

### Logout (requires token)
```bash
curl -X POST http://backend-url/api/logout \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <access_token>"
```

---

## Troubleshooting

### 404 - Not Found
- Verify endpoint URL is correct
- Check base URL includes protocol (http:// or https://)
- Ensure trailing slashes match backend expectations

### 401 - Unauthorized
- Check token is included in Authorization header
- Verify token hasn't expired
- Ensure Bearer token format: `Bearer <token>`

### 500 - Server Error
- Check backend logs
- Verify request body matches expected format
- Ensure all required fields are included

### Connection Timeout
- Increase timeout value in `ApiService`
- Check network connectivity
- Verify backend is running

### CORS Error (Mobile)
- Configure backend CORS headers
- Add `Access-Control-Allow-Origin: *`
- Add `Access-Control-Allow-Methods: GET, POST, PATCH, DELETE`
- Add `Access-Control-Allow-Headers: Content-Type, Authorization`

---

## Network Debugging

### Enable Network Logging in Flutter
Create a custom HTTP client with logging:

```dart
// In api_service.dart, add logging middleware
import 'package:http/http.dart' as http;

class LoggingHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    print('>>> REQUEST: ${request.method} ${request.url}');
    print('>>> HEADERS: ${request.headers}');
    print('>>> BODY: ${request.body}');
    
    return super.send(request).then((response) {
      print('<<< RESPONSE: ${response.statusCode}');
      print('<<< BODY: ${response.body}');
      return response;
    });
  }
}
```

### Use Charles Proxy or Fiddler
- Intercept HTTP/HTTPS traffic
- View request/response details
- Debug issues with headers or body

---

## Performance Optimization

### Timeout Settings
Current: 30 seconds
- Increase for slow networks: `const Duration(seconds: 60)`
- Decrease for fast networks: `const Duration(seconds: 15)`

### Retry Logic (Optional)
```dart
Future<http.Response> _retryableRequest(...) async {
  for (int i = 0; i < 3; i++) {
    try {
      return await http.post(...).timeout(...);
    } catch (e) {
      if (i == 2) rethrow;
      await Future.delayed(Duration(seconds: pow(2, i).toInt()));
    }
  }
}
```

### Caching (Optional)
Consider adding response caching for:
- Profile data
- Campaign information
- Blood request lists

---

## Security Checklist

- [ ] Backend URL uses HTTPS in production
- [ ] API keys are not hardcoded (use environment variables)
- [ ] Tokens are stored securely (flutter_secure_storage)
- [ ] Sensitive data is not logged
- [ ] CORS is properly configured
- [ ] SSL pinning implemented (optional, advanced)
- [ ] Rate limiting enabled on backend
- [ ] Input validation on backend

---

## API Integration Testing

### Test Cases

**Test 1: Register with Valid Data**
- Expected: 201 Created
- Response: Success message

**Test 2: Register with Invalid Email**
- Expected: 400 Bad Request
- Response: Error message

**Test 3: Login with Valid Credentials**
- Expected: 200 OK
- Response: Tokens and user role

**Test 4: Login with Invalid Credentials**
- Expected: 401 Unauthorized
- Response: Error message

**Test 5: Logout with Valid Token**
- Expected: 200 OK
- Response: Success message

**Test 6: Access Protected Endpoint Without Token**
- Expected: 401 Unauthorized
- Response: Error message

---

**Configuration complete!** 

Update the base URL and you're ready to connect to your backend.
