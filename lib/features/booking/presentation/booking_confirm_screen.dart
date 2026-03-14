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
                      service?.name ?? 'Serviço',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(employee?.name ?? 'Profissional'),
                    const SizedBox(height: 4),
                    Text('$date • $time'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => ref.read(bookingFlowProvider.notifier).setNotes(v),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const Spacer(),
            AppPrimaryButton(
              label: 'Confirmar',
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
