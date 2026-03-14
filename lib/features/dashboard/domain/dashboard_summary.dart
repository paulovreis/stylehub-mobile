import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary.freezed.dart';
part 'dashboard_summary.g.dart';

@freezed
class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    @Default(0) int unreadNotificationsCount,
    DashboardNextAppointment? nextAppointment,
  }) = _DashboardSummary;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);

  factory DashboardSummary.parse(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    final unreadRaw = map['unreadNotificationsCount'] ?? _firstPresent(map, const [
      'unread_notifications_count',
      'unreadNotifications',
      'unread_notifications',
      'unreadCount',
      'unread_count',
      'unread',
    ]);
    map['unreadNotificationsCount'] = _toIntOrZero(unreadRaw);

    final nextRaw = map['nextAppointment'] ?? _firstPresent(map, const [
      'next_appointment',
      'next',
      'appointment',
      'upcoming',
    ]);

    final nextMap = _toStringKeyedMapOrNull(nextRaw);
    if (nextMap == null) {
      map['nextAppointment'] = null;
    } else {
      final parsed = DashboardNextAppointment.parse(nextMap);
      map['nextAppointment'] = parsed.toJson();
    }

    return DashboardSummary.fromJson(map);
  }
}

@freezed
class DashboardNextAppointment with _$DashboardNextAppointment {
  const factory DashboardNextAppointment({
    int? id,
    String? appointmentDate,
    String? appointmentTime,
    String? status,
    String? serviceName,
    String? employeeName,
  }) = _DashboardNextAppointment;

  factory DashboardNextAppointment.fromJson(Map<String, dynamic> json) =>
      _$DashboardNextAppointmentFromJson(json);

  factory DashboardNextAppointment.parse(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    map['id'] = _toIntOrNull(map['id']);

    map['appointmentDate'] ??= _firstPresent(map, const [
      'appointment_date',
      'date',
      'day',
    ]);

    map['appointmentTime'] ??= _firstPresent(map, const [
      'appointment_time',
      'time',
      'hour',
      'start_time',
      'startTime',
    ]);

    map['serviceName'] ??= _serviceNameFrom(map);
    map['employeeName'] ??= _employeeNameFrom(map);

    return DashboardNextAppointment.fromJson(map);
  }
}

Object? _firstPresent(Map<String, dynamic> map, List<String> keys) {
  for (final k in keys) {
    if (map.containsKey(k) && map[k] != null) return map[k];
  }
  return null;
}

Object? _serviceNameFrom(Map<String, dynamic> map) {
  final direct = _firstPresent(map, const ['service_name', 'serviceName', 'service']);
  if (direct is String) return direct;
  if (direct is Map) {
    final m = direct.map((k, v) => MapEntry(k.toString(), v));
    final name = _firstPresent(m, const ['name', 'title', 'service_name']);
    if (name is String) return name;
  }
  return null;
}

Object? _employeeNameFrom(Map<String, dynamic> map) {
  final direct = _firstPresent(map, const ['employee_name', 'employeeName', 'employee']);
  if (direct is String) return direct;
  if (direct is Map) {
    final m = direct.map((k, v) => MapEntry(k.toString(), v));
    final name = _firstPresent(m, const ['name', 'full_name', 'employee_name']);
    if (name is String) return name;
  }
  return null;
}

int _toIntOrZero(Object? value) => _toIntOrNull(value) ?? 0;

int? _toIntOrNull(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value.trim());
  }
  return null;
}

Map<String, dynamic>? _toStringKeyedMapOrNull(Object? value) {
  if (value is Map) {
    return value.map((k, v) => MapEntry(k.toString(), v));
  }
  return null;
}
