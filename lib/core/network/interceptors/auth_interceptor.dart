import 'package:dio/dio.dart';

typedef TokenProvider = String? Function();

typedef OnUnauthorized = void Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenProvider,
    required this.onUnauthorized,
  });

  final TokenProvider tokenProvider;
  final OnUnauthorized onUnauthorized;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onUnauthorized();
    }
    handler.next(err);
  }
}
