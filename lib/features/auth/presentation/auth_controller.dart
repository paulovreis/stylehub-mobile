import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client_provider.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/utils/validators.dart';
import '../../push/presentation/push_controller.dart';
import '../data/auth_api.dart';
import '../domain/auth_token_parser.dart';

class AuthUiState {
  const AuthUiState({
    required this.loading,
    required this.errorMessage,
  });

  final bool loading;
  final String? errorMessage;

  AuthUiState copyWith({
    bool? loading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthUiState(
      loading: loading ?? this.loading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static const initial = AuthUiState(loading: false, errorMessage: null);
}

final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApi(dio);
});

final authControllerProvider =
    NotifierProvider<AuthController, AuthUiState>(AuthController.new);

class AuthController extends Notifier<AuthUiState> {
  @override
  AuthUiState build() => AuthUiState.initial;

  Future<bool> login({required String email, required String password}) async {
    if (!Validators.isValidEmail(email)) {
      state = state.copyWith(errorMessage: 'E-mail inválido.');
      return false;
    }
    if (!Validators.isStrongEnoughPassword(password)) {
      state = state.copyWith(errorMessage: 'Senha muito curta.');
      return false;
    }

    state = state.copyWith(loading: true, clearError: true);

    try {
      final json = await ref.read(authApiProvider).login(
            email: email.trim(),
            password: password,
          );

      final token = extractAccessToken(json);
      if (token == null) {
        state = state.copyWith(
          loading: false,
          errorMessage: 'Resposta do servidor inválida (token ausente).',
        );
        return false;
      }

      await ref.read(sessionControllerProvider.notifier).setAccessToken(token);

      unawaited(ref.read(pushControllerProvider.notifier).onLogin());
      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      final failure = mapDioError(e);
      state = state.copyWith(loading: false, errorMessage: failure.message);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Informe seu nome.');
      return false;
    }
    if (!Validators.isValidEmail(email)) {
      state = state.copyWith(errorMessage: 'E-mail inválido.');
      return false;
    }
    if (phone.trim().isNotEmpty && !Validators.isValidPhoneBR(phone)) {
      state = state.copyWith(errorMessage: 'Telefone inválido.');
      return false;
    }
    if (!Validators.isStrongEnoughPassword(password)) {
      state = state.copyWith(errorMessage: 'Senha muito curta.');
      return false;
    }

    state = state.copyWith(loading: true, clearError: true);

    try {
      final json = await ref.read(authApiProvider).register(
            name: name.trim(),
            email: email.trim(),
            password: password,
            phone: phone,
          );

      final token = extractAccessToken(json);
      if (token != null) {
        await ref.read(sessionControllerProvider.notifier).setAccessToken(token);

        unawaited(ref.read(pushControllerProvider.notifier).onLogin());
      }

      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      final failure = mapDioError(e);
      state = state.copyWith(loading: false, errorMessage: failure.message);
      return false;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    if (!Validators.isValidEmail(email)) {
      state = state.copyWith(errorMessage: 'E-mail inválido.');
      return;
    }

    state = state.copyWith(loading: true, clearError: true);

    try {
      await ref.read(authApiProvider).forgotPassword(email: email.trim());
      state = state.copyWith(loading: false);
    } catch (e) {
      final failure = mapDioError(e);
      state = state.copyWith(loading: false, errorMessage: failure.message);
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (token.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Informe o token.');
      return false;
    }
    if (!Validators.isStrongEnoughPassword(newPassword)) {
      state = state.copyWith(errorMessage: 'Senha muito curta.');
      return false;
    }

    state = state.copyWith(loading: true, clearError: true);

    try {
      final ok = await ref.read(authApiProvider).validateResetToken(token: token.trim());
      if (!ok) {
        state = state.copyWith(loading: false, errorMessage: 'Token inválido.');
        return false;
      }

      await ref
          .read(authApiProvider)
          .resetPassword(token: token.trim(), newPassword: newPassword);
      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      final failure = mapDioError(e);
      state = state.copyWith(loading: false, errorMessage: failure.message);
      return false;
    }
  }
}
