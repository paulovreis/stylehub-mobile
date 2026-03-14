import 'package:dio/dio.dart';

class CatalogApi {
  CatalogApi(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> fetchServices() async {
    final res = await _dio.get<Object?>('/services');
    final data = res.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  Future<List<Map<String, dynamic>>> fetchEmployees() async {
    final res = await _dio.get<Object?>('/employees');
    final data = res.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }
}
