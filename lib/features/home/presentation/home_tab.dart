import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/utils/formatters.dart';
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
          SliverAppBar(
            pinned: true,
            title: const Text('Início'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                tooltip: 'Novo agendamento',
                onPressed: () => context.push('/book/service'),
              ),
            ],
          ),
          ...dashboard.when(
            data: (data) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _NextAppointmentCard(data: data),
                      const SizedBox(height: 20),
                      Text(
                        'Ações rápidas',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _ShortcutsRow(),
                    ],
                  ),
                ),
              ),
            ],
            loading: () => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LoadingAppointmentCard(),
                      const SizedBox(height: 20),
                      Text(
                        'Ações rápidas',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _ShortcutsRow(),
                    ],
                  ),
                ),
              ),
            ],
            error: (err, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: AppErrorView(
                  message: _errorMessage(err),
                  onRetry: () =>
                      ref.read(dashboardControllerProvider.notifier).refresh(),
                ),
              ),
            ],
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(30),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Próximo agendamento',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (next == null) ...[
              Text(
                'Nenhum agendamento\npróximo.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () => context.push('/book/service'),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Agendar agora'),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size(0, 42),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ] else ...[
              Text(
                _formatDateTime(next),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDetail(next),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withAlpha(180),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () => context.go('/appointments'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  side: BorderSide(
                    color: theme.colorScheme.onPrimaryContainer.withAlpha(80),
                  ),
                  minimumSize: const Size(0, 42),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                child: const Text('Ver agendamentos'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DashboardNextAppointment next) {
    final date = AppFormatters.formatDateFlexible(next.appointmentDate);
    final time = AppFormatters.formatTimeFlexible(next.appointmentTime);
    final parts = [if (date.isNotEmpty) date, if (time.isNotEmpty) time];
    return parts.isEmpty ? 'Agendamento confirmado' : parts.join(' • ');
  }

  String _formatDetail(DashboardNextAppointment next) {
    final parts = <String>[
      if (next.serviceName?.trim().isNotEmpty ?? false) next.serviceName!.trim(),
      if (next.employeeName?.trim().isNotEmpty ?? false) next.employeeName!.trim(),
    ];
    return parts.join(' • ');
  }
}

class _LoadingAppointmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primaryContainer,
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(30),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Próximo agendamento',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(4),
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primary.withAlpha(30),
          ),
        ],
      ),
    );
  }
}

class _ShortcutsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShortcutCard(
          icon: Icons.add_circle_rounded,
          label: 'Agendar',
          onTap: () => context.push('/book/service'),
        ),
        const SizedBox(width: 10),
        _ShortcutCard(
          icon: Icons.notifications_rounded,
          label: 'Notificações',
          onTap: () => context.go('/notifications'),
        ),
        const SizedBox(width: 10),
        _ShortcutCard(
          icon: Icons.person_rounded,
          label: 'Perfil',
          onTap: () => context.go('/profile'),
        ),
      ],
    );
  }
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
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar o dashboard.';
}
