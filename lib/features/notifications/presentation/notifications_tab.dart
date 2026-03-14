import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../push/presentation/push_controller.dart';
import '../domain/app_notification.dart';
import 'notifications_controller.dart';

class NotificationsTab extends ConsumerStatefulWidget {
  const NotificationsTab({super.key});

  @override
  ConsumerState<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends ConsumerState<NotificationsTab> {
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requested) return;
    _requested = true;
    unawaited(ref.read(pushControllerProvider.notifier).requestPermissionAndRegister());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(notificationsControllerProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorView(
        message: _messageForError(err),
        onRetry: () => ref.read(notificationsControllerProvider.notifier).refresh(),
      ),
      data: (data) {
        return RefreshIndicator(
          onRefresh: () => ref.read(notificationsControllerProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(l10n.homeTabNotifications),
                actions: [
                  TextButton(
                    onPressed: data.items.isEmpty
                        ? null
                        : () => _markAllRead(context, ref),
                    child: Text(l10n.notificationsMarkAll),
                  ),
                ],
              ),
              if (data.items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: _NotificationsEmptyText()),
                )
              else
                SliverList.separated(
                  itemCount: data.items.length + (data.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= data.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (data.hasMore && index == data.items.length - 1) {
                      ref.read(notificationsControllerProvider.notifier).loadMore();
                    }

                    final n = data.items[index];
                    return _NotificationTile(notification: n);
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _markAllRead(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(notificationsControllerProvider.notifier).markAllRead();
      await ref.read(notificationsControllerProvider.notifier).refresh();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationsMarkedAllRead)),
      );
    } catch (e) {
      final msg = _messageForError(e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = notification.id;
    final isRead = (notification.readAt?.trim().isNotEmpty ?? false);

    final title = (notification.title?.trim().isNotEmpty ?? false)
        ? notification.title!.trim()
      : l10n.notificationsDefaultTitle;

    final body = notification.body?.trim();
    final subtitle = body == null || body.isEmpty ? null : body;

    return ListTile(
      title: Text(
        title,
        style: isRead
            ? null
            : const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: isRead ? null : const Icon(Icons.circle, size: 10),
      onTap: (id == null || isRead)
          ? null
          : () async {
              try {
                await ref.read(notificationsControllerProvider.notifier).markRead(id);
                await ref.read(notificationsControllerProvider.notifier).refresh();
              } catch (e) {
                final msg = _messageForError(e);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
              }
            },
    );
  }
}

String _messageForError(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar as notificações.';
}

class _NotificationsEmptyText extends StatelessWidget {
  const _NotificationsEmptyText();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Text(l10n.notificationsEmpty);
  }
}
