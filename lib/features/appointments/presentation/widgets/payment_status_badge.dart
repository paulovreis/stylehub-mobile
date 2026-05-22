import 'package:flutter/material.dart';

import '../../domain/pix_payment.dart';

class PaymentStatusBadge extends StatelessWidget {
  const PaymentStatusBadge({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _style(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg),
      ),
    );
  }

  static (String, Color, Color) _style(BuildContext context, PaymentStatus s) {
    final cs = Theme.of(context).colorScheme;
    return switch (s) {
      PaymentStatus.paid => ('Pago', const Color(0xFF1B5E20), Colors.white),
      PaymentStatus.pending => ('PIX pendente', const Color(0xFFE65100), Colors.white),
      PaymentStatus.failed => ('Falhou', cs.errorContainer, cs.onErrorContainer),
      PaymentStatus.expired => ('Expirado', cs.errorContainer, cs.onErrorContainer),
      PaymentStatus.unpaid => ('Não pago', cs.surfaceContainerHighest, cs.onSurfaceVariant),
    };
  }
}
