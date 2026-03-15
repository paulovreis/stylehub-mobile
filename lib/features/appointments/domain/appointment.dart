import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

enum AppointmentStatus {
  scheduled,
  confirmed,
  completed,
  canceled,
  unknown,
}

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    int? id,
    String? appointmentDate,
    String? appointmentTime,
    String? status,
    String? serviceName,
    String? employeeName,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  factory Appointment.parse(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    map['id'] = _toIntOrNull(map['id']);

    map['appointmentDate'] ??= _firstPresent(map, const [
      'appointment_date',
      'date',
      'day',
    ],);

    map['appointmentTime'] ??= _firstPresent(map, const [
      'appointment_time',
      'time',
      'hour',
      'start_time',
      'startTime',
    ],);

    map['serviceName'] ??= _serviceNameFrom(map);
    map['employeeName'] ??= _employeeNameFrom(map);

    // Normaliza status (scheduled/confirmed/completed/canceled).
    final status = _normalizeStatus(
      _firstPresent(map, const [
        'status',
        'state',
        'appointment_status',
      ],),
    );
    map['status'] = status;

    return Appointment.fromJson(map);
  }
}

extension AppointmentX on Appointment {
  AppointmentStatus get statusEnum => _statusEnumFrom(status);

  bool get isUpcoming {
    final s = statusEnum;
    return s == AppointmentStatus.scheduled || s == AppointmentStatus.confirmed;
  }

  bool get isHistory {
    final s = statusEnum;
    return s == AppointmentStatus.completed || s == AppointmentStatus.canceled;
  }

  bool get canCancel {
    // Requisito: cancelar só quando "scheduled".
    return statusEnum == AppointmentStatus.scheduled;
  }
}

Object? _firstPresent(Map<String, dynamic> map, List<String> keys) {
  for (final k in keys) {
    if (map.containsKey(k) && map[k] != null) return map[k];
  }
  return null;
}

Object? _serviceNameFrom(Map<String, dynamic> map) {
  final direct =
      _firstPresent(map, const ['service_name', 'serviceName', 'service']);
  if (direct is String) return direct;
  if (direct is Map) {
    final m = direct.map((k, v) => MapEntry(k.toString(), v));
    final name = _firstPresent(m, const ['name', 'title', 'service_name']);
    if (name is String) return name;
  }
  return null;
}

Object? _employeeNameFrom(Map<String, dynamic> map) {
  final direct =
      _firstPresent(map, const ['employee_name', 'employeeName', 'employee']);
  if (direct is String) return direct;
  if (direct is Map) {
    final m = direct.map((k, v) => MapEntry(k.toString(), v));
    final name = _firstPresent(m, const ['name', 'full_name', 'employee_name']);
    if (name is String) return name;
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

String? _normalizeStatus(Object? value) {
  if (value == null) return null;
  final v = value.toString().trim().toLowerCase();
  if (v.isEmpty) return null;

  // Aceita variações comuns.
  if (v == 'cancelled') return 'canceled';
  if (v == 'canceled' || v == 'scheduled' || v == 'confirmed' || v == 'completed') {
    return v;
  }

  return v;
}

AppointmentStatus _statusEnumFrom(String? raw) {
  final v = (raw ?? '').trim().toLowerCase();
  switch (v) {
    case 'scheduled':
      return AppointmentStatus.scheduled;
    case 'confirmed':
      return AppointmentStatus.confirmed;
    case 'completed':
      return AppointmentStatus.completed;
    case 'canceled':
    case 'cancelled':
      return AppointmentStatus.canceled;
    default:
      return AppointmentStatus.unknown;
  }
}
