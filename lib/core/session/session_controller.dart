import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/selected_salon.dart';
import '../config/storage_keys.dart';
import '../storage/hive_cache.dart';
import '../storage/prefs_storage.dart';
import '../storage/secure_token_storage.dart';
import '../utils/jwt_utils.dart';
import 'session_state.dart';

final prefsStorageProvider = FutureProvider<PrefsStorage>((ref) async {
  return PrefsStorage.create();
});

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage.create();
});

final hiveCacheProvider = Provider<HiveCache>((ref) => HiveCache());

final sessionControllerProvider =
    AsyncNotifierProvider<SessionController, SessionState>(SessionController.new);

class SessionController extends AsyncNotifier<SessionState> {
  @override
  Future<SessionState> build() async {
    await HiveCache.init();

    final prefs = await ref.watch(prefsStorageProvider.future);
    final secure = ref.watch(secureTokenStorageProvider);

    SelectedSalon? salon;
    final salonRaw = prefs.getJsonMap(StorageKeys.selectedSalonMetaJson);
    final baseUrl = prefs.getString(StorageKeys.selectedSalonBaseUrl);
    if (baseUrl != null && baseUrl.trim().isNotEmpty) {
      if (salonRaw != null) {
        salon = SelectedSalon.fromJson(<String, Object?>{
          'baseUrl': baseUrl,
          'meta': salonRaw,
        });
      } else {
        salon = SelectedSalon(baseUrl: baseUrl);
      }
    }

    final token = await secure.read(StorageKeys.authAccessToken);

    String? validToken = token;
    if (validToken != null && validToken.trim().isNotEmpty) {
      if (JwtUtils.isExpired(validToken)) {
        await secure.delete(StorageKeys.authAccessToken);
        validToken = null;
      }
    }

    return SessionState(selectedSalon: salon, accessToken: validToken);
  }

  Future<void> setSalon(SelectedSalon salon) async {
    final prefs = await ref.read(prefsStorageProvider.future);
    await prefs.setString(StorageKeys.selectedSalonBaseUrl, salon.baseUrl);
    if (salon.meta != null) {
      await prefs.setJsonMap(
        StorageKeys.selectedSalonMetaJson,
        salon.meta!.toJson(),
      );
    } else {
      await prefs.remove(StorageKeys.selectedSalonMetaJson);
    }

    state = AsyncData(
      (state.value ?? const SessionState(selectedSalon: null, accessToken: null))
        .copyWith(selectedSalon: salon),
    );
  }

  Future<void> clearSalon() async {
    final prefs = await ref.read(prefsStorageProvider.future);
    await prefs.remove(StorageKeys.selectedSalonBaseUrl);
    await prefs.remove(StorageKeys.selectedSalonMetaJson);

    state = AsyncData(
      (state.value ?? const SessionState(selectedSalon: null, accessToken: null))
        .copyWith(clearSalon: true),
    );
  }

  Future<void> setAccessToken(String token) async {
    final secure = ref.read(secureTokenStorageProvider);
    await secure.write(StorageKeys.authAccessToken, token);

    state = AsyncData(
      (state.value ?? const SessionState(selectedSalon: null, accessToken: null))
        .copyWith(accessToken: token),
    );
  }

  Future<void> clearAccessToken() async {
    final secure = ref.read(secureTokenStorageProvider);
    await secure.delete(StorageKeys.authAccessToken);

    state = AsyncData(
      (state.value ?? const SessionState(selectedSalon: null, accessToken: null))
        .copyWith(clearToken: true),
    );
  }

  Future<void> logoutAndReset() async {
    final prefs = await ref.read(prefsStorageProvider.future);
    final secure = ref.read(secureTokenStorageProvider);

    await prefs.remove(StorageKeys.selectedSalonBaseUrl);
    await prefs.remove(StorageKeys.selectedSalonMetaJson);
    await secure.delete(StorageKeys.authAccessToken);

    state = const AsyncData(SessionState(selectedSalon: null, accessToken: null));
  }

  /// Helper para armazenar JSON no cache Hive.
  Future<void> writeHiveJson(String key, Object value) async {
    final json = jsonEncode(value);
    final cache = ref.read(hiveCacheProvider);
    if (key == 'services') {
      await cache.writeServicesJson(json);
    } else if (key == 'employees') {
      await cache.writeEmployeesJson(json);
    } else if (key == 'meta') {
      await cache.writeMetaJson(json);
    }
  }
}
