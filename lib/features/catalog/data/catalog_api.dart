import 'package:dio/dio.dart';

class CatalogApi {
  CatalogApi(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> fetchServices() async {
    final res = await _dio.get<Object?>('/services');
    return _extractListOfMaps(res.data, const ['services', 'data', 'items']);
  }

  Future<List<Map<String, dynamic>>> fetchEmployees({int? serviceId}) async {
    final res = await _dio.get<Object?>(
      '/employees',
      queryParameters: {
        if (serviceId != null) 'service_id': serviceId,
      },
    );
    return _extractListOfMaps(res.data, const ['employees', 'data', 'items']);
  }
}

List<Map<String, dynamic>> _extractListOfMaps(
  Object? raw,
  List<String> listKeys,
) {
  if (raw is List) {
    return raw
        .whereType<Map>()
        .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  if (raw is Map) {
    final map = raw.map((k, v) => MapEntry(k.toString(), v));
    for (final key in listKeys) {
      final value = map[key];
      if (value is List) {
        return value
            .whereType<Map>()
            .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
            .toList();
      }
    }
  }

  return <Map<String, dynamic>>[];
}
