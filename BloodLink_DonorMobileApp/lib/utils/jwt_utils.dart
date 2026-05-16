import 'dart:convert';

class JwtUtils {
  /// Decodes the payload of a JWT without verifying the signature.
  /// Returns null if the token is malformed.
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];
      // Add padding if needed for base64 decoding
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }
      // Replace URL-safe chars
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');

      final decoded = utf8.decode(base64.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Returns the expiry [DateTime] from a JWT, or null if not present.
  static DateTime? getExpiry(String token) {
    final payload = decodePayload(token);
    if (payload == null) return null;
    final exp = payload['exp'];
    if (exp == null) return null;
    final expInt = exp is int ? exp : int.tryParse(exp.toString());
    if (expInt == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(expInt * 1000, isUtc: true);
  }

  /// Returns true if the token is expired or expires within [bufferSeconds].
  static bool isExpiredOrExpiringSoon(String token, {int bufferSeconds = 120}) {
    final expiry = getExpiry(token);
    if (expiry == null) return true;
    final now = DateTime.now().toUtc();
    return now.isAfter(expiry.subtract(Duration(seconds: bufferSeconds)));
  }

  /// Returns seconds until the token expires. Negative if already expired.
  static int secondsUntilExpiry(String token) {
    final expiry = getExpiry(token);
    if (expiry == null) return -1;
    return expiry.difference(DateTime.now().toUtc()).inSeconds;
  }
}
