String? extractAccessToken(Map<String, Object?> json) {
  final direct = _extractString(json, ['accessToken', 'access_token', 'token', 'jwt']);
  if (direct != null) return direct;

  final data = json['data'];
  if (data is Map) {
    final map = data.map((k, v) => MapEntry(k.toString(), v));
    final nested = _extractString(map, ['accessToken', 'access_token', 'token', 'jwt']);
    if (nested != null) return nested;
  }

  return null;
}

String? extractUserEmail(Map<String, Object?> json) {
  final envelope = _toStringKeyedMapOrNull(json['data']) ?? json;
  final user = _toStringKeyedMapOrNull(envelope['user']) ??
      _toStringKeyedMapOrNull(envelope['me']);

  final email = user != null ? _extractString(user, ['email', 'mail']) : null;
  if (email != null) return email;

  return _extractString(envelope, ['email', 'mail']);
}

String? _extractString(Map<String, Object?> json, List<String> keys) {
  for (final key in keys) {
    final v = json[key];
    if (v is String && v.trim().isNotEmpty) {
      return v.trim();
    }
  }
  return null;
}

Map<String, Object?>? _toStringKeyedMapOrNull(Object? value) {
  if (value is Map) {
    return value.map((k, v) => MapEntry(k.toString(), v));
  }
  return null;
}
