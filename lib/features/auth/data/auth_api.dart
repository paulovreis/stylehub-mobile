import 'package:dio/dio.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<Map<String, Object?>> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post<Object?>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return _asMap(res.data);
  }

  Future<Map<String, Object?>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final normalizedPhone = phone?.trim();

    final res = await _dio.post<Object?>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (normalizedPhone != null && normalizedPhone.isNotEmpty)
          'phone': normalizedPhone,
      },
    );

    return _asMap(res.data);
  }

  Future<void> forgotPassword({required String email}) async {
    await _dio.post<Object?>(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  Future<bool> validateResetToken({required String token}) async {
    // Contract: GET /auth/validate-reset-token/:token
    final safe = Uri.encodeComponent(token.trim());
    if (safe.isEmpty) return false;

    try {
      await _dio.get<Object?>('/auth/validate-reset-token/$safe');
      return true;
    } on DioException catch (e) {
      // Contract: 400 => invalid/expired token.
      if (e.response?.statusCode == 400) return false;
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _dio.post<Object?>(
      '/auth/reset-password',
      data: {
        'token': token,
        // Contract: newPassword (camelCase)
        'newPassword': newPassword,
      },
    );
  }
}

Map<String, Object?> _asMap(Object? data) {
  if (data is Map) {
    return data.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, Object?>{};
}
