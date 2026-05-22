import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _channelId = 'stylehub_channel';
const _channelName = 'StyleHub';
const _channelDesc = 'Notificações do StyleHub';

final _plugin = FlutterLocalNotificationsPlugin();
bool _initialized = false;
int _notifId = 0;

Future<void> initLocalNotifications() async {
  if (_initialized) return;
  _initialized = true;

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  await _plugin.initialize(
    const InitializationSettings(android: android, iOS: ios),
  );

  await _plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.high,
        ),
      );
}

Future<void> showLocalNotification({
  required String title,
  required String body,
}) async {
  await _plugin.show(
    _notifId++,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
  );
}
