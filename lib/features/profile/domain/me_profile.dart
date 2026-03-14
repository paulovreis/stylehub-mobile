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
    final map = Map<String, dynamic>.from(json);

    // Alguns backends retornam envelope (ex: { data: { ... } } ou { user: { ... } }).
    final inner = _toStringKeyedMapOrNull(
      map['data'] ?? map['user'] ?? map['me'],
    );
    final src = inner ?? map;

    final out = <String, dynamic>{};

    out['id'] = _toIntOrNull(_firstPresent(src, const ['id', 'user_id', 'client_id']));
    out['name'] = _firstPresent(src, const ['name', 'full_name', 'fullname', 'client_name']);
    out['email'] = _firstPresent(src, const ['email', 'mail']);
    out['phone'] = _firstPresent(src, const ['phone', 'phone_number', 'mobile', 'cellphone']);

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
