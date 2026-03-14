import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client_provider.dart';
import '../../../core/network/error_mapper.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../data/notifications_api.dart';
import '../domain/app_notification.dart';

final notificationsApiProvider = Provider<NotificationsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationsApi(dio);
});

class NotificationsListState {
  const NotificationsListState({
    required this.items,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
    this.loadMoreError,
  });

  final List<AppNotification> items;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  NotificationsListState copyWith({
    List<AppNotification>? items,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return NotificationsListState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
    );
  }
}

final notificationsControllerProvider =
    AsyncNotifierProvider<NotificationsController, NotificationsListState>(
  NotificationsController.new,
);

class NotificationsController extends AsyncNotifier<NotificationsListState> {
  static const _pageSize = 20;

  @override
  Future<NotificationsListState> build() async {
    final page = await _fetchPage(1);
    return NotificationsListState(
      items: page.items,
      page: 1,
      hasMore: page.hasMore,
      isLoadingMore: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final page = await _fetchPage(1);
      return NotificationsListState(
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
      final page = await _fetchPage(nextPageNumber);
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

  Future<void> markRead(int id) async {
    try {
      await ref.read(notificationsApiProvider).markRead(notificationId: id);
      ref.invalidate(dashboardControllerProvider);
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }

  Future<void> markAllRead() async {
    try {
      await ref.read(notificationsApiProvider).markAllRead();
      ref.invalidate(dashboardControllerProvider);
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }

  Future<_NotificationsPage> _fetchPage(int page) async {
    try {
      final raw = await ref
          .read(notificationsApiProvider)
          .fetchNotifications(page: page, limit: _pageSize);
      return _NotificationsPage.parse(raw);
    } catch (e) {
      final failure = mapDioError(e);
      throw failure;
    }
  }
}

class _NotificationsPage {
  const _NotificationsPage({
    required this.items,
    required this.hasMore,
  });

  final List<AppNotification> items;
  final bool hasMore;

  factory _NotificationsPage.parse(Object? raw) {
    if (raw is List) {
      final items = raw
          .whereType<Map>()
          .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
          .map(AppNotification.parse)
          .toList();
      return _NotificationsPage(items: items, hasMore: false);
    }

    if (raw is Map) {
      final map = raw.map((k, v) => MapEntry(k.toString(), v));
      final listRaw = map['data'] ?? map['items'] ?? map['notifications'];
      final list = listRaw is List ? listRaw : const [];

      final items = list
          .whereType<Map>()
          .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
          .map(AppNotification.parse)
          .toList();

      final hasMore = _hasMoreFrom(map);
      return _NotificationsPage(items: items, hasMore: hasMore);
    }

    return const _NotificationsPage(items: [], hasMore: false);
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
