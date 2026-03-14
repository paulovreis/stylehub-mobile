import 'package:beauty_salon_client/features/appointments/data/appointments_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('AppointmentsApi sends scope+limit without page on first page', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/mobile'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onGet(
      '/appointments',
      (server) => server.reply(200, []),
      queryParameters: {
        'scope': 'upcoming',
        'limit': 20,
      },
    );

    final api = AppointmentsApi(dio);
    await api.fetchAppointments(scope: 'upcoming', page: 1, limit: 20);
  });

  test('AppointmentsApi sends page for page>1', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/mobile'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onGet(
      '/appointments',
      (server) => server.reply(200, []),
      queryParameters: {
        'scope': 'history',
        'limit': 20,
        'page': 2,
      },
    );

    final api = AppointmentsApi(dio);
    await api.fetchAppointments(scope: 'history', page: 2, limit: 20);
  });
}
