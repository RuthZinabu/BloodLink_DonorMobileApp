````markdown
# Campaign API Documentation

## Base URL

/api

---

# Donor

These endpoints are accessible by:

- Donors

They are mainly used to view active blood donation campaigns.

---

# 1. Get Campaigns

## Endpoint

GET /api/campaigns

## Description

Returns all active/live and upcoming  campaigns.

Supports filtering by:

- title
- location
- start date
- end date

Expired campaigns are not returned.

---

## Query Parameters

| Parameter  | Type   | Description                               |
| ---------- | ------ | ----------------------------------------- |
| title      | string | Filter campaigns by title                 |
| location   | string | Filter campaigns by location              |
| start_date | string | Filter campaigns starting after this date |
| end_date   | string | Filter campaigns ending before this date  |

---

## Example Request

GET /api/campaigns?location=Addis&title=blood

---

## Success Response

```json
{
  "campaigns": [
    {
      "campaign_id": "a12b34c5",
      "title": "Blood Donation Drive",
      "content": "Donate blood and save lives",
      "location": "Addis Ababa",
      "start_date": "2026-05-20T08:00:00Z",
      "end_date": "2026-05-25T17:00:00Z",
      "created_at": "2026-05-10T10:00:00Z"
    }
  ],
  "ongoing_campaigns": 1,
  "closing_soon_campaigns": 0
}
````

---

# 2. Get Campaign By ID

## Endpoint

GET /api/campaigns/:id

## Description

Returns a single campaign by campaign ID.

Accessible by:

* Donors


---

## Example Request

GET /api/campaigns/a12b34c5

---

## Success Response

```json
{
  "campaign_id": "a12b34c5",
  "title": "Blood Donation Drive",
  "content": "Donate blood and save lives",
  "location": "Addis Ababa",
  "start_date": "2026-05-20T08:00:00Z",
  "end_date": "2026-05-25T17:00:00Z",
  "created_at": "2026-05-10T10:00:00Z"
}
```

---

## Error Response

```json
{
  "error": "campaign not found"
}
```

---

# Blood Bank Admin Campaign APIs

These endpoints are accessible only by users with:

BloodBankAdmin role

---

## Authorization Header

Authorization: Bearer <token>

---

# 3. Create Campaign

## Endpoint

POST /api/bloodbankadmin/campaigns

## Description

Creates a new blood donation campaign.

---

## Request Body

```json
{
  "title": "Emergency Blood Drive",
  "content": "Urgent blood donation needed",
  "location": "Addis Ababa",
  "start_date": "2026-05-20T08:00:00Z",
  "end_date": "2026-05-25T17:00:00Z"
}
```

---

## Success Response

```json
{
  "campaign_id": "a12b34c5",
  "title": "Emergency Blood Drive",
  "content": "Urgent blood donation needed",
  "location": "Addis Ababa",
  "start_date": "2026-05-20T08:00:00Z",
  "end_date": "2026-05-25T17:00:00Z",
  "created_at": "2026-05-15T10:00:00Z"
}
```

---

## Error Responses

### Missing Required Field

```json
{
  "error": "Key: 'Title' Error:Field validation for 'Title' failed on the 'required' tag"
}
```

### Invalid Start Date

```json
{
  "error": "campaign start date cannot be in the past"
}
```

---

# 4. Get All Campaigns (Admin)

## Endpoint

GET /api/bloodbankadmin/campaigns

## Description

Returns all campaigns including:

* Active campaigns
* Upcoming campaigns
* Expired campaigns
*closed_campaigns

Supports filtering and sorting.

---

## Query Parameters

| Parameter  | Type    | Description                  |
| ---------- | ------- | ---------------------------- |
| title      | string  | Filter by title              |
| location   | string  | Filter by location           |
| start_date | string  | Filter by start date         |
| end_date   | string  | Filter by end date           |
| live_only  | boolean | Return only active campaigns |

---

## Example Request

GET /api/bloodbankadmin/campaigns?live_only=true

---

## Success Response

```json
{
  "campaigns": [
    {
      "campaign_id": "a12b34c5",
      "title": "Emergency Blood Drive",
      "content": "Urgent blood donation needed",
      "location": "Addis Ababa",
      "start_date": "2026-05-20T08:00:00Z",
      "end_date": "2026-05-25T17:00:00Z",
      "created_at": "2026-05-15T10:00:00Z"
    }
  ],
  "total_campaigns": 1,
  "ongoing_campaigns": 1,
  "closing_soon_campaigns": 0
}
```

---

# 5. Update Campaign

## Endpoint

PUT /api/bloodbankadmin/campaigns/:id

## Description

Updates an existing campaign.

All fields are optional and can be updated:

* title
* content
* location
* start_date
* end_date

You can update:

* one field only
* multiple fields
* all fields together

---

## Example Request (Partial Update)

```json
{
  "title": "Updated Campaign Title",
  "location": "Adama"
}
```

---

## Example Request (Update All Fields)

```json
{
  "title": "Updated Campaign",
  "content": "Updated campaign content",
  "location": "Addis Ababa",
  "start_date": "2026-05-20T08:00:00Z",
  "end_date": "2026-05-30T17:00:00Z"
}
```

---

## Success Response

```json
{
  "message": "Campaign updated successfully"
}
```

---

## Error Response

```json
{
  "error": "campaign not found"
}
```

---

# 6. Delete Campaign

## Endpoint

DELETE /api/bloodbankadmin/campaigns/:id

## Description

Soft deletes a campaign by campaign ID.

The campaign will no longer appear in active campaign listings.

---

## Example Request

DELETE /api/bloodbankadmin/campaigns/a12b34c5

---

## Success Response

```json
{
  "message": "Campaign deleted successfully"
}
```

---

## Error Response

```json
{
  "error": "failed to delete campaign"
}
```

```
```
