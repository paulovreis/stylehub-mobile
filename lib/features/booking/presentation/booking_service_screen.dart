import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../catalog/domain/service.dart';
import '../../catalog/presentation/catalog_providers.dart';
import 'booking_flow_controller.dart';

class BookingServiceScreen extends ConsumerStatefulWidget {
  const BookingServiceScreen({super.key});

  @override
  ConsumerState<BookingServiceScreen> createState() => _BookingServiceScreenState();
}

class _BookingServiceScreenState extends ConsumerState<BookingServiceScreen> {
  final _search = TextEditingController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 250));
  String _query = '';

  @override
  void dispose() {
    _debouncer.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final servicesAsync = ref.watch(servicesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Escolha um serviço')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Buscar serviço...',
              ),
              onChanged: (v) {
                _debouncer.run(() {
                  if (!mounted) return;
                  setState(() => _query = v);
                });
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(servicesControllerProvider.notifier).refresh(),
              child: servicesAsync.when(
                data: (items) {
                  final filtered = _filterServices(items, _query);
                  if (filtered.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Nenhum serviço encontrado',
                                  style: theme.textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tente buscar por outro nome.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final s = filtered[i];
                      return _ServiceCard(
                        service: s,
                        onTap: () {
                          ref.read(bookingFlowProvider.notifier).selectService(s);
                          context.push('/book/employee');
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => AppErrorView(
                  message: _messageForError(err),
                  onRetry: () => ref.read(servicesControllerProvider.notifier).refresh(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onTap});

  final Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final name = (service.name ?? 'Serviço').trim();
    final duration = service.durationMinutes;
    final price = service.recommendedPrice;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.spa_rounded,
                  size: 22,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (duration != null && duration > 0) ...[
                          Icon(Icons.schedule_rounded,
                              size: 13, color: theme.colorScheme.onSurfaceVariant,),
                          const SizedBox(width: 4),
                          Text(
                            '$duration min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (price != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '·',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ],
                        if (price != null)
                          Text(
                            AppFormatters.formatCurrencyBR(price),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Service> _filterServices(List<Service> items, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return items;
  return items.where((s) => (s.name ?? '').toLowerCase().contains(q)).toList();
}

String _messageForError(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar os serviços.';
}
