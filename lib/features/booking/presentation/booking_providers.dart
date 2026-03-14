import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client_provider.dart';
import '../../../core/network/error_mapper.dart';
import '../../catalog/domain/employee.dart';
import '../data/booking_api.dart';
import '../domain/time_slot.dart';
import 'booking_flow_controller.dart';

final bookingApiProvider = Provider<BookingApi>((ref) {
  final dio = ref.watch(dioProvider);
  return BookingApi(dio);
});

final availableSlotsProvider = FutureProvider<List<TimeSlot>>((ref) async {
  final draft = ref.watch(bookingFlowProvider);
  final employeeId = draft.employee?.id;
  final date = draft.dateYmd;

  if (employeeId == null || date == null) return <TimeSlot>[];

  try {
    final raw = await ref.read(bookingApiProvider).fetchAvailableSlots(
          employeeId: employeeId,
          dateYmd: date,
          serviceId: draft.service?.id,
        );

    final slots = raw.map(TimeSlot.parse).toList();
    return slots.where((s) => (s.isAvailable ?? true) && (s.startTime?.isNotEmpty ?? false)).toList();
  } catch (e) {
    final failure = mapDioError(e);
    throw failure;
  }
});

String employeeTitle(Employee? employee) {
  final name = employee?.name?.trim();
  return (name == null || name.isEmpty) ? 'Profissional' : name;
}
