// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$AppNotificationImpl(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  body: json['body'] as String?,
  createdAt: json['createdAt'] as String?,
  readAt: json['readAt'] as String?,
);

Map<String, dynamic> _$$AppNotificationImplToJson(
  _$AppNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'createdAt': instance.createdAt,
  'readAt': instance.readAt,
};
