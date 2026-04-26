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
      appBar: AppBar(title: const Text('Data e horário')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BookingInfoBar(
            draft: draft,
            onPickDate: () => _pickDate(context, ref),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(availableSlotsProvider),
              child: draft.dateYmd == null
                  ? _EmptyDateState(onPickDate: () => _pickDate(context, ref))
                  : slotsAsync.when(
                      data: (slots) {
                        if (slots.isEmpty) {
                          return _EmptySlotsState(
                            onPickOther: () => _pickDate(context, ref),
                          );
                        }
                        return _TimeSlotGrid(
                          slots: slots.map((s) => s.startTime ?? '').toList(),
                          onSelected: (hm) {
                            ref
                                .read(bookingFlowProvider.notifier)
                                .selectTime(hm);
                            context.push('/book/confirm');
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
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

class _BookingInfoBar extends StatelessWidget {
  const _BookingInfoBar({required this.draft, required this.onPickDate});

  final BookingDraft draft;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draft.service?.name ?? 'Serviço',
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  employeeTitle(draft.employee),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonalIcon(
            onPressed: onPickDate,
            icon: const Icon(Icons.event_rounded, size: 16),
            label: Text(
              draft.dateYmd ?? 'Escolher data',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDateState extends StatelessWidget {
  const _EmptyDateState({required this.onPickDate});

  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      children: [
        const SizedBox(height: 60),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Escolha uma data',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecione uma data para ver os horários disponíveis.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onPickDate,
                  icon: const Icon(Icons.event_rounded),
                  label: const Text('Selecionar data'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptySlotsState extends StatelessWidget {
  const _EmptySlotsState({required this.onPickOther});

  final VoidCallback onPickOther;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      children: [
        const SizedBox(height: 60),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Sem horários disponíveis',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Não há horários disponíveis neste dia. Tente outra data.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: onPickOther,
                  icon: const Icon(Icons.calendar_today_rounded),
                  label: const Text('Escolher outra data'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeSlotGrid extends StatelessWidget {
  const _TimeSlotGrid({required this.slots, required this.onSelected});

  final List<String> slots;
  final void Function(String hm) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${slots.length} horário${slots.length == 1 ? '' : 's'} disponível${slots.length == 1 ? '' : 'is'}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: slots.map((hm) {
              if (hm.isEmpty) return const SizedBox.shrink();
              return _TimeChip(time: hm, onTap: () => onSelected(hm));
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.time, required this.onTap});

  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 15,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              time,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
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
