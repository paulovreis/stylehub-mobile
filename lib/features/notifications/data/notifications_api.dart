import 'package:dio/dio.dart';

class NotificationsApi {
  NotificationsApi(this._dio);

  final Dio _dio;

  Future<Object?> fetchNotifications({int page = 1, int limit = 20}) async {
    final res = await _dio.get<Object?>(
      '/notifications',
      queryParameters: {
        'limit': limit,
        if (page > 1) 'page': page,
      },
    );
    return res.data;
  }

  Future<void> markRead({required int notificationId}) async {
    await _dio.post<Object?>('/notifications/$notificationId/read');
  }

  Future<void> markAllRead() async {
    await _dio.post<Object?>('/notifications/read-all');
  }
}
