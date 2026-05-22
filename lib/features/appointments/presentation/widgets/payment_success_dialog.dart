import 'package:flutter/material.dart';

Future<void> showPaymentSuccessDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _PaymentSuccessDialog(),
  );
}

class _PaymentSuccessDialog extends StatelessWidget {
  const _PaymentSuccessDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 48),
      title: const Text('Pagamento confirmado!'),
      content: const Text(
        'Seu pagamento PIX foi recebido. Seu agendamento está garantido.',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
          child: Text('Ótimo!', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}
