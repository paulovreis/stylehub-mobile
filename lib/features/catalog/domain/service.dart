import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.freezed.dart';
part 'service.g.dart';

@freezed
class Service with _$Service {
  const factory Service({
    int? id,
    String? name,
    int? durationMinutes,
    num? recommendedPrice,
    bool? active,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

  factory Service.parse(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    map['id'] = _toIntOrNull(map['id']);
    map['name'] ??= map['title'];

    map['durationMinutes'] ??= _firstPresent(map, const [
      'duration_minutes',
      'duration',
      'minutes',
    ]);
    map['durationMinutes'] = _toIntOrNull(map['durationMinutes']);

    map['recommendedPrice'] ??= _firstPresent(map, const [
      'recommended_price',
      'price',
      'value',
    ]);
    map['recommendedPrice'] = _toNumOrNull(map['recommendedPrice']);

    map['active'] ??= _firstPresent(map, const ['is_active', 'enabled']);
    map['active'] = _toBoolOrNull(map['active']);

    return Service.fromJson(map);
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

num? _toNumOrNull(Object? value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) {
    final v = value.trim().replaceAll(',', '.');
    return num.tryParse(v);
  }
  return null;
}

bool? _toBoolOrNull(Object? value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final v = value.trim().toLowerCase();
    if (v == 'true' || v == '1' || v == 'yes' || v == 'sim') return true;
    if (v == 'false' || v == '0' || v == 'no' || v == 'nao' || v == 'não') {
      return false;
    }
  }
  return null;
}
