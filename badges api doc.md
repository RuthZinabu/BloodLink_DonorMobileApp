 2. API DOCUMENTATION (Frontend Ready)

---

#  BADGE & LEADERBOARD API

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

### Response (has badges)

```json
{
  "message": "Badges retrieved successfully",
  "badges": [
    {
      "badge_id": "b1",
      "donor_id": "d1",
      "badge_name": "Hero Donor",
      "description": "Donated at least 10 times",
      "awarded_at": "2026-05-04T10:00:00Z"
    }
  ]
}
```

### Response (no badges)

```json
{
  "message": "You have no badges yet. Start donating blood to earn rewards ",
  "badges": []
}
```

---

## 2. Get Leaderboard (Donor view)

### Endpoint

```
GET /api/donor/leaderboard?limit=10
```

### Response

```json
{
  "message": "Leaderboard retrieved successfully",
  "leaderboard": [
    {
      "rank": 1,
      "donor_id": "d123",
      "donation_count": 15
    },
    {
      "rank": 2,
      "donor_id": "d456",
      "donation_count": 10
    }
  ]
}
```

---

#  ADMIN APIs

## 3. Get All Badges (Admin)

### Endpoint

```
GET /api/bloodbankadmin/badges
```

### Response

```json
{
  "message": "All badges retrieved successfully",
  "badges": [
    {
      "badge_id": "b1",
      "donor_id": "d1",
      "badge_name": "Hero Donor",
      "description": "Donated at least 10 times",
      "awarded_at": "2026-05-04T10:00:00Z"
    }
  ]
}
```

---

## 4. Get Leaderboard (Admin)

### Endpoint

```
GET /api/bloodbankadmin/leaderboard
```

### Response

```json
{
  "message": "Leaderboard retrieved successfully",
  "leaderboard": [
    {
      "rank": 1,
      "donor_id": "d123",
      "donation_count": 15
    }
  ]
}
```

---

# 3. IMPORTANT BEHAVIOR (VERY IMPORTANT)

##  When is badge created?

Badge is created ONLY when:

### Step flow:

1. Blood Collector creates donation
2. Lab tests it
3. Lab sets:

```
overall_status = "CLEARED"
```

