import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client_provider.dart';
import '../../../core/network/error_mapper.dart';
import '../data/profile_api.dart';
import '../domain/me_profile.dart';

final profileApiProvider = Provider<ProfileApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileApi(dio);
});

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, MeProfile>(ProfileController.new);

class ProfileController extends AsyncNotifier<MeProfile> {
  @override
  Future<MeProfile> build() async {
    return _fetch();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<bool> save({
    required String name,
    required String email,
    required String phone,
  }) async {
    final previous = state.valueOrNull;
    state = const AsyncLoading();

    try {
      final json = await ref.read(profileApiProvider).updateMe(
            name: name,
            email: email,
            phone: phone,
          );

      final parsed = MeProfile.parse(json);
      state = AsyncData(parsed);
      return true;
    } catch (e, st) {
      final failure = mapDioError(e);
      if (previous != null) {
        // Mantém dados antigos na tela, mas expõe o erro via AsyncError.
        state = AsyncError(failure, st);
        state = AsyncData(previous);
      } else {
        state = AsyncError(failure, st);
      }
      return false;
    }
  }

  Future<MeProfile> _fetch() async {
    try {
      final json = await ref.read(profileApiProvider).fetchMe();
      return MeProfile.parse(json);
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }
}
