import 'package:dio/dio.dart';

import '../domain/pix_payment.dart';

class PixApi {
  PixApi(this._dio);

  final Dio _dio;

  Future<PixPayment> generatePix(int appointmentId) async {
    final res = await _dio.post<Object?>('/appointments/$appointmentId/pix');
    final data = res.data;
    if (data is! Map) throw StateError('Resposta inválida do servidor.');
    return PixPayment.fromJson(data.map((k, v) => MapEntry(k.toString(), v)));
  }

  Future<PixPayment> getLatestPix(int appointmentId) async {
    final res = await _dio.get<Object?>('/appointments/$appointmentId/pix/latest');
    final data = res.data;
    if (data is! Map) throw StateError('Resposta inválida do servidor.');
    return PixPayment.fromJson(data.map((k, v) => MapEntry(k.toString(), v)));
  }
}
