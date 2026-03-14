import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/debouncer.dart';
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
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar serviço',
                border: OutlineInputBorder(),
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
                        const SizedBox(height: 120),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 32,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Nenhum serviço encontrado.',
                                  style: theme.textTheme.titleSmall,
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
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final s = filtered[i];

                      final name = (s.name ?? 'Serviço').trim();
                      final duration = s.durationMinutes;
                      final price = s.recommendedPrice;

                      final metaParts = <String>[];
                      if (duration != null && duration > 0) metaParts.add('$duration min');
                      if (price != null) metaParts.add(AppFormatters.formatCurrencyBR(price));
                      final meta = metaParts.isEmpty ? null : metaParts.join(' • ');

                      return Card(
                        color: theme.colorScheme.surfaceContainerLowest,
                        child: InkWell(
                          onTap: () {
                            ref.read(bookingFlowProvider.notifier).selectService(s);
                            context.push('/book/employee');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: theme.textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (meta != null) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          meta,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
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

List<Service> _filterServices(List<Service> items, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return items;
  return items
      .where((s) => (s.name ?? '').toLowerCase().contains(q))
      .toList();
}

String _messageForError(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar os serviços.';
}
