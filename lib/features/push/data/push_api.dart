import 'package:dio/dio.dart';

class PushApi {
  PushApi(this._dio);

  final Dio _dio;

  Future<void> register({
    required String token,
    required String platform,
    String? deviceName,
  }) async {
    await _dio.post<Object?>(
      '/push/register',
      data: {
        'token': token,
        'platform': platform,
        if (deviceName != null && deviceName.trim().isNotEmpty)
          'device_name': deviceName.trim(),
      },
    );
  }

  Future<void> unregister({required String token}) async {
    await _dio.post<Object?>(
      '/push/unregister',
      data: {
        'token': token,
      },
    );
  }
}
