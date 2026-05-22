import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/pix_payment.dart';
import '../pix_payment_controller.dart';
import 'payment_success_dialog.dart';

Future<void> showPixPaymentBottomSheet(
  BuildContext context, {
  required int appointmentId,
  required PixPayment initialPix,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => UncontrolledProviderScope(
      container: ProviderScope.containerOf(context),
      child: _PixPaymentSheet(
        appointmentId: appointmentId,
        initialPix: initialPix,
      ),
    ),
  );
}

class _PixPaymentSheet extends ConsumerStatefulWidget {
  const _PixPaymentSheet({
    required this.appointmentId,
    required this.initialPix,
  });

  final int appointmentId;
  final PixPayment initialPix;

  @override
  ConsumerState<_PixPaymentSheet> createState() => _PixPaymentSheetState();
}

class _PixPaymentSheetState extends ConsumerState<_PixPaymentSheet> {
  bool _successShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctrl = ref.read(pixControllerProvider(widget.appointmentId).notifier);
      // Seed the controller with the pix we already have so UI is immediate.
      // Only do this if the controller doesn't have fresher data yet.
      if (ref.read(pixControllerProvider(widget.appointmentId)).pix == null) {
        ctrl.seedPix(widget.initialPix);
      }
      ctrl.startPolling(onPaid: _onPaid);
    });
  }

  void _onPaid() {
    if (!mounted || _successShown) return;
    _successShown = true;
    Navigator.of(context).pop(); // close sheet
    showPaymentSuccessDialog(context);
  }

  @override
  void dispose() {
    ref.read(pixControllerProvider(widget.appointmentId).notifier).stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pixState = ref.watch(pixControllerProvider(widget.appointmentId));
    // Use controller state if available; fall back to the initial pix passed in.
    final pix = pixState.pix ?? widget.initialPix;

    // If FCM arrived and marked paid while modal is open.
    if (pix.paymentStatus == PaymentStatus.paid && !_successShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onPaid());
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                children: [
                  _Header(pix: pix),
                  const SizedBox(height: 24),
                  _QrCodeSection(pix: pix),
                  const SizedBox(height: 20),
                  _CopySection(pix: pix),
                  const SizedBox(height: 16),
                  _Actions(pix: pix),
                  const SizedBox(height: 20),
                  _InfoFooter(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.pix});
  final PixPayment pix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amountText = pix.amount != null
        ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(pix.amount)
        : '';

    String validityText = '';
    if (pix.expiresAt != null) {
      final local = pix.expiresAt!.toLocal();
      final df = DateFormat("dd/MM/yyyy 'às' HH:mm");
      validityText = 'Válido até: ${df.format(local)}';
      if (pix.isExpired) validityText = 'PIX expirado';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Pagamento via PIX', style: theme.textTheme.titleLarge),
        if (amountText.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            amountText,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
        if (validityText.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            validityText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: pix.isExpired
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _QrCodeSection extends StatelessWidget {
  const _QrCodeSection({required this.pix});
  final PixPayment pix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b64 = pix.qrCodeBase64;

    if (pix.isExpired) {
      return Container(
        width: 220,
        height: 220,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_off_rounded,
              size: 48,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(height: 8),
            Text(
              'PIX expirado',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onErrorContainer),
            ),
          ],
        ),
      );
    }

    if (b64 == null || b64.isEmpty) {
      return Container(
        width: 220,
        height: 220,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const CircularProgressIndicator(),
      );
    }

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          base64Decode(b64),
          width: 220,
          height: 220,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            width: 220,
            height: 220,
            alignment: Alignment.center,
            color: theme.colorScheme.surfaceContainerHighest,
            child: Text(
              'QR Code indisponível',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _CopySection extends StatelessWidget {
  const _CopySection({required this.pix});
  final PixPayment pix;

  @override
  Widget build(BuildContext context) {
    final code = pix.qrCode;
    if (code == null || code.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final truncated = code.length > 40 ? '${code.substring(0, 40)}…' : code;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              truncated,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => _copy(context, code),
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('Copiar'),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copy(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código PIX copiado!')),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.pix});
  final PixPayment pix;

  @override
  Widget build(BuildContext context) {
    final url = pix.ticketUrl;
    if (url == null || url.isEmpty || pix.isExpired) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _openUrl(context, url),
        icon: const Icon(Icons.open_in_new_rounded),
        label: const Text('Pagar pelo Mercado Pago'),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }
}

class _InfoFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Após o pagamento, você receberá uma notificação de confirmação.',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      textAlign: TextAlign.center,
    );
  }
}
