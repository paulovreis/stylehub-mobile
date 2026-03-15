import 'dart:convert';

/// Minimal JWT helpers (no signature verification).
///
/// Used only to detect token expiration client-side and avoid treating an
/// expired token as an authenticated session.
class JwtUtils {
  static DateTime? expiryUtc(String token) {
    final payload = _decodePayload(token);
    if (payload == null) return null;

    final exp = payload['exp'];
    final seconds = _toIntOrNull(exp);
    if (seconds == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
  }

  static bool isExpired(
    String token, {
    Duration clockSkew = const Duration(seconds: 30),
  }) {
    final exp = expiryUtc(token);
    if (exp == null) return false;
    final now = DateTime.now().toUtc();
    return now.isAfter(exp.subtract(clockSkew));
  }
}

Map<String, Object?>? _decodePayload(String token) {
  final parts = token.split('.');
  if (parts.length < 2) return null;

  final payloadPart = parts[1];
  final normalized = base64Url.normalize(payloadPart);

  try {
    final bytes = base64Url.decode(normalized);
    final decoded = utf8.decode(bytes);
    final json = jsonDecode(decoded);
    if (json is Map) {
      return json.map((k, v) => MapEntry(k.toString(), v));
    }
  } catch (_) {
    // ignore
  }

  return null;
}

int? _toIntOrNull(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}
