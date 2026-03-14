import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../../dashboard/presentation/dashboard_controller.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({
    super.key,
    required this.child,
  });

  final Widget child;

  int _indexForLocation(String location) {
    if (location.startsWith('/appointments')) return 1;
    if (location.startsWith('/notifications')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _goForIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        return;
      case 1:
        context.go('/appointments');
        return;
      case 2:
        context.go('/notifications');
        return;
      case 3:
        context.go('/profile');
        return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexForLocation(location);

    final unreadCount = ref.watch(
      dashboardControllerProvider.select(
        (av) => av.valueOrNull?.unreadNotificationsCount ?? 0,
      ),
    );

    final badgeLabel = unreadCount > 99 ? '99+' : unreadCount.toString();
    final notificationsIcon = unreadCount <= 0
        ? const Icon(Icons.notifications_none)
        : Badge(
            label: Text(badgeLabel),
            child: const Icon(Icons.notifications_none),
          );

    return AppScaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _goForIndex(context, i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          const NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Agendamentos',
          ),
          NavigationDestination(
            icon: notificationsIcon,
            label: 'Notificações',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
