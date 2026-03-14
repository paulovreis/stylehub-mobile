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
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(appointmentsControllerProvider(scope).notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
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
              return _AppointmentTile(
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

class _AppointmentTile extends ConsumerWidget {
  const _AppointmentTile({
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

    final subtitle = _subtitleFor(appointment);

    final id = appointment.id;
    final cancelEnabled = canCancel && id != null && appointment.canCancel;
    final statusChip = _statusChip(context, appointment.statusEnum);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Card(
        color: theme.colorScheme.surfaceContainerLowest,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        statusChip,
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              if (cancelEnabled) ...[
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => _confirmCancel(context, ref, appointmentId: id),
                  child: const Text('Cancelar'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _subtitleFor(Appointment a) {
    final parts = <String>[];

    final date = AppFormatters.formatDateFlexible(a.appointmentDate);
    final time = AppFormatters.formatTimeFlexible(a.appointmentTime);
    if (date.isNotEmpty) parts.add(date);
    if (time.isNotEmpty) parts.add(time);

    final employee = a.employeeName?.trim();
    if (employee != null && employee.isNotEmpty) parts.add(employee);

    if (parts.isEmpty) return null;
    return parts.join(' • ');
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

      // O controller invalida ambas as abas; aqui só aguardamos refresh local.
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

String _messageForError(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar os agendamentos.';
}
