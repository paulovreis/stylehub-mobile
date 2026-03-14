import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client_provider.dart';
import '../../../core/network/error_mapper.dart';
import '../data/appointments_api.dart';
import '../domain/appointment.dart';

final appointmentsApiProvider = Provider<AppointmentsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AppointmentsApi(dio);
});

enum AppointmentsScope {
  upcoming,
  history,
}

String _scopeParam(AppointmentsScope scope) {
  switch (scope) {
    case AppointmentsScope.upcoming:
      return 'upcoming';
    case AppointmentsScope.history:
      return 'history';
  }
}

class AppointmentsListState {
  const AppointmentsListState({
    required this.items,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
    this.loadMoreError,
  });

  final List<Appointment> items;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  AppointmentsListState copyWith({
    List<Appointment>? items,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return AppointmentsListState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
    );
  }
}

final appointmentsControllerProvider = AsyncNotifierProviderFamily<
    AppointmentsController,
    AppointmentsListState,
    AppointmentsScope>(
  AppointmentsController.new,
);

class AppointmentsController
    extends FamilyAsyncNotifier<AppointmentsListState, AppointmentsScope> {
  static const int _defaultLimit = 20;

  @override
  Future<AppointmentsListState> build(AppointmentsScope arg) async {
    final page = await _fetchPage(scope: arg, page: 1);
    return AppointmentsListState(
      items: page.items,
      page: 1,
      hasMore: page.hasMore,
      isLoadingMore: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final page = await _fetchPage(scope: arg, page: 1);
      return AppointmentsListState(
        items: page.items,
        page: 1,
        hasMore: page.hasMore,
        isLoadingMore: false,
      );
    });
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(
      current.copyWith(
        isLoadingMore: true,
        clearLoadMoreError: true,
      ),
    );

    try {
      final nextPageNumber = current.page + 1;
      final page = await _fetchPage(scope: arg, page: nextPageNumber);
      final merged = [...current.items, ...page.items];

      state = AsyncData(
        current.copyWith(
          items: merged,
          page: nextPageNumber,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      final failure = mapDioError(e);
      state = AsyncData(
        current.copyWith(
          isLoadingMore: false,
          hasMore: false,
          loadMoreError: failure.message,
        ),
      );
    }
  }

  Future<void> cancelAppointment(int id) async {
    try {
      await ref
          .read(appointmentsApiProvider)
          .cancelAppointment(appointmentId: id);
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }

  Future<_AppointmentsPage> _fetchPage({
    required AppointmentsScope scope,
    required int page,
  }) async {
    try {
      final raw = await ref.read(appointmentsApiProvider).fetchAppointments(
            scope: _scopeParam(scope),
            page: page,
            limit: _defaultLimit,
          );
      return _AppointmentsPage.parse(raw);
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }
}

class _AppointmentsPage {
  const _AppointmentsPage({
    required this.items,
    required this.hasMore,
  });

  final List<Appointment> items;
  final bool hasMore;

  factory _AppointmentsPage.parse(Object? raw) {
    if (raw is List) {
      final items = raw
          .whereType<Map>()
          .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
          .map(Appointment.parse)
          .toList();
      return _AppointmentsPage(items: items, hasMore: false);
    }

    if (raw is Map) {
      final map = raw.map((k, v) => MapEntry(k.toString(), v));
      final listRaw = map['data'] ?? map['items'] ?? map['appointments'];
      final list = listRaw is List ? listRaw : const [];

      final items = list
          .whereType<Map>()
          .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
          .map(Appointment.parse)
          .toList();

      final hasMore = _hasMoreFrom(map);
      return _AppointmentsPage(items: items, hasMore: hasMore);
    }

    return const _AppointmentsPage(items: [], hasMore: false);
  }
}

bool _hasMoreFrom(Map<String, dynamic> map) {
  final v = map['has_more'] ??
      map['hasMore'] ??
      map['hasNext'] ??
      map['has_next'];
  if (v is bool) return v;
  if (v is num) return v != 0;

  final next = map['next_page'] ??
      map['nextPage'] ??
      map['next_page_url'] ??
      map['next'];
  if (next is int) return next > 0;
  if (next is String) return next.trim().isNotEmpty;

  final meta = map['meta'];
  if (meta is Map) {
    final m = meta.map((k, v) => MapEntry(k.toString(), v));
    final current = m['current_page'];
    final last = m['last_page'];
    if (current is num && last is num) return current.toInt() < last.toInt();
  }

  return false;
}
