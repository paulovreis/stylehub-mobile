import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanSalonQrScreen extends StatefulWidget {
  const ScanSalonQrScreen({super.key});

  @override
  State<ScanSalonQrScreen> createState() => _ScanSalonQrScreenState();
}

class _ScanSalonQrScreenState extends State<ScanSalonQrScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ler QR Code'),
      ),
      body: MobileScanner(
        controller: _controller,
        errorBuilder: (context, error, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Não foi possível acessar a câmera.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            ),
          );
        },
        onDetect: (capture) {
          if (_handled) return;

          final barcodes = capture.barcodes;
          final raw = barcodes.isNotEmpty ? barcodes.first.rawValue : null;
          if (raw == null || raw.trim().isEmpty) return;

          _handled = true;
          context.pop(raw);
        },
      ),
    );
  }
}
