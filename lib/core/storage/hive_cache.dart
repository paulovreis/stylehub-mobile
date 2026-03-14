import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class HiveCache {
  static const _boxName = 'cache';

  static const _kServices = 'catalog.services.json';
  static const _kEmployees = 'catalog.employees.json';
  static const _kMeta = 'salon.meta.json';
  static const _kTimestamps = 'cache.timestamps.json';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }

  Box<String> get _box => Hive.box<String>(_boxName);

  String? readServicesJson() => _box.get(_kServices);
  Future<void> writeServicesJson(String json) => _box.put(_kServices, json);

  String? readEmployeesJson() => _box.get(_kEmployees);
  Future<void> writeEmployeesJson(String json) => _box.put(_kEmployees, json);

  String? readMetaJson() => _box.get(_kMeta);
  Future<void> writeMetaJson(String json) => _box.put(_kMeta, json);

  DateTime? readTimestamp(String key) {
    final raw = _box.get(_kTimestamps);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    final value = decoded[key];
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  Future<void> writeTimestamp(String key, DateTime time) async {
    final raw = _box.get(_kTimestamps);
    final Map<String, Object?> map;
    if (raw == null || raw.isEmpty) {
      map = <String, Object?>{};
    } else {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        map = decoded.map((k, v) => MapEntry(k.toString(), v));
      } else {
        map = <String, Object?>{};
      }
    }

    map[key] = time.toIso8601String();
    await _box.put(_kTimestamps, jsonEncode(map));
  }
}
