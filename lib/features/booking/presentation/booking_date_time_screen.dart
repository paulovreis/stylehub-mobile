import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/widgets/app_error_view.dart';
import 'booking_flow_controller.dart';
import 'booking_providers.dart';

class BookingDateTimeScreen extends ConsumerWidget {
  const BookingDateTimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingFlowProvider);
    final employee = draft.employee;
    final service = draft.service;

    if (employee?.id == null || service?.id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Escolha data e horário')),
        body: AppErrorView(
          message: 'Selecione o serviço e o profissional primeiro.',
          onRetry: () => context.go('/book/service'),
        ),
      );
    }

    final slotsAsync = ref.watch(availableSlotsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Escolha data e horário')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${service?.name ?? 'Serviço'} • ${employeeTitle(employee)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonalIcon(
                  onPressed: () => _pickDate(context, ref),
                  icon: const Icon(Icons.event_outlined),
                  label: Text(draft.dateYmd ?? 'Data'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(availableSlotsProvider);
              },
              child: draft.dateYmd == null
                  ? ListView(
                      children: [
                        SizedBox(height: 120),
                        Center(child: Text('Escolha uma data para ver horários.')),
                      ],
                    )
                  : slotsAsync.when(
                      data: (slots) {
                        if (slots.isEmpty) {
                          return ListView(
                            children: [
                              SizedBox(height: 120),
                              Center(child: Text('Nenhum horário disponível neste dia.')),
                            ],
                          );
                        }

                        return ListView.separated(
                          itemCount: slots.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final slot = slots[i];
                            final hm = slot.startTime ?? '';
                            return ListTile(
                              title: Text(hm),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                ref.read(bookingFlowProvider.notifier).selectTime(hm);
                                context.push('/book/confirm');
                              },
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => AppErrorView(
                        message: _messageForSlotsError(err),
                        onRetry: () => ref.invalidate(availableSlotsProvider),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
  final now = DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(now.year, now.month, now.day),
    lastDate: now.add(const Duration(days: 180)),
  );
  if (picked == null) return;
  ref.read(bookingFlowProvider.notifier).setDate(picked);
  ref.invalidate(availableSlotsProvider);
}

String _messageForSlotsError(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar os horários disponíveis.';
}
