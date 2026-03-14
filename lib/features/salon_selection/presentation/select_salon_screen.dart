import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/session/session_controller.dart';
import '../../../core/widgets/app_primary_button.dart';
import 'select_salon_controller.dart';

class SelectSalonScreen extends ConsumerStatefulWidget {
  const SelectSalonScreen({super.key});

  @override
  ConsumerState<SelectSalonScreen> createState() => _SelectSalonScreenState();
}

class _SelectSalonScreenState extends ConsumerState<SelectSalonScreen> {
  final _url = TextEditingController();
  final _slug = TextEditingController();

  @override
  void dispose() {
    _url.dispose();
    _slug.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(selectSalonControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Selecione seu salão')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cole a URL completa ou digite o código do salão.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'URL do salão',
                hintText: 'https://cliente1.helderporto.com',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _slug,
              decoration: const InputDecoration(
                labelText: 'Código do salão',
                hintText: 'cliente1',
              ),
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: 'Validar',
              loading: ui.isValidating,
              onPressed: () {
                ref
                    .read(selectSalonControllerProvider.notifier)
                    .validate(urlInput: _url.text, slugInput: _slug.text);
              },
            ),
            if (ui.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                ui.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (ui.validSalon?.meta != null) ...[
              const SizedBox(height: 16),
              _SalonMetaCard(
                name: ui.validSalon!.meta!.name,
                city: ui.validSalon!.meta!.city,
                logoUrl: ui.validSalon!.meta!.logoUrl,
              ),
            ],
            const SizedBox(height: 12),
            AppPrimaryButton(
              label: 'Continuar',
              onPressed: ui.isValid
                  ? () async {
                      await ref
                          .read(sessionControllerProvider.notifier)
                          .setSalon(ui.validSalon!);
                      if (!context.mounted) return;
                      context.go('/login');
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SalonMetaCard extends StatelessWidget {
  const _SalonMetaCard({
    required this.name,
    required this.city,
    required this.logoUrl,
  });

  final String? name;
  final String? city;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (logoUrl != null && logoUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  logoUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.storefront_outlined),
                  ),
                ),
              )
            else
              const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.storefront_outlined),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name ?? 'Salão', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(city ?? '', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
