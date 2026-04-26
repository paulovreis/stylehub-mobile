import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_primary_button.dart';
import 'booking_flow_controller.dart';
import 'booking_providers.dart';

class BookingConfirmScreen extends ConsumerStatefulWidget {
  const BookingConfirmScreen({super.key});

  @override
  ConsumerState<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  final _notes = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = ref.watch(bookingFlowProvider);
    final service = draft.service;
    final employee = draft.employee;

    final employeeId = employee?.id;
    final serviceId = service?.id;
    final date = draft.dateYmd;
    final time = draft.timeHm;

    if (employeeId == null || serviceId == null || date == null || time == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Confirmar agendamento')),
        body: AppErrorView(
          message: 'Selecione serviço, profissional e horário antes de confirmar.',
          onRetry: () => context.go('/book/service'),
        ),
      );
    }

    if (_notes.text != draft.notes) {
      _notes.text = draft.notes;
      _notes.selection = TextSelection.fromPosition(
        TextPosition(offset: _notes.text.length),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar agendamento')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryCard(
              serviceName: service?.name ?? 'Serviço',
              employeeName: employeeTitle(employee),
              date: date,
              time: time,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.notes_rounded),
                ),
                alignLabelWithHint: true,
              ),
              onChanged: (v) => ref.read(bookingFlowProvider.notifier).setNotes(v),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer, size: 18,),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            AppPrimaryButton(
              label: 'Confirmar agendamento',
              loading: _loading,
              onPressed: _loading
                  ? null
                  : () => _confirm(
                        context,
                        employeeId: employeeId,
                        serviceId: serviceId,
                        dateYmd: date,
                        timeHm: time,
                        notes: draft.notes,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context, {
    required int employeeId,
    required int serviceId,
    required String dateYmd,
    required String timeHm,
    required String notes,
  }) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(bookingApiProvider).createAppointment(
            employeeId: employeeId,
            serviceId: serviceId,
            appointmentDateYmd: dateYmd,
            appointmentTimeHm: timeHm,
            notes: notes,
          );

      ref.read(bookingFlowProvider.notifier).reset();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento criado com sucesso.')),
      );
      context.go('/appointments');
    } catch (e) {
      final failure = mapDioError(e);
      if (!context.mounted) return;

      if (failure.kind == AppFailureKind.conflict) {
        setState(() {
          _loading = false;
          _error = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Horário indisponível. Escolha outro horário.')),
        );
        context.pop();
        ref.invalidate(availableSlotsProvider);
        return;
      } else {
        setState(() {
          _error = failure.message;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.serviceName,
    required this.employeeName,
    required this.date,
    required this.time,
  });

  final String serviceName;
  final String employeeName;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
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
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Resumo do agendamento',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SummaryRow(
              icon: Icons.spa_rounded,
              label: 'Serviço',
              value: serviceName,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              icon: Icons.person_outline_rounded,
              label: 'Profissional',
              value: employeeName,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              icon: Icons.calendar_today_rounded,
              label: 'Data',
              value: date,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              icon: Icons.schedule_rounded,
              label: 'Horário',
              value: time,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
