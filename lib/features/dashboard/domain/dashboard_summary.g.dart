// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardSummaryImpl _$$DashboardSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardSummaryImpl(
  unreadNotificationsCount:
      (json['unreadNotificationsCount'] as num?)?.toInt() ?? 0,
  nextAppointment:
      json['nextAppointment'] == null
          ? null
          : DashboardNextAppointment.fromJson(
            json['nextAppointment'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$$DashboardSummaryImplToJson(
  _$DashboardSummaryImpl instance,
) => <String, dynamic>{
  'unreadNotificationsCount': instance.unreadNotificationsCount,
  'nextAppointment': instance.nextAppointment,
};

_$DashboardNextAppointmentImpl _$$DashboardNextAppointmentImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardNextAppointmentImpl(
  id: (json['id'] as num?)?.toInt(),
  appointmentDate: json['appointmentDate'] as String?,
  appointmentTime: json['appointmentTime'] as String?,
  status: json['status'] as String?,
  serviceName: json['serviceName'] as String?,
  employeeName: json['employeeName'] as String?,
);

Map<String, dynamic> _$$DashboardNextAppointmentImplToJson(
  _$DashboardNextAppointmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'appointmentDate': instance.appointmentDate,
  'appointmentTime': instance.appointmentTime,
  'status': instance.status,
  'serviceName': instance.serviceName,
  'employeeName': instance.employeeName,
};
