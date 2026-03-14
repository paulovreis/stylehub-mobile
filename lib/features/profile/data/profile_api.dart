import 'package:dio/dio.dart';

class ProfileApi {
  ProfileApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> fetchMe() async {
    final res = await _dio.get<Object?>('/me');
    final data = res.data;
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    return <String, dynamic>{};
  }

  Future<Map<String, dynamic>> updateMe({
    required String name,
    required String email,
    required String phone,
  }) async {
    final body = <String, Object?>{};
    if (name.trim().isNotEmpty) body['name'] = name.trim();
    if (email.trim().isNotEmpty) body['email'] = email.trim();
    if (phone.trim().isNotEmpty) body['phone'] = phone.trim();

    final res = await _dio.put<Object?>('/me', data: body);
    final data = res.data;
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    return <String, dynamic>{};
  }
}
