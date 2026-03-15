import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:stylehub_mobile/features/notifications/data/notifications_api.dart';

void main() {
  test('NotificationsApi sends limit without page on first page', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/mobile'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onGet(
      '/notifications',
      (server) => server.reply(200, []),
      queryParameters: {
        'limit': 20,
      },
    );

    final api = NotificationsApi(dio);
    await api.fetchNotifications(page: 1, limit: 20);
  });

  test('NotificationsApi sends page for page>1', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/mobile'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onGet(
      '/notifications',
      (server) => server.reply(200, []),
      queryParameters: {
        'limit': 20,
        'page': 2,
      },
    );

    final api = NotificationsApi(dio);
    await api.fetchNotifications(page: 2, limit: 20);
  });
}
