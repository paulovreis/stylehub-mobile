// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceImpl _$$ServiceImplFromJson(Map<String, dynamic> json) =>
    _$ServiceImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      recommendedPrice: json['recommendedPrice'] as num?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$$ServiceImplToJson(_$ServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'durationMinutes': instance.durationMinutes,
      'recommendedPrice': instance.recommendedPrice,
      'active': instance.active,
    };
