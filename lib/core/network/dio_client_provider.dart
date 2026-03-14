import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/providers.dart';
import '../session/session_controller.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final sessionAsync = ref.watch(sessionControllerProvider);
  final session = sessionAsync.value;
  final baseUrl = session?.selectedSalon?.baseUrl;
  final config = ref.watch(appConfigProvider);

  if (baseUrl == null || baseUrl.trim().isEmpty) {
    return Dio();
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: _mobileBase(baseUrl),
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      tokenProvider: () => ref.read(sessionControllerProvider).value?.accessToken,
      onUnauthorized: () {
        ref.read(sessionControllerProvider.notifier).clearAccessToken();
      },
    ),
  );

  dio.interceptors.add(SafeLogInterceptor(enabled: config.enableNetworkLogs));

  return dio;
});

String _mobileBase(String baseUrl) {
  final trimmed = baseUrl.trim().replaceAll(RegExp(r'/*$'), '');
  return '$trimmed/mobile';
}
