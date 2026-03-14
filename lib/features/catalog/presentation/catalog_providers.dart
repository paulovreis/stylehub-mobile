import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client_provider.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/session/session_controller.dart';
import '../data/catalog_api.dart';
import '../domain/employee.dart';
import '../domain/service.dart';

final catalogApiProvider = Provider<CatalogApi>((ref) {
  final dio = ref.watch(dioProvider);
  return CatalogApi(dio);
});

final servicesControllerProvider =
    AsyncNotifierProvider<ServicesController, List<Service>>(
  ServicesController.new,
);

class ServicesController extends AsyncNotifier<List<Service>> {
  static const _tsKey = 'catalog.services';

  @override
  Future<List<Service>> build() async {
    final cache = ref.read(hiveCacheProvider);
    final cachedRaw = cache.readServicesJson();
    final cached = _parseServiceList(cachedRaw);

    if (cached != null) {
      unawaited(_refreshInBackground());
      return cached;
    }

    return _fetchAndCache();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAndCache);
  }

  Future<void> _refreshInBackground() async {
    try {
      final fresh = await _fetchAndCache();
      try {
        state = AsyncData(fresh);
      } catch (_) {
        // Provider pode ter sido descartado.
      }
    } catch (_) {
      // Silencioso: mantém cache em tela.
    }
  }

  Future<List<Service>> _fetchAndCache() async {
    try {
      final api = ref.read(catalogApiProvider);
      final items = await api.fetchServices();
      final services = items.map(Service.parse).where((s) => s.name != null).toList();

      final cache = ref.read(hiveCacheProvider);
      await cache.writeServicesJson(jsonEncode(items));
      await cache.writeTimestamp(_tsKey, DateTime.now());

      return services;
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }
}

final employeesControllerProvider =
    AsyncNotifierProvider<EmployeesController, List<Employee>>(
  EmployeesController.new,
);

class EmployeesController extends AsyncNotifier<List<Employee>> {
  static const _tsKey = 'catalog.employees';

  @override
  Future<List<Employee>> build() async {
    final cache = ref.read(hiveCacheProvider);
    final cachedRaw = cache.readEmployeesJson();
    final cached = _parseEmployeeList(cachedRaw);

    if (cached != null) {
      unawaited(_refreshInBackground());
      return cached;
    }

    return _fetchAndCache();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAndCache);
  }

  Future<void> _refreshInBackground() async {
    try {
      final fresh = await _fetchAndCache();
      try {
        state = AsyncData(fresh);
      } catch (_) {
        // Provider pode ter sido descartado.
      }
    } catch (_) {
      // Silencioso: mantém cache em tela.
    }
  }

  Future<List<Employee>> _fetchAndCache() async {
    try {
      final api = ref.read(catalogApiProvider);
      final items = await api.fetchEmployees();
      final employees = items.map(Employee.parse).where((e) => e.name != null).toList();

      final cache = ref.read(hiveCacheProvider);
      await cache.writeEmployeesJson(jsonEncode(items));
      await cache.writeTimestamp(_tsKey, DateTime.now());

      return employees;
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }
}

List<Service>? _parseServiceList(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;
    final items = decoded
      .whereType<Map>()
      .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
      .toList();
    return items.map(Service.parse).where((s) => s.name != null).toList();
  } catch (_) {
    return null;
  }
}

List<Employee>? _parseEmployeeList(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;
    final items = decoded
      .whereType<Map>()
      .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
      .toList();
    return items.map(Employee.parse).where((e) => e.name != null).toList();
  } catch (_) {
    return null;
  }
}
