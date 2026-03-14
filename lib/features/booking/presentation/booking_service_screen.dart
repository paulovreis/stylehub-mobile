import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_failure.dart';
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
                        SizedBox(height: 120),
                        Center(child: Text('Nenhum serviço encontrado.')),
                      ],
                    );
                  }

                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final s = filtered[i];
                      final duration = s.durationMinutes;
                      final subtitle = duration == null ? null : '$duration min';
                      return ListTile(
                        title: Text(s.name ?? 'Serviço'),
                        subtitle: subtitle == null ? null : Text(subtitle),
                        trailing: const Icon(Icons.chevron_right),
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
