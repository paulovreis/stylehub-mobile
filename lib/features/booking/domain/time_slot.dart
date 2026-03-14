import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot.freezed.dart';
part 'time_slot.g.dart';

@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    String? startTime,
    String? endTime,
    bool? isAvailable,
  }) = _TimeSlot;

  factory TimeSlot.fromJson(Map<String, dynamic> json) => _$TimeSlotFromJson(json);

  factory TimeSlot.parse(Object? json) {
    if (json is String) {
      return TimeSlot(startTime: json.trim(), isAvailable: true);
    }
    if (json is Map) {
      final map = json.map((k, v) => MapEntry(k.toString(), v));
      final normalized = <String, dynamic>{};

      normalized['startTime'] = _firstPresent(map, const [
        'start_time',
        'startTime',
        'time',
        'appointment_time',
      ]);
      normalized['endTime'] = _firstPresent(map, const ['end_time', 'endTime']);
      normalized['isAvailable'] = _firstPresent(map, const [
        'is_available',
        'isAvailable',
        'available',
      ]);

      normalized['startTime'] = _toStrOrNull(normalized['startTime']);
      normalized['endTime'] = _toStrOrNull(normalized['endTime']);
      normalized['isAvailable'] = _toBoolOrNull(normalized['isAvailable']) ?? true;

      return TimeSlot.fromJson(normalized);
    }

    return const TimeSlot(isAvailable: true);
  }
}

Object? _firstPresent(Map<String, Object?> map, List<String> keys) {
  for (final k in keys) {
    if (map.containsKey(k) && map[k] != null) return map[k];
  }
  return null;
}

String? _toStrOrNull(Object? value) {
  if (value == null) return null;
  if (value is String) return value.trim();
  return value.toString();
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
