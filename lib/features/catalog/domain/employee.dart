import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
class Employee with _$Employee {
  const factory Employee({
    int? id,
    String? name,
    String? status,
    bool? active,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  factory Employee.parse(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    map['id'] = _toIntOrNull(map['id']);
    map['name'] ??= map['full_name'];

    map['active'] ??= _firstPresent(map, const ['is_active', 'enabled']);
    map['active'] = _toBoolOrNull(map['active']);

    return Employee.fromJson(map);
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
