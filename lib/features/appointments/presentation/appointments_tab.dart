import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/app_failure.dart';
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
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: data.items.length + (data.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 1),
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
    final title = (appointment.serviceName?.trim().isNotEmpty ?? false)
        ? appointment.serviceName!.trim()
        : 'Serviço';

    final subtitle = _subtitleFor(appointment);

    final id = appointment.id;
    final cancelEnabled = canCancel && id != null;

    return ListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: cancelEnabled
          ? TextButton(
              onPressed: () => _confirmCancel(context, ref, appointmentId: id),
              child: const Text('Cancelar'),
            )
          : null,
    );
  }

  String? _subtitleFor(Appointment a) {
    final parts = <String>[];

    final date = a.appointmentDate?.trim();
    final time = a.appointmentTime?.trim();
    if (date != null && date.isNotEmpty) parts.add(date);
    if (time != null && time.isNotEmpty) parts.add(time);

    final employee = a.employeeName?.trim();
    if (employee != null && employee.isNotEmpty) parts.add(employee);

    if (parts.isEmpty) return null;
    return parts.join(' • ');
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
