import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/widgets/app_error_view.dart';
import 'booking_flow_controller.dart';
import 'booking_providers.dart';

class BookingEmployeeScreen extends ConsumerWidget {
  const BookingEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingFlowProvider);
    final serviceName = draft.service?.name;
    final employeesAsync = ref.watch(bookingEmployeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          serviceName == null || serviceName.isEmpty
              ? 'Escolha um profissional'
              : serviceName,
        ),
        bottom: serviceName != null && serviceName.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(28),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selecione o profissional',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(bookingEmployeesProvider),
        child: employeesAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Nenhum profissional disponível para este serviço.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final e = items[i];
                final name = e.name ?? 'Profissional';
                final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

                return _EmployeeCard(
                  name: name,
                  initial: initial,
                  onTap: () {
                    ref.read(bookingFlowProvider.notifier).selectEmployee(e);
                    context.push('/book/date-time');
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => AppErrorView(
            message: _messageForEmployeesError(err),
            onRetry: () => ref.invalidate(bookingEmployeesProvider),
          ),
        ),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({
    required this.name,
    required this.initial,
    required this.onTap,
  });

  final String name;
  final String initial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  initial,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
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
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Profissional',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
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

String _messageForEmployeesError(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar os profissionais.';
}
