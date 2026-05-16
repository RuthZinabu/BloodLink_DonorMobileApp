# Bloodlink API Documentation: Notifications

This document details the in-app notification endpoints. All endpoints require the user to be authenticated. The system automatically extracts the `userID` from the JWT token.

---

## 1. Get All Notifications

Retrieves all notifications for the currently logged-in user, ordered by creation date (newest first).

*   **URL**: `/api/notifications/`
*   **Method**: `GET`
*   **Auth Required**: `Yes` (Any Role)
*   **Request Body**: None
*   **Response (Success)**:
    *   **Code**: 200 OK
    *   **Body**:
        ```json
        [
          {
            "notification_id": "notif-1234-5678",
            "user_id": "user-abcd-efgh",
            "type": "EMERGENCY",
            "title": "URGENT: Blood Emergency",
            "message": "City Hospital needs O- blood.",
            "is_read": false,
            "created_at": "2026-05-06T12:00:00Z"
          },
          {
            "notification_id": "notif-9876-5432",
            "user_id": "user-abcd-efgh",
            "type": "CAMPAIGN",
            "title": "New Blood Drive",
            "message": "A new campaign 'Summer Drive' has been created at Central Park",
            "is_read": true,
            "created_at": "2026-05-05T09:30:00Z"
          }
        ]
        ```

---

## 2. Mark Notification as Read

Marks a specific notification as read. The system verifies that the notification belongs to the logged-in user before updating it.

*   **URL**: `/api/notifications/:id/read`
*   **Method**: `PUT`
*   **Auth Required**: `Yes` (Any Role)
*   **URL Parameters**:
    *   `id`: The UUID of the notification.
*   **Request Body**: None
*   **Response (Success)**:
    *   **Code**: 200 OK
    *   **Body**:
        ```json
        {
          "message": "Notification marked as read"
        }
        ```
*   **Response (Error - Not Found or Unauthorized)**:
    *   **Code**: 500 Internal Server Error (or 404/403 depending on specific handler tuning)
    *   **Body**:
        ```json
        {
          "error": "notification not found or unauthorized"
        }
        ```

---

## 3. Mark All Notifications as Read

Marks all unread notifications for the currently logged-in user as read.

*   **URL**: `/api/notifications/read-all`
*   **Method**: `PUT`
*   **Auth Required**: `Yes` (Any Role)
*   **Request Body**: None
*   **Response (Success)**:
    *   **Code**: 200 OK
    *   **Body**:
        ```json
        {
          "message": "All notifications marked as read"
        }
        ```

---

## Notification Types

The `type` field in the notification object can be one of the following:

*   **`CAMPAIGN`**: Sent to donors when a new blood drive campaign is created.
*   **`EMERGENCY`**: Sent to donors when a blood emergency matching their location/blood type is published.
*   **`TEST_RESULT`**: Sent to a donor when their lab test result is processed.
*   **`DONATION`**: Sent to lab technicians when a new blood donation is collected and awaits testing.
*   **`BLOOD_REQUEST`**: Sent to admins when a hospital requests blood, and to hospitals when their request status updates.
*   **`CONTRACT`**: Sent to admins for new hospital registrations/signatures, and to hospitals when contracts are finalized or rejected.
