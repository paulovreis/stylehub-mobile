import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_profile.freezed.dart';
part 'me_profile.g.dart';

@freezed
class MeProfile with _$MeProfile {
  const factory MeProfile({
    int? id,
    String? name,
    String? email,
    String? phone,
  }) = _MeProfile;

  factory MeProfile.fromJson(Map<String, dynamic> json) =>
      _$MeProfileFromJson(json);

  factory MeProfile.parse(Map<String, dynamic> json) {
    final top = Map<String, dynamic>.from(json);

    // Contract: { user: {...}, client: {...} }
    // Some backends wrap it: { data: { user: {...}, client: {...} } }
    final envelope = _toStringKeyedMapOrNull(top['data']) ?? top;

    final user = _toStringKeyedMapOrNull(envelope['user']) ??
        _toStringKeyedMapOrNull(envelope['me']);
    final client = _toStringKeyedMapOrNull(envelope['client']);

    final out = <String, dynamic>{};

    // Prefer client.id if present (more useful for profile screens), fallback to user.id.
    out['id'] = _toIntOrNull(
      _firstPresent(
        client ?? user ?? envelope,
        const ['id', 'client_id', 'user_id'],
      ),
    );

    // Prefer client fields; fallback to user/envelope.
    final primary = client ?? envelope;
    final secondary = user ?? envelope;

    out['name'] = _firstPresent(primary, const ['name', 'full_name', 'fullname', 'client_name']) ??
        _firstPresent(secondary, const ['name', 'full_name', 'fullname', 'client_name']);
    out['email'] = _firstPresent(primary, const ['email', 'mail']) ??
        _firstPresent(secondary, const ['email', 'mail']);
    out['phone'] = _firstPresent(primary, const ['phone', 'phone_number', 'mobile', 'cellphone']) ??
        _firstPresent(secondary, const ['phone', 'phone_number', 'mobile', 'cellphone']);

    return MeProfile.fromJson(out);
  }
}

Object? _firstPresent(Map<String, dynamic> map, List<String> keys) {
  for (final k in keys) {
    if (map.containsKey(k) && map[k] != null) return map[k];
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

Map<String, dynamic>? _toStringKeyedMapOrNull(Object? value) {
  if (value is Map) {
    return value.map((k, v) => MapEntry(k.toString(), v));
  }
  return null;
}
