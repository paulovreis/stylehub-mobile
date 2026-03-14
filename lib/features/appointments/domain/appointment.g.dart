// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: (json['id'] as num?)?.toInt(),
      appointmentDate: json['appointmentDate'] as String?,
      appointmentTime: json['appointmentTime'] as String?,
      status: json['status'] as String?,
      serviceName: json['serviceName'] as String?,
      employeeName: json['employeeName'] as String?,
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointmentDate': instance.appointmentDate,
      'appointmentTime': instance.appointmentTime,
      'status': instance.status,
      'serviceName': instance.serviceName,
      'employeeName': instance.employeeName,
    };
