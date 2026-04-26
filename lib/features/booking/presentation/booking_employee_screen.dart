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
              : 'Profissional • $serviceName',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(bookingEmployeesProvider),
        child: employeesAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Nenhum profissional disponível para este serviço.')),
                ],
              );
            }

            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final e = items[i];
                return ListTile(
                  title: Text(e.name ?? 'Profissional'),
                  trailing: const Icon(Icons.chevron_right),
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

String _messageForEmployeesError(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar os profissionais.';
}
