import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    int? id,
    String? title,
    String? body,
    String? createdAt,
    String? readAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  factory AppNotification.parse(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    map['id'] = _toIntOrNull(map['id']);

    map['title'] ??= _firstPresent(map, const ['subject', 'notification_title']);
    map['body'] ??= _firstPresent(map, const ['message', 'content', 'text', 'notification_body']);

    map['createdAt'] ??= _firstPresent(map, const [
      'created_at',
      'createdAt',
      'date',
      'sent_at',
      'sentAt',
    ]);

    map['readAt'] ??= _firstPresent(map, const [
      'read_at',
      'readAt',
      'read_date',
    ]);

    return AppNotification.fromJson(map);
  }
}

Object? _firstPresent(Map<String, dynamic> map, List<String> keys) {
  for (final k in keys) {
    if (map.containsKey(k) && map[k] != null) return map[k];
  }
  return null;
}

int? _toIntOrNull(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}
