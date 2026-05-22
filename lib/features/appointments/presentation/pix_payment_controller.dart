import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client_provider.dart';
import '../../../core/network/error_mapper.dart';
import '../data/pix_api.dart';
import '../domain/pix_payment.dart';

final pixApiProvider = Provider<PixApi>((ref) {
  return PixApi(ref.watch(dioProvider));
});

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum PixActionStatus { idle, loading, error }

class PixState {
  const PixState({
    required this.actionStatus,
    this.pix,
    this.errorMessage,
  });

  final PixActionStatus actionStatus;
  final PixPayment? pix;
  final String? errorMessage;

  PixState copyWith({
    PixActionStatus? actionStatus,
    PixPayment? pix,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PixState(
      actionStatus: actionStatus ?? this.actionStatus,
      pix: pix ?? this.pix,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static const initial = PixState(actionStatus: PixActionStatus.idle);
}

// ---------------------------------------------------------------------------
// Provider family (keyed by appointmentId)
// ---------------------------------------------------------------------------

final pixControllerProvider =
    NotifierProviderFamily<PixController, PixState, int>(
  PixController.new,
);

class PixController extends FamilyNotifier<PixState, int> {
  Timer? _pollTimer;
  // Callback registered by the bottom sheet while it is open.
  void Function()? _onPaidCallback;

  @override
  PixState build(int arg) {
    ref.onDispose(_cleanup);
    return PixState.initial;
  }

  void _cleanup() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _onPaidCallback = null;
  }

  int get _appointmentId => arg;

  void seedPix(PixPayment pix) {
    state = state.copyWith(pix: pix);
  }

  Future<PixPayment?> generatePix() async {
    state = state.copyWith(actionStatus: PixActionStatus.loading, clearError: true);
    try {
      final pix = await ref.read(pixApiProvider).generatePix(_appointmentId);
      state = state.copyWith(actionStatus: PixActionStatus.idle, pix: pix);
      return pix;
    } catch (e) {
      final failure = mapDioError(e);
      state = state.copyWith(
        actionStatus: PixActionStatus.error,
        errorMessage: failure.message,
      );
      return null;
    }
  }

  Future<PixPayment?> fetchLatestPix() async {
    state = state.copyWith(actionStatus: PixActionStatus.loading, clearError: true);
    try {
      final pix = await ref.read(pixApiProvider).getLatestPix(_appointmentId);
      state = state.copyWith(actionStatus: PixActionStatus.idle, pix: pix);
      return pix;
    } catch (e) {
      final failure = mapDioError(e);
      state = state.copyWith(
        actionStatus: PixActionStatus.error,
        errorMessage: failure.message,
      );
      return null;
    }
  }

  // Called when the modal opens. Stores the callback and starts polling every 5s.
  void startPolling({required void Function() onPaid}) {
    _onPaidCallback = onPaid;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final pix = await ref.read(pixApiProvider).getLatestPix(_appointmentId);
        state = state.copyWith(pix: pix);
        if (pix.paymentStatus == PaymentStatus.paid) {
          _fireOnPaid();
        }
      } catch (_) {
        // Polling failures are silent.
      }
    });
  }

  // Called when the modal closes so polling stops and the callback is cleared.
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _onPaidCallback = null;
  }

  // Called by the FCM foreground handler when payment_confirmed arrives.
  // Works whether the modal (and its polling) is open or not.
  void markPaid() {
    _pollTimer?.cancel();
    _pollTimer = null;

    final current = state.pix;
    state = state.copyWith(
      pix: current != null
          ? PixPayment(
              paymentStatus: PaymentStatus.paid,
              mpPaymentId: current.mpPaymentId,
              mpStatus: current.mpStatus,
              expiresAt: current.expiresAt,
              qrCode: current.qrCode,
              qrCodeBase64: current.qrCodeBase64,
              ticketUrl: current.ticketUrl,
              amount: current.amount,
            )
          : const PixPayment(paymentStatus: PaymentStatus.paid),
    );

    // If the modal is open, fire its callback to close + show success dialog.
    _fireOnPaid();
  }

  void _fireOnPaid() {
    final cb = _onPaidCallback;
    _onPaidCallback = null;
    cb?.call();
  }
}
