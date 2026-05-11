# Donor Side API Documentation

## Get Authenticated User Profile

Returns the profile of the currently authenticated user.
If the user is a donor, the response includes donor information and eligibility status.

---

## Endpoint

```http
GET /api/protected/profile
```

---

## Authentication

Required (JWT Token)

### Header

```http
Authorization: Bearer <token>
```

---

## Success Response (`200 OK`)

```json
{
  "profile_id": "uuid",
  "user_id": "uuid",
  "full_name": "John Doe",
  "phone": "0912345678",
  "address": "Addis Ababa",
  "profile_picture_url": "https://example.com/profile.jpg",

  "donor_info": {
    "donor_id": "uuid",
    "blood_type": "O+",
    "status": "APPROVED",
    "overall_status": "CLEARED",
    "last_donation_date": "2024-02-10"
  },

  "eligibility": {
    "is_eligible": true,
    "eligibility_status": "Eligible",
    "eligibility_message": "Eligible — You can come and donate at any time.",
    "countdown_days": 0
  }
}
```

---

# Eligibility Rules

## Eligible Donor

A donor is eligible if:

* The donor has never donated before, OR
* More than 90 days have passed since the last donation
* AND the donor is not permanently deferred

This includes:

* `CLEARED`
* `TEMPORARILY_DEFERRED` (after 90 days)

---

## Not Eligible Donor

A donor is not eligible if:

* Less than 90 days have passed since the last donation
* Overall lab status is `PENDING`
* Permanently deferred

---

## Permanent Deferral

If:

```text
overall_status = PERMANENTLY_DEFERRED
```

The donor can never donate again.

---

# Status Definitions

## Collector Side Status (`status`)

Stored in Donation Record table.

| Status             | Description                   |
| ------------------ | ----------------------------- |
| APPROVED           | Passed initial screening      |
| REJECTED_TEMPORARY | Failed temporary vitals check |
| PENDING            | Initial state                 |

---

## Lab Side Status (`overall_status`)

Stored in Donor table.

| Status               | Description             |
| -------------------- | ----------------------- |
| CLEARED              | Blood safe for use      |
| TEMPORARILY_DEFERRED | Temporary medical issue |
| PERMANENTLY_DEFERRED | Permanent exclusion     |
