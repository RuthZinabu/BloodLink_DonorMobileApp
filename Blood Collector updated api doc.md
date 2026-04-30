## **Blood Collector API Documentation**

### **Base URL**

```
http://localhost:8080/api/bloodcollector
```

### **Authentication**

- Requires **JWT token (Blood Collector role)**

```
Authorization: Bearer <JWT_TOKEN>
```

---

# 🔷 **Workflow Overview (IMPORTANT for Frontend)**

The blood collector flow is:

1. **View pending donors**
2. **Search or select a donor**
3. **Get donor details**
4. **Record donation**
5. **View and manage donations**
6. **Update donation or override status**

---

# 🟢 **1. Pending Donors (START HERE)**

## **1.1 Get All Pending Donors**

- **Endpoint:** `GET /donors`

- **Description:**
  - Returns donors who **have NOT yet been screened/donated**

- **Response (200 OK):**

```json
[
  {
    "donor_id": "uuid",
    "user_id": "uuid",
    "full_name": "Selam",
    "email": "selam@gmail.com",
    "phone": "+2519...",
    "blood_type": "O+",
    "overall_status": "Pending"
  }
]
```

---

## **1.2 Get Pending Donor by ID**

- **Endpoint:** `GET /donor/:id`

- **Use Case:**
  - When user clicks a donor from the list

- **Response (200 OK):**

```json
{
  "donor_id": "uuid",
  "user_id": "uuid",
  "full_name": "Selam",
  "email": "selam@gmail.com",
  "phone": "+2519...",
  "blood_type": "O+",
  "overall_status": "Pending"
}
```

- **Errors:**
  - `404` — donor not found or already screened

---

## **1.3 Search Pending Donor**

- **Endpoint:** `GET /donor/search/pending?q=<query>`

- **Query Param:**
  - `q` = email or phone

- **Example:**

```
GET /donor/search/pending?q=selam@gmail.com
```

- **Response:** Same as above

---

# 🟠 **2. Create Donation (Screening + Collection)**

## **2.1 Create Donation Record**

- **Endpoint:** `POST /donation`

- **Description:**
  - This is the **main action after selecting a donor**

- **Body:**

````json
{
  "donor_id": "uuid",
  "campaign_id": "uuid",
  "collected_by": "collector_user_id",
  "weight": 72,
  "blood_pressure": "120/80",
  "hemoglobin": 13,
  "temperature": 36.7,
  "pulse": 80,
  "quantity_ml": 450,
  "collection_date": "2026-03-18T10:00:00Z"
}

---

### ⚠️ **System Rules**

- **Automatic Status Evaluation:**
  - Weight < 50 → `REJECTED_TEMPORARY`
  - Hemoglobin < 12 → `REJECTED_TEMPORARY`
  - Temperature > 37.5 → `REJECTED_TEMPORARY`
  - Otherwise → `APPROVED`

- **3-Month Rule:**
  - Donor cannot donate within **3 months**

---

### **Response (201 Created)**

```json
{
  "donation_id": "uuid",
  "campaign_id": "uuid"
  "donor_id": "uuid",
  "collected_by": "uuid",
  "weight": 72,
  "blood_pressure": "120/80",
  "hemoglobin": 13,
  "temperature": 36.7,
  "pulse": 80,
  "quantity_ml": 450,
  "collection_date": "2026-03-18T10:00:00Z",
  "status": "APPROVED",
  "created_at": "2026-03-18T10:20:00Z"
}
````

---

# 🔵 **3. View Donations**

## **3.1 Get All Donations**

- **Endpoint:** `GET /donation`

- **Response:**

```json
[
  {
    "donation_id": "...",
    "donor_id": "...",
    "campaign_id": "uuid"
    "collected_by": "...",
    "donor_name": "Selam",
    "collector_name": "Abebe",
    "weight": 72,
    "blood_pressure": "120/80",
    "hemoglobin": 13,
    "temperature": 36.7,
    "pulse": 80,
    "quantity_ml": 450,
    "collection_date": "2026-03-18T10:00:00Z",
    "status": "APPROVED",
    "created_at": "2026-03-18T10:20:00Z"
  }
]
```

---

## **3.2 Get Donation by ID**

- **Endpoint:** `GET /donation/:id`

- **Use Case:**
  - View full donation details

---

# 🔷 **5. Donor Self-Service**

## **5.1 Donor Registration**

- **Endpoint:** `POST /api/donor/register`

- **Description:**
  - Dedicated registration for donors.
  
- **Body:** Same as standard registration.

---

## **3.3 Get My Donations (Protected)**

- **Endpoint:** `GET /api/donor/donations`

- **Description:**
  - Retrieve all donation records for the currently logged-in donor.
  - **Note:** Requires **JWT token (Donor role)**. The ID is automatically extracted from the token.

- **Response:**
  - An array of donation records.

---

## **3.4 Get My Latest Test Result (Protected)**

- **Endpoint:** `GET /api/donor/test-result/latest`

- **Description:**
  - Retrieve the most recent lab test results for the currently logged-in donor.
  - **Note:** Requires **JWT token (Donor role)**. The ID is automatically extracted from the token.

- **Response (200 OK):**

```json
{
  "test_id": "uuid",
  "donation_id": "uuid",
  "donor_id": "uuid",
  "tested_by": "labtech_user_id",
  "hiv_result": "NEGATIVE",
  "hepatitis_result": "NEGATIVE",
  "syphilis_result": "NEGATIVE",
  "blood_type": "O+",
  "overall_status": "CLEARED",
  "created_at": "2026-03-18T14:30:00Z"
}
```

---

# 🟡 **4. Update Donation**

## **4.1 Update Medical Information**

- **Endpoint:** `PUT /donation/:id`

- **Body:**

```json
{
  "donor_id": "uuid",
  "weight": 70,
  "blood_pressure": "115/75",
  "hemoglobin": 12.5,
  "temperature": 36.8,
  "pulse": 78,
  "quantity_ml": 450,
  "collection_date": "2026-03-18T10:00:00Z"
}
```

### ⚠️ Behavior:

- System **re-evaluates status automatically**
- Updates **donor weight**
- Prevents wrong donor update

---

## **4.2 Manual Status Override**

- **Endpoint:** `PUT /donation/:id/status`

- **Body:**

```json
{
  "status": "APPROVED"
}
```

- **Use Case:**
  - Blood collector overrides system decision

---

# 🔴 **Key Business Rules (VERY IMPORTANT)**

1. Only **pending donors** can be selected for donation
2. Donation status is **automatically calculated**
3. **3-month restriction** is enforced
4. Updating donation will:
   - Recalculate status
   - Update donor weight

5. Blood collector can **override status manually**

---

# ✅ **Frontend Flow Summary**

👉 Your UI should follow this:

1. Call → `GET /donors`
2. blood collecter selects donor OR search → `/donor/search/pending`
3. Show donor details → `/donor/:id`
4. Submit form → `POST /donation`
5. Show result → status (APPROVED / REJECTED)
6. Manage → `/donation` endpoints

Note

- Donation may optionally belong to a campaign
- If no campaign is provided, campaign_id will be NULL

---

# 🏥 **6. Hospital Admin (Blood Requests & Analytics)**

## **6.1 Get Hospital Blood Requests (with Filters)**

- **Endpoint:** `GET /api/hospitaladmin/blood-requests/`

- **Authentication:** Requires **JWT token (Hospital Admin role)**.

- **Optional Query Parameters:**
  - `blood_type`: Filter by blood type (e.g., `A+`, `O-`).
  - `status`: Filter by status (e.g., `PENDING`, `FULFILLED`).
  - `urgency_level`: Filter by urgency (e.g., `CRITICAL`, `HIGH`).

- **Example:**
  ```
  GET /api/hospitaladmin/blood-requests/?status=PENDING&blood_type=A+
  ```

- **Response (200 OK):**
  ```json
  [
    {
      "request_id": "uuid",
      "hospital_id": "uuid",
      "hospital_name": "St. Paul Hospital",
      "blood_type": "A+",
      "quantity": 10,
      "urgency_level": "CRITICAL",
      "status": "PENDING",
      "created_at": "2026-04-29T10:00:00Z",
      "approved_at": null
    }
  ]
  ```

---

## **6.2 Get Hospital Dashboard Analytics**

- **Endpoint:** `GET /api/hospitaladmin/dashboard`

- **Description:**
  - Retrieve high-level analytics and trends for the logged-in hospital.

- **Response (200 OK):**
  ```json
  {
    "total_requests": 45,
    "approved_requests": 30,
    "partially_fulfilled": 5,
    "rejected_requests": 2,
    "pending_requests": 8,
    "contract_status": "FINALIZED",
    "contract_end_date": "2027-04-29T00:00:00Z",
    "most_requested_blood_type": "O+",
    "total_units_requested": 450,
    "recent_requests": [...],
    "monthly_request_trends": [
      { "month": "Jan", "count": 5 },
      { "month": "Feb", "count": 8 }
    ]
  }
  ```
