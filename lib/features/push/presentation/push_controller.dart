import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/storage_keys.dart';
import '../../../core/network/dio_client_provider.dart';
import '../../../core/push/firebase_initializer.dart';
import '../../../core/routing/root_navigator_key.dart';
import '../../../core/session/session_controller.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../../notifications/presentation/notifications_controller.dart';
import '../data/push_api.dart';

class PushState {
  const PushState({
    required this.firebaseAvailable,
    required this.lastToken,
  });

  final bool firebaseAvailable;
  final String? lastToken;

  PushState copyWith({
    bool? firebaseAvailable,
    String? lastToken,
    bool clearToken = false,
  }) {
    return PushState(
      firebaseAvailable: firebaseAvailable ?? this.firebaseAvailable,
      lastToken: clearToken ? null : (lastToken ?? this.lastToken),
    );
  }

  static const initial = PushState(firebaseAvailable: false, lastToken: null);
}

final pushApiProvider = Provider<PushApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PushApi(dio);
});

final pushControllerProvider = NotifierProvider<PushController, PushState>(
  PushController.new,
);

class PushController extends Notifier<PushState> {
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSub;
  bool _handlersReady = false;

  @override
  PushState build() {
    ref.onDispose(() {
      unawaited(_tokenRefreshSub?.cancel());
      _tokenRefreshSub = null;

      unawaited(_onMessageSub?.cancel());
      _onMessageSub = null;

      unawaited(_onMessageOpenedSub?.cancel());
      _onMessageOpenedSub = null;
    });
    return PushState.initial;
  }

  /// Chamado após login/register. Não solicita permissão de forma intrusiva;
  /// apenas tenta registrar token se disponível.
  Future<void> onLogin() async {
    final session = ref.read(sessionControllerProvider).value;
    if (session == null || !session.isAuthenticated) return;

    final ok = await ensureFirebaseInitialized();
    state = state.copyWith(firebaseAvailable: ok);
    if (!ok) return;

    await _setupMessageHandlers();

    _listenTokenRefresh();
    await _registerIfPossible();
  }

  /// Chamado em logout/troca de salão.
  Future<void> onLogout() async {
    await _unregisterStoredToken();
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;

    await _onMessageSub?.cancel();
    _onMessageSub = null;

    await _onMessageOpenedSub?.cancel();
    _onMessageOpenedSub = null;

    _handlersReady = false;
    state = state.copyWith(clearToken: true);
  }

  /// Contextual: usar quando o usuário abrir Notificações.
  Future<void> requestPermissionAndRegister() async {
    final session = ref.read(sessionControllerProvider).value;
    if (session == null || !session.isAuthenticated) return;

    final ok = await ensureFirebaseInitialized();
    state = state.copyWith(firebaseAvailable: ok);
    if (!ok) return;

    await _setupMessageHandlers();

    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {
      // Ignora; push é best-effort.
    }

    _listenTokenRefresh();
    await _registerIfPossible();
  }

  Future<void> _setupMessageHandlers() async {
    if (_handlersReady) return;
    _handlersReady = true;

    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (_) {
      // Ignora; pode falhar em web/desktop ou sem configuração.
    }

    _onMessageSub ??= FirebaseMessaging.onMessage.listen((message) {
      // Apenas atualiza dados locais/badge; não navega em foreground.
      ref.invalidate(notificationsControllerProvider);
      ref.invalidate(dashboardControllerProvider);
    });

    _onMessageOpenedSub ??=
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationOpen(message);
    });

    // Caso o app tenha sido aberto a partir de uma notificação.
    try {
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) {
        _handleNotificationOpen(initial);
      }
    } catch (_) {
      // Ignora.
    }
  }

  void _handleNotificationOpen(RemoteMessage message) {
    final session = ref.read(sessionControllerProvider).value;
    if (session == null || !session.isAuthenticated) return;

    // Atualiza badge e lista quando o usuário abre a partir do push.
    ref.invalidate(notificationsControllerProvider);
    ref.invalidate(dashboardControllerProvider);

    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;

    try {
      GoRouter.of(ctx).go('/notifications');
    } catch (_) {
      // Ignora; navegação é best-effort.
    }
  }

  void _listenTokenRefresh() {
    _tokenRefreshSub ??= FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) {
        unawaited(_register(token: token));
      },
    );
  }

  Future<void> _registerIfPossible() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.trim().isEmpty) return;
      await _register(token: token);
    } catch (_) {
      // Ignora; push é opcional.
    }
  }

  Future<void> _register({required String token}) async {
    final trimmed = token.trim();
    if (trimmed.isEmpty) return;

    final session = ref.read(sessionControllerProvider).value;
    if (session == null || !session.isAuthenticated) return;

    final prefs = await ref.read(prefsStorageProvider.future);
    final previous = prefs.getString(StorageKeys.pushFcmToken);
    if (previous == trimmed) {
      state = state.copyWith(lastToken: trimmed);
      return;
    }

    try {
      await ref.read(pushApiProvider).register(
            token: trimmed,
            platform: _platformName(),
          );
      await prefs.setString(StorageKeys.pushFcmToken, trimmed);
      state = state.copyWith(lastToken: trimmed);
    } catch (_) {
      // Não bloqueia o app.
    }
  }

  Future<void> _unregisterStoredToken() async {
    final prefs = await ref.read(prefsStorageProvider.future);
    final token = prefs.getString(StorageKeys.pushFcmToken);
    if (token == null || token.trim().isEmpty) return;

    try {
      await ref.read(pushApiProvider).unregister(token: token.trim());
    } catch (_) {
      // Mesmo se falhar, limpa localmente para não ficar preso.
    } finally {
      await prefs.remove(StorageKeys.pushFcmToken);
    }
  }
}

String _platformName() {
  if (Platform.isIOS) return 'ios';
  return 'android';
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background isolate não tem Riverpod. Apenas garante init.
  await ensureFirebaseInitialized();
}
