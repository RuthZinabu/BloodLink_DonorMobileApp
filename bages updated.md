# BADGE & LEADERBOARD API (UPDATED)

Base URL:

```
/api
```

---

# DONOR APIs

## 1. Get My Badges

### Endpoint

```
GET /api/donor/badges
```

### Auth

✔ Required (Donor token)

---

### Response (with badges)

```json
{
  "message": "Badges retrieved successfully",
  "badges": [
    {
      "badge_id": "b1",
      "donor_id": "d1",
      "badge_name": "Starter Donor",
      "description": "Completed your first successful donation",
      "awarded_at": "2026-05-07T04:09:26.003919Z"
    },
    {
      "badge_id": "b2",
      "donor_id": "d1",
      "badge_name": "Regular Donor",
      "description": "Completed 5 successful donations",
      "awarded_at": "2026-05-10T10:00:00Z"
    }
  ]
}
```

---

### Response (no badges)

```json
{
  "message": "You have no badges yet. Start donating blood to earn rewards 🩸",
  "badges": []
}
```

---

# LEADERBOARD APIs

## 2. Get Leaderboard (Donor View)

### Endpoint

```
GET /api/donor/leaderboard?limit=10
```

### Auth

✔ Required (Donor token)

---

### Response

```json
{
  "message": "Leaderboard retrieved successfully",
  "leaderboard": [
    {
      "rank": 1,
      "donor_id": "d123",
      "full_name": "Nebiyat Takele",
      "profile_picture_url": "https://image.com/pic.jpg",
      "donation_count": 15
    },
    {
      "rank": 2,
      "donor_id": "d456",
      "full_name": "Helen Takele",
      "profile_picture_url": "",
      "donation_count": 10
    }
  ]
}
```

---

### Ranking Rule (IMPORTANT)

- Same donation count → same rank
- Example:

| Donor | Donations | Rank |
| ----- | --------- | ---- |
| A     | 10        | 1    |
| B     | 10        | 1    |
| C     | 8         | 3    |

---

# BADGE SYSTEM BEHAVIOR

## Badge rules

| Donations | Badge Name     |
| --------- | -------------- |
| 1–4       | Starter Donor  |
| 5–9       | Regular Donor  |
| 10–19     | Hero Donor     |
| 20–29     | Champion Donor |
| 30–49     | Elite Donor    |
| 50–99     | Legend Donor   |
| 100+      | Ultimate Hero  |

---

## Description Rule (UPDATED)

Descriptions are **dynamic**:

```text
Completed X successful donations
```

Special case:

- 1 donation → "Completed your first successful donation"

---

# ⚙️ WHEN BADGES ARE CREATED

Badges are evaluated when:

1. Donation is completed
2. Test result is marked:

```
overall_status = "CLEARED"
```

# ADMIN APIs (UPDATED)

Base URL:

```
/api
```

---

## Get Leaderboard (Admin View)

### Endpoint

```http id="adm1"
GET /api/bloodbankadmin/leaderboard?limit=10
```

---

### Auth

✔ Required
✔ Role: `BloodBankAdmin`

---

# 📌 Description

Returns top donors ranked by **successful (CLEARED) donations**, including:

- donor ID
- full name
- profile picture
- donation count
- rank (competition ranking)

---

# Response

```json id="adm2"
{
  "message": "Leaderboard retrieved successfully",
  "leaderboard": [
    {
      "rank": 1,
      "donor_id": "d123",
      "full_name": "Nebiyat Takele",
      "profile_picture_url": "https://image.com/pic.jpg",
      "donation_count": 20
    },
    {
      "rank": 2,
      "donor_id": "d456",
      "full_name": "Helen Takele",
      "profile_picture_url": "",
      "donation_count": 15
    }
  ]
}
```

---

# EMPTY RESPONSE

```json id="adm3"
{
  "message": "No donors on the leaderboard yet",
  "leaderboard": []
}
```
