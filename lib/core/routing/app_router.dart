import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/appointments/presentation/appointments_tab.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/booking/presentation/booking_confirm_screen.dart';
import '../../features/booking/presentation/booking_date_time_screen.dart';
import '../../features/booking/presentation/booking_employee_screen.dart';
import '../../features/booking/presentation/booking_service_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/home/presentation/home_tab.dart';
import '../../features/notifications/presentation/notifications_tab.dart';
import '../../features/profile/presentation/profile_tab.dart';
import '../../features/salon_selection/presentation/select_salon_screen.dart';
import '../session/session_controller.dart';
import '../widgets/app_error_view.dart';
import 'root_navigator_key.dart';
import 'router_notifier.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/select-salon',
    refreshListenable: notifier,
    redirect: (context, state) {
      final sessionAsync = ref.read(sessionControllerProvider);

      if (sessionAsync.isLoading || sessionAsync.hasError) {
        return null;
      }

      final session = sessionAsync.value;
      final hasSalon = session?.hasSalon ?? false;
      final isAuth = session?.isAuthenticated ?? false;

      final loc = state.matchedLocation;

      final isSelectingSalon = loc.startsWith('/select-salon');
      final isAuthRoute = loc.startsWith('/login') ||
          loc.startsWith('/register') ||
          loc.startsWith('/forgot-password') ||
          loc.startsWith('/reset-password');

      if (!hasSalon) {
        return isSelectingSalon ? null : '/select-salon';
      }

      if (!isAuth) {
        return isAuthRoute ? null : '/login';
      }

      if (isSelectingSalon || isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/select-salon',
        builder: (context, state) => const SelectSalonScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeTab(),
            ),
          ),
          GoRoute(
            path: '/appointments',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AppointmentsTab(),
            ),
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NotificationsTab(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileTab(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/book/service',
        builder: (context, state) => const BookingServiceScreen(),
      ),
      GoRoute(
        path: '/book/employee',
        builder: (context, state) => const BookingEmployeeScreen(),
      ),
      GoRoute(
        path: '/book/date-time',
        builder: (context, state) => const BookingDateTimeScreen(),
      ),
      GoRoute(
        path: '/book/confirm',
        builder: (context, state) => const BookingConfirmScreen(),
      ),
    ],
    errorBuilder: (context, state) => AppErrorView(
      message: state.error?.toString() ?? 'Erro de navegação.',
      onRetry: () => context.go('/home'),
    ),
  );
});
