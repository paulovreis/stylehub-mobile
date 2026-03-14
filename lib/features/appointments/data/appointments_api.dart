import 'package:dio/dio.dart';

class AppointmentsApi {
  AppointmentsApi(this._dio);

  final Dio _dio;

  Future<Object?> fetchAppointments({
    required String scope,
    int page = 1,
    int limit = 20,
  }) async {
    final res = await _dio.get<Object?>(
      '/appointments',
      queryParameters: {
        'scope': scope,
        'limit': limit,
        if (page > 1) 'page': page,
      },
    );
    return res.data;
  }

  Future<void> cancelAppointment({required int appointmentId}) async {
    await _dio.post<Object?>('/appointments/$appointmentId/cancel');
  }
}
