import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/network/app_failure.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../dashboard/domain/dashboard_summary.dart';
import '../../dashboard/presentation/dashboard_controller.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dashboard = ref.watch(dashboardControllerProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('Início'),
          ),
          ...dashboard.when(
            data: (data) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _NextAppointmentCard(data: data),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _ShortcutCard(
                              icon: Icons.add_circle_outline,
                              label: 'Agendar',
                              onTap: () => context.push('/book/service'),
                            ),
                            _ShortcutCard(
                              icon: Icons.notifications_none,
                              label: 'Notificações',
                              onTap: () => context.go('/notifications'),
                            ),
                            _ShortcutCard(
                              icon: Icons.person_outline,
                              label: 'Perfil',
                              onTap: () => context.go('/profile'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            loading: () {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Próximo agendamento',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 12),
                                const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _ShortcutCard(
                              icon: Icons.add_circle_outline,
                              label: 'Agendar',
                              onTap: () => context.push('/book/service'),
                            ),
                            _ShortcutCard(
                              icon: Icons.notifications_none,
                              label: 'Notificações',
                              onTap: () => context.go('/notifications'),
                            ),
                            _ShortcutCard(
                              icon: Icons.person_outline,
                              label: 'Perfil',
                              onTap: () => context.go('/profile'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            error: (err, _) {
              return [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorView(
                    message: _errorMessage(err),
                    onRetry: () => ref.read(dashboardControllerProvider.notifier).refresh(),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class _NextAppointmentCard extends StatelessWidget {
  const _NextAppointmentCard({required this.data});

  final DashboardSummary data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = data.nextAppointment;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Próximo agendamento',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (next == null) ...[
              Text('Nenhum agendamento próximo.', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.push('/book/service'),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Agendar'),
              ),
            ] else ...[
              Text(
                _formatNextAppointment(next),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/appointments'),
                child: const Text('Ver agendamentos'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatNextAppointment(DashboardNextAppointment next) {
  final dateRaw = next.appointmentDate;
  final timeRaw = next.appointmentTime;
  final service = next.serviceName;
  final employee = next.employeeName;

  final parts = <String>[];
  final date = AppFormatters.formatDateFlexible(dateRaw);
  final time = AppFormatters.formatTimeFlexible(timeRaw);
  if (date.isNotEmpty) parts.add(date);
  if (time.isNotEmpty) parts.add(time);

  final title = parts.isEmpty ? 'Agendamento confirmado' : parts.join(' • ');

  final detail = <String>[];
  if (service != null && service.trim().isNotEmpty) detail.add(service.trim());
  if (employee != null && employee.trim().isNotEmpty) detail.add(employee.trim());

  if (detail.isEmpty) return title;
  return '$title\n${detail.join(' • ')}';
}

String _errorMessage(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar o dashboard.';
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        width: (MediaQuery.sizeOf(context).width - 16 * 2 - 12) / 2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: theme.textTheme.titleSmall),
            ),
          ],
        ),
      ),
    );
  }
}
