# Donor API Documentation

This document covers the specialized endpoints for Donor registration and authentication.

## 1. Authentication Endpoints

### 1.1 Register as a Donor
Registers a new donor and activates their account immediately. No OTP verification is required for donors.

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
- **Response (201 Created):**
```json
{
  "message": "Donor registered successfully. You can now login."
}
```

---

### 1.2 Login
Authenticates a user and returns access and refresh tokens.

- **URL:** `POST /api/auth/login`
- **Auth Required:** No
- **Request Body:**
```json
{
  "email": "jane.doe@example.com",
  "password": "StrongPassword123!"
}
```
- **Response (200 OK):**
```json
{
  "message": "Login successful",
  "access_token": "eyJhbGci...",
  "refresh_token": "eyJhbGci...",
  "role": "donor"
}
```

---

### 1.3 Logout
Invalidates the current session.

- **URL:** `POST /api/logout`
- **Auth Required:** Yes (Bearer Token)
- **Response (200 OK):**
```json
{
  "message": "Logged out successfully"
}
```

---

## 2. Profile Management

### 2.1 Get My Profile
Retrieves the logged-in donor's profile information.

- **URL:** `GET /api/protected/profile`
- **Auth Required:** Yes (Bearer Token)
- **Response (200 OK):**
```json
{
  "profile_id": "uuid-string",
  "user_id": "uuid-string",
  "full_name": "Jane Doe",
  "phone": "+251911223344",
  "address": "",
  "profile_picture_url": ""
}
```

---

### 2.2 Update My Profile
Updates personal information.

- **URL:** `PATCH /api/protected/profile`
- **Auth Required:** Yes (Bearer Token)
- **Request Body (Partial updates allowed):**
```json
{
  "full_name": "Jane Smith",
  "address": "Bole, Addis Ababa"
}
```
- **Response (200 OK):**
```json
{
  "message": "Profile updated successfully",
  "profile": { ... }
}
```

## 3. Important Notes
- **Role Enforcement**: You cannot use the general `/api/auth/register` endpoint to register as a donor. You must use `/api/auth/register-donor`.
- **Date Format**: `birth_date` must be in ISO 8601 format (e.g., `YYYY-MM-DDTHH:MM:SSZ`).
- **Instant Activation**: Unlike other roles, donors do not need to call `/verify-otp`. Their account is active immediately after registration.
