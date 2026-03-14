import 'package:dio/dio.dart';

class DashboardApi {
  DashboardApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> fetchDashboard() async {
    final res = await _dio.get<Object?>('/dashboard');
    final data = res.data;
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    return <String, dynamic>{};
  }
}
