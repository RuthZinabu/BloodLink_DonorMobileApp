# Donor Blood Request — API Documentation

Base URL: `http://localhost:<PORT>/api`

All protected routes require:
```
Authorization: Bearer <JWT_TOKEN>
```

---

## DONOR ENDPOINTS

### 1. Create a Blood Request
> **POST** `/api/donor/blood-request`
> Role: `donor`

**Request Body:**
```json
{
  "quantity_ml": 450,
  "reason": "Surgery needed at hospital",
  "hospital_name": "Tikur Anbessa Hospital",
  "hospital_address": "Addis Ababa, Churchill Ave",
  "hospital_phone": "+251911234567"
}
```

**Success Response (201):**
```json
{
  "message": "Blood request created successfully"
}
```

**Blocked — no successful donation yet (403):**
```json
{
  "error": "at least perform one successful donation to request blood"
}
```

---

### 2. View My Requests (Donor sees their own status)
> **GET** `/api/donor/my-requests`
> Role: `donor`

**Query Params (all optional):**
| Param | Example | Description |
|---|---|---|
| `status` | `PENDING` | Filter by status |
| `start_date` | `2026-05-01` | Filter created_at >= date |
| `end_date` | `2026-05-11` | Filter created_at <= date |

**Success Response (200):**
```json
{
  "message": "My requests fetched successfully",
  "data": [
    {
      "request_id": "uuid",
      "donor_id": "uuid",
      "donor_name": "Abebe Bekele",
      "blood_type": "O+",
      "quantity_ml": 450,
      "reason": "Surgery needed",
      "hospital_name": "Tikur Anbessa",
      "hospital_address": "Addis Ababa",
      "hospital_phone": "+251911234567",
      "status": "APPROVED",
      "created_at": "2026-05-11T03:30:00Z"
    }
  ]
}
```

**Possible `status` values the donor will see:**
| Status | Meaning |
|---|---|
| `PENDING` | Waiting for admin action |
| `APPROVED` | Fully reserved — blood found |
| `PARTIALLY APPROVED` | Only some blood was available and reserved |
| `FULFILLED` | Blood physically handed over |
| `PARTIALLY FULFILLED` | Partial blood handed over |
| `REJECTED` | Rejected (manual or auto if no inventory / 24hr expired) |

---

## ADMIN ENDPOINTS

### 3. Get All Donor Requests — Filtered & Sorted
> **GET** `/api/bloodbankadmin/donor-blood-requests`
> Role: `blood_bank_admin`

Sorted by **successful donations DESC** (highest donor = top priority).

**Query Params (all optional):**
| Param | Example | Description |
|---|---|---|
| `blood_type` | `O+` | Filter by blood type |
| `status` | `PENDING` | Filter by status |
| `start_date` | `2026-05-01` | Filter created_at >= date |
| `end_date` | `2026-05-11` | Filter created_at <= date |

**Example:**
```
GET /api/bloodbankadmin/donor-blood-requests?blood_type=O%2B&status=PENDING
```

**Success Response (200):**
```json
{
  "message": "Admin donor requests fetched successfully",
  "data": [
    {
      "request_id": "uuid",
      "donor_id": "uuid",
      "donor_name": "Abebe Bekele",
      "blood_type": "O+",
      "quantity_ml": 450,
      "reason": "Surgery",
      "hospital_name": "Tikur Anbessa",
      "hospital_address": "Addis Ababa",
      "hospital_phone": "+251911234567",
      "status": "PENDING",
      "can_fulfill": false,
      "created_at": "2026-05-11T03:30:00Z",
      "successful_donations": 5
    }
  ]
}
```

---

### 4. Approve a Request
> **PUT** `/api/bloodbankadmin/blood-requests/:id/approve`
> Role: `blood_bank_admin`

**No request body needed.**

**Scenario A — No blood in inventory (auto-REJECTED):**
```json
{ 
  "message": "no enough blood in the inventory",
  "data": { "request_id": "...", "status": "REJECTED", "can_fulfill": false, ... }
}
```
→ Donor sees status: `REJECTED`

**Scenario B — Partial blood found (PARTIALLY APPROVED):**
```json
{ 
  "message": "partially approved",
  "data": { "request_id": "...", "status": "PARTIALLY APPROVED", "can_fulfill": true, ... }
}
```
→ Donor sees status: `PARTIALLY APPROVED`
→ Found blood units are marked `RESERVED` with `donor_request_id` = this request

**Scenario C — Full blood found (APPROVED):**
```json
{ 
  "message": "fully approved",
  "data": { "request_id": "...", "status": "APPROVED", "can_fulfill": true, ... }
}
```
→ Donor sees status: `APPROVED`
→ All required blood units marked `RESERVED`

**Error — already processed (400):**
```json
{ "error": "request already processed" }
```

---

### 5. Reject a Request
> **PUT** `/api/bloodbankadmin/blood-requests/:id/reject`
> Role: `blood_bank_admin`

**No request body needed.**

**Success (200):**
```json
{ 
  "message": "Request rejected successfully",
  "data": { "request_id": "...", "status": "REJECTED", "can_fulfill": false, ... }
}
```

**Error — already fulfilled (400):**
```json
{ "error": "cannot reject a fulfilled request" }
```

---

### 6. Fulfill a Request (blood physically handed over)
> **PUT** `/api/bloodbankadmin/blood-requests/:id/fulfill`
> Role: `blood_bank_admin`

**No request body needed.**

**If current status is `APPROVED` → transitions to `FULFILLED`:**
```json
{ 
  "message": "Request fulfilled successfully",
  "data": { "request_id": "...", "status": "FULFILLED", "can_fulfill": false, ... }
}
```
→ All reserved blood units for this request → `USED`

**If current status is `PARTIALLY APPROVED` → transitions to `PARTIALLY FULFILLED`:**
```json
{ 
  "message": "Request fulfilled successfully",
  "data": { "request_id": "...", "status": "PARTIALLY FULFILLED", "can_fulfill": false, ... }
}
```
→ Reserved blood units for this request → `USED`

**Error — request not yet approved (400):**
```json
{ "error": "request has not been approved yet" }
```

---

### 7. Expire Stale Reservations (24-hour cleanup)
> **POST** `/api/bloodbankadmin/donor-blood-requests/expire-stale`
> Role: `blood_bank_admin`

Call this manually or hook it to a cron job.

Any blood units reserved for > 24 hours without being fulfilled are:
- Released back to `AVAILABLE`
- Their linked `donor_blood_request` → `REJECTED`

**Success (200):**
```json
{ "message": "Stale reservations expired successfully" }
```

---

## RECOMMENDED TESTING ORDER

```
1. Log in as DONOR → get token
2. POST /api/donor/blood-request
   → If donor has 0 successful donations: expect 403
   → If donor has donations in inventory: expect 201

3. Log in as ADMIN → get token
4. GET /api/bloodbankadmin/donor-blood-requests
   → See the request sorted by successful_donations DESC

5. PUT /api/bloodbankadmin/blood-requests/:id/approve
   → Check message: "no enough blood" / "partially approved" / "fully approved"

6. GET /api/donor/my-requests  (as donor)
   → Verify status updated correctly

7. PUT /api/bloodbankadmin/blood-requests/:id/fulfill
   → Verify status → FULFILLED or PARTIALLY FULFILLED

8. GET /api/donor/my-requests  (as donor)
   → Verify final status

9. POST /api/bloodbankadmin/donor-blood-requests/expire-stale
   → Test 24h expiry cleanup
```

---

## STATUS FLOW DIAGRAM

```
                    ┌─────────┐
                    │ PENDING │
                    └────┬────┘
                         │ Admin clicks APPROVE
           ┌─────────────┼─────────────────┐
           │             │                 │
     (0 blood)    (partial blood)    (full blood)
           │             │                 │
           ▼             ▼                 ▼
       REJECTED   PARTIALLY APPROVED    APPROVED
                         │                 │
                  Admin clicks FULFILL     │
                         │                 │
                         ▼                 ▼
               PARTIALLY FULFILLED      FULFILLED
                    (blood = USED)   (blood = USED)

  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
  If 24 hours pass without FULFILL:
  APPROVED / PARTIALLY APPROVED → REJECTED
  Blood units → back to AVAILABLE
```
