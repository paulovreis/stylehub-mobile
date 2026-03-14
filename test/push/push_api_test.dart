import 'package:stylehub_mobile/features/push/data/push_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('PushApi.register posts token and platform', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/mobile'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onPost(
      '/push/register',
      (server) => server.reply(200, {}),
      data: {
        'token': 't123',
        'platform': 'android',
      },
    );

    final api = PushApi(dio);
    await api.register(token: 't123', platform: 'android');
  });

  test('PushApi.unregister posts token', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/mobile'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onPost(
      '/push/unregister',
      (server) => server.reply(200, {}),
      data: {
        'token': 't123',
      },
    );

    final api = PushApi(dio);
    await api.unregister(token: 't123');
  });
}
