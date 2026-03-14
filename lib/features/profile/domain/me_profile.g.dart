// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeProfileImpl _$$MeProfileImplFromJson(Map<String, dynamic> json) =>
    _$MeProfileImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$MeProfileImplToJson(_$MeProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };
