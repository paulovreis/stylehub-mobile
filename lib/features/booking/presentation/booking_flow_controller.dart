import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/date_time_formatters.dart';
import '../../catalog/domain/employee.dart';
import '../../catalog/domain/service.dart';

part 'booking_flow_controller.freezed.dart';

@freezed
class BookingDraft with _$BookingDraft {
  const factory BookingDraft({
    Service? service,
    Employee? employee,
    String? dateYmd,
    String? timeHm,
    @Default('') String notes,
  }) = _BookingDraft;

  const BookingDraft._();

  bool get hasService => service?.id != null;
  bool get hasEmployee => employee?.id != null;
  bool get hasDateTime => dateYmd != null && timeHm != null;
}

final bookingFlowProvider =
    NotifierProvider<BookingFlowController, BookingDraft>(
  BookingFlowController.new,
);

class BookingFlowController extends Notifier<BookingDraft> {
  @override
  BookingDraft build() => const BookingDraft();

  void reset() => state = const BookingDraft();

  void selectService(Service service) {
    state = state.copyWith(service: service, employee: null, dateYmd: null, timeHm: null);
  }

  void selectEmployee(Employee employee) {
    state = state.copyWith(employee: employee, dateYmd: null, timeHm: null);
  }

  void setDate(DateTime date) {
    state = state.copyWith(dateYmd: formatDateYmd(date), timeHm: null);
  }

  void selectTime(String hm) {
    state = state.copyWith(timeHm: hm.trim());
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }
}
