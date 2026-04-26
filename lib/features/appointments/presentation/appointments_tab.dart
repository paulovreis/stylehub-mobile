import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/appointment.dart';
import 'appointments_controller.dart';

class AppointmentsTab extends StatelessWidget {
  const AppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              title: const Text('Agendamentos'),
              bottom: TabBar(
                tabs: [
                  Tab(text: l10n.appointmentsUpcoming),
                  Tab(text: l10n.appointmentsHistory),
                ],
              ),
            ),
          ];
        },
        body: const TabBarView(
          children: [
            _AppointmentsList(scope: AppointmentsScope.upcoming),
            _AppointmentsList(scope: AppointmentsScope.history),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsList extends ConsumerWidget {
  const _AppointmentsList({required this.scope});

  final AppointmentsScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(appointmentsControllerProvider(scope));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorView(
        message: _messageForError(err),
        onRetry: () =>
            ref.read(appointmentsControllerProvider(scope).notifier).refresh(),
      ),
      data: (data) {
        if (data.items.isEmpty) {
          return _EmptyState(scope: scope);
        }
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(appointmentsControllerProvider(scope).notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: data.items.length + (data.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index >= data.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (data.hasMore && index == data.items.length - 1) {
                ref.read(appointmentsControllerProvider(scope).notifier).loadMore();
              }

              final a = data.items[index];
              return _AppointmentCard(
                appointment: a,
                canCancel: scope == AppointmentsScope.upcoming,
                scope: scope,
              );
            },
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.scope});

  final AppointmentsScope scope;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUpcoming = scope == AppointmentsScope.upcoming;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUpcoming
                  ? Icons.calendar_today_rounded
                  : Icons.history_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming
                  ? 'Nenhum agendamento próximo'
                  : 'Nenhum histórico ainda',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              isUpcoming
                  ? 'Seus próximos agendamentos aparecerão aqui.'
                  : 'Seus agendamentos concluídos aparecerão aqui.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends ConsumerWidget {
  const _AppointmentCard({
    required this.appointment,
    required this.canCancel,
    required this.scope,
  });

  final Appointment appointment;
  final bool canCancel;
  final AppointmentsScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final title = (appointment.serviceName?.trim().isNotEmpty ?? false)
        ? appointment.serviceName!.trim()
        : 'Serviço';

    final id = appointment.id;
    final cancelEnabled = canCancel && id != null && appointment.canCancel;
    final statusChip = _statusChip(context, appointment.statusEnum);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.spa_rounded,
                    size: 18,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      _MetaRow(appointment: appointment),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                statusChip,
              ],
            ),
            if (cancelEnabled) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _confirmCancel(context, ref, appointmentId: id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error.withAlpha(80)),
                    minimumSize: const Size(0, 36),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  child: const Text('Cancelar agendamento'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context, AppointmentStatus status) {
    final theme = Theme.of(context);

    final (label, bg, fg) = switch (status) {
      AppointmentStatus.scheduled => (
          'Agendado',
          theme.colorScheme.secondaryContainer,
          theme.colorScheme.onSecondaryContainer,
        ),
      AppointmentStatus.confirmed => (
          'Confirmado',
          theme.colorScheme.primaryContainer,
          theme.colorScheme.onPrimaryContainer,
        ),
      AppointmentStatus.completed => (
          'Concluído',
          theme.colorScheme.tertiaryContainer,
          theme.colorScheme.onTertiaryContainer,
        ),
      AppointmentStatus.canceled => (
          'Cancelado',
          theme.colorScheme.errorContainer,
          theme.colorScheme.onErrorContainer,
        ),
      AppointmentStatus.unknown => (
          'Status',
          theme.colorScheme.surfaceContainerHighest,
          theme.colorScheme.onSurface,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: fg),
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref, {
    required int appointmentId,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar agendamento?'),
        content: const Text('Você pode agendar outro horário depois.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Voltar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await ref
          .read(appointmentsControllerProvider(scope).notifier)
          .cancelAppointment(appointmentId);

      await ref.read(appointmentsControllerProvider(scope).notifier).refresh();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento cancelado.')),
      );
    } catch (e) {
      final message = _messageForError(e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = <_MetaPart>[];

    final date = AppFormatters.formatDateFlexible(appointment.appointmentDate);
    final time = AppFormatters.formatTimeFlexible(appointment.appointmentTime);
    if (date.isNotEmpty) parts.add(_MetaPart(Icons.calendar_today_rounded, date));
    if (time.isNotEmpty) parts.add(_MetaPart(Icons.schedule_rounded, time));

    final employee = appointment.employeeName?.trim();
    if (employee != null && employee.isNotEmpty) {
      parts.add(_MetaPart(Icons.person_outline_rounded, employee));
    }

    if (parts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      runSpacing: 4,
      children: parts.map((p) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(p.icon, size: 12, color: theme.colorScheme.onSurfaceVariant,),
            const SizedBox(width: 3),
            Text(
              p.text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _MetaPart {
  const _MetaPart(this.icon, this.text);
  final IconData icon;
  final String text;
}

String _messageForError(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar os agendamentos.';
}
