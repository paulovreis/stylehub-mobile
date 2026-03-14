import 'package:dio/dio.dart';

class SafeLogInterceptor extends Interceptor {
  SafeLogInterceptor({required this.enabled});

  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      final headers = Map<String, Object?>.from(options.headers);
      headers.remove('Authorization');
      // ignore: avoid_print
      print('➡️  ${options.method} ${options.uri}');
      // ignore: avoid_print
      print('Headers: $headers');
      if (options.data != null) {
        // ignore: avoid_print
        print('Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      // ignore: avoid_print
      print('✅ ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      // ignore: avoid_print
      print('⛔ ${err.response?.statusCode} ${err.requestOptions.uri}');
    }
    handler.next(err);
  }
}
