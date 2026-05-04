# Emergency Request API Documentation

This document outlines the API endpoints related to Emergency Blood Requests. These endpoints are split between public access for viewing active emergencies and admin access for managing them.

## Base URLs

- Public Routes: `/api/`
- Blood Bank Admin Routes: `/api/bloodbankadmin/`

---

## 1. Get Published Emergencies (Public)
Retrieves a list of all currently published and active emergency blood requests. Donors and the public can view these without authentication.

- **URL**: `/api/emergencies/published`
- **Method**: `GET`
- **Authentication**: None required

### Success Response
- **Code**: `200 OK`
- **Content**:
  ```json
  [
    {
      "emergency_id": "uuid-string",
      "request_id": "optional-uuid-string",
      "blood_type": "O+",
      "quantity_required": 5,
      "quantity_fulfilled": 0,
      "urgency_level": "CRITICAL",
      "hospital_name": "St. Mary's Hospital",
      "location": "Downtown District",
      "status": "PUBLISHED",
      "is_manual": false,
      "created_at": "2026-05-03T10:00:00Z",
      "updated_at": "2026-05-03T10:05:00Z",
      "published_at": "2026-05-03T10:05:00Z"
    }
  ]
  ```

---

## 2. Get All Emergencies (Admin)
Retrieves a complete list of all emergency requests, including pending, published, rejected, and completed statuses.

- **URL**: `/api/bloodbankadmin/emergencies/`
- **Method**: `GET`
- **Authentication**: Required (Role: `RoleBloodBankAdmin`)

### Success Response
- **Code**: `200 OK`
- **Content**: Array of `EmergencyRequest` objects.

---

## 3. Create Manual Emergency (Admin)
Allows blood bank admins to manually create an emergency request (e.g., when a hospital calls in a request instead of using the system). These are automatically published upon creation.

- **URL**: `/api/bloodbankadmin/emergencies/manual`
- **Method**: `POST`
- **Authentication**: Required (Role: `RoleBloodBankAdmin`)

### Request Body
```json
{
  "blood_type": "A+",
  "quantity_required": 3,
  "urgency_level": "URGENT",
  "hospital_name": "General Hospital",
  "location": "North Suburb"
}
```
*Note: `blood_type` must be one of: `'A+' 'A-' 'B+' 'B-' 'AB+' 'AB-' 'O+' 'O-'`. `quantity_required` must be greater than 0. All fields are required.*

### Success Response
- **Code**: `201 Created`
- **Content**:
  ```json
  {
    "message": "Manual emergency request created and published"
  }
  ```

### Error Response
- **Code**: `400 Bad Request` (Invalid payload) or `500 Internal Server Error`

---

## 4. Publish Emergency (Admin)
Approves and publishes a pending emergency request that was automatically generated from a critical hospital blood request.

- **URL**: `/api/bloodbankadmin/emergencies/:id/publish`
- **Method**: `POST`
- **Authentication**: Required (Role: `RoleBloodBankAdmin`)

### URL Parameters
- `id`: The ID of the emergency request to publish.

### Success Response
- **Code**: `200 OK`
- **Content**:
  ```json
  {
    "message": "Emergency request published successfully"
  }
  ```

---

## 5. Reject Emergency (Admin)
Rejects a pending emergency request, preventing it from being published.

- **URL**: `/api/bloodbankadmin/emergencies/:id/reject`
- **Method**: `POST`
- **Authentication**: Required (Role: `RoleBloodBankAdmin`)

### URL Parameters
- `id`: The ID of the emergency request to reject.

### Success Response
- **Code**: `200 OK`
- **Content**:
  ```json
  {
    "message": "Emergency request rejected successfully"
  }
  ```

---

## 6. Get Emergencies for Donor (Donor App)
Retrieves a list of published emergency requests that match the logged-in donor's registered address.

- **URL**: `/api/donor/emergencies`
- **Method**: `GET`
- **Authentication**: Required (Role: `RoleDonor`)

### Success Response
- **Code**: `200 OK`
- **Content**:
  ```json
  [
    {
      "emergency_id": "uuid-string",
      "blood_type": "A-",
      "quantity_required": 5,
      "urgency_level": "URGENT",
      "hospital_name": "St. Luke's",
      "location": "Bole District",
      "status": "PUBLISHED",
      "published_at": "2026-05-03T12:00:00Z"
    }
  ]
  ```

### Error Response
- **Code**: `401 Unauthorized` (Not a donor)
- **Code**: `500 Internal Server Error` (Profile or address not found)

---

## Enums and States

### Emergency Statuses
The `status` field for an emergency request will be one of the following:
- `PENDING_PUBLISH`: Waiting for admin approval.
- `PUBLISHED`: Active and visible to the public.
- `REJECTED`: Denied by the admin.
- `COMPLETED`: The required blood quantity has been fully fulfilled.
