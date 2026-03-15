import 'package:dio/dio.dart';

class BookingApi {
  BookingApi(this._dio);

  final Dio _dio;

  Future<List<Object?>> fetchAvailableSlots({
    required int employeeId,
    required String dateYmd,
    int? serviceId,
  }) async {
    final res = await _dio.get<Object?>(
      '/available-slots/$employeeId/$dateYmd',
      queryParameters: {
        if (serviceId != null) 'service_id': serviceId,
      },
    );

    final data = res.data;
    if (data is List) return data.whereType<Object?>().toList();

    // Alguns backends retornam { slots: [...] }
    if (data is Map) {
      final slots = data['slots'];
      if (slots is List) return slots.whereType<Object?>().toList();
    }

    return <Object?>[];
  }

  Future<Map<String, dynamic>> createAppointment({
    required int employeeId,
    required int serviceId,
    required String appointmentDateYmd,
    required String appointmentTimeHm,
    String? notes,
  }) async {
    final res = await _dio.post<Object?>(
      '/appointments',
      data: {
        'employee_id': employeeId,
        'service_id': serviceId,
        'appointment_date': appointmentDateYmd,
        'appointment_time': appointmentTimeHm,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      },
    );

    final data = res.data;
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    return <String, dynamic>{};
  }
}
