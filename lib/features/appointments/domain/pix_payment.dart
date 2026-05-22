enum PaymentStatus { unpaid, pending, paid, failed, expired }

extension PaymentStatusParsing on String {
  PaymentStatus toPaymentStatus() {
    switch (trim().toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'pending':
        return PaymentStatus.pending;
      case 'failed':
        return PaymentStatus.failed;
      case 'expired':
        return PaymentStatus.expired;
      default:
        return PaymentStatus.unpaid;
    }
  }
}

class PixPayment {
  const PixPayment({
    required this.paymentStatus,
    this.mpPaymentId,
    this.mpStatus,
    this.expiresAt,
    this.qrCode,
    this.qrCodeBase64,
    this.ticketUrl,
    this.amount,
  });

  final PaymentStatus paymentStatus;
  final String? mpPaymentId;
  final String? mpStatus;
  final DateTime? expiresAt;
  final String? qrCode;
  final String? qrCodeBase64;
  final String? ticketUrl;
  final double? amount;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  factory PixPayment.fromJson(Map<String, dynamic> json) {
    // Supports both generate-pix response (nested pix key) and getLatestPix response (flat)
    final pixMap = json['pix'] is Map
        ? (json['pix'] as Map).map((k, v) => MapEntry(k.toString(), v))
        : json;

    final statusRaw = (json['payment_status'] ?? json['paymentStatus'] ?? '').toString();
    final paymentStatus = statusRaw.toPaymentStatus();

    final mpPaymentId = _str(pixMap['mp_payment_id'] ?? pixMap['mpPaymentId']);
    final mpStatus = _str(pixMap['mp_status'] ?? pixMap['mpStatus']);
    final qrCode = _str(pixMap['qr_code'] ?? pixMap['qrCode']);
    final qrCodeBase64 = _str(pixMap['qr_code_base64'] ?? pixMap['qrCodeBase64']);
    final ticketUrl = _str(pixMap['ticket_url'] ?? pixMap['ticketUrl']);

    final expiresAtRaw = pixMap['expires_at'] ?? pixMap['expiresAt'];
    final expiresAt = expiresAtRaw is String ? DateTime.tryParse(expiresAtRaw) : null;

    final amountRaw = json['amount'] ?? pixMap['amount'];
    final amount = amountRaw is num ? amountRaw.toDouble() : null;

    return PixPayment(
      paymentStatus: paymentStatus,
      mpPaymentId: mpPaymentId,
      mpStatus: mpStatus,
      expiresAt: expiresAt,
      qrCode: qrCode,
      qrCodeBase64: qrCodeBase64,
      ticketUrl: ticketUrl,
      amount: amount,
    );
  }
}

String? _str(Object? v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}
