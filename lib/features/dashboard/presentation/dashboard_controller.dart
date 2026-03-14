import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client_provider.dart';
import '../../../core/network/error_mapper.dart';
import '../data/dashboard_api.dart';
import '../domain/dashboard_summary.dart';

final dashboardApiProvider = Provider<DashboardApi>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardApi(dio);
});

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, DashboardSummary>(
  DashboardController.new,
);

class DashboardController extends AsyncNotifier<DashboardSummary> {
  @override
  Future<DashboardSummary> build() async {
    return _fetch();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<DashboardSummary> _fetch() async {
    try {
      final json = await ref.read(dashboardApiProvider).fetchDashboard();
      return DashboardSummary.parse(json);
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }
}
