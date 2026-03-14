// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) {
  return _DashboardSummary.fromJson(json);
}

/// @nodoc
mixin _$DashboardSummary {
  int get unreadNotificationsCount => throw _privateConstructorUsedError;
  DashboardNextAppointment? get nextAppointment =>
      throw _privateConstructorUsedError;

  /// Serializes this DashboardSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardSummaryCopyWith<DashboardSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardSummaryCopyWith<$Res> {
  factory $DashboardSummaryCopyWith(
    DashboardSummary value,
    $Res Function(DashboardSummary) then,
  ) = _$DashboardSummaryCopyWithImpl<$Res, DashboardSummary>;
  @useResult
  $Res call({
    int unreadNotificationsCount,
    DashboardNextAppointment? nextAppointment,
  });

  $DashboardNextAppointmentCopyWith<$Res>? get nextAppointment;
}

/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res, $Val extends DashboardSummary>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unreadNotificationsCount = null,
    Object? nextAppointment = freezed,
  }) {
    return _then(
      _value.copyWith(
            unreadNotificationsCount:
                null == unreadNotificationsCount
                    ? _value.unreadNotificationsCount
                    : unreadNotificationsCount // ignore: cast_nullable_to_non_nullable
                        as int,
            nextAppointment:
                freezed == nextAppointment
                    ? _value.nextAppointment
                    : nextAppointment // ignore: cast_nullable_to_non_nullable
                        as DashboardNextAppointment?,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardNextAppointmentCopyWith<$Res>? get nextAppointment {
    if (_value.nextAppointment == null) {
      return null;
    }

    return $DashboardNextAppointmentCopyWith<$Res>(_value.nextAppointment!, (
      value,
    ) {
      return _then(_value.copyWith(nextAppointment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardSummaryImplCopyWith<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  factory _$$DashboardSummaryImplCopyWith(
    _$DashboardSummaryImpl value,
    $Res Function(_$DashboardSummaryImpl) then,
  ) = __$$DashboardSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int unreadNotificationsCount,
    DashboardNextAppointment? nextAppointment,
  });

  @override
  $DashboardNextAppointmentCopyWith<$Res>? get nextAppointment;
}

/// @nodoc
class __$$DashboardSummaryImplCopyWithImpl<$Res>
    extends _$DashboardSummaryCopyWithImpl<$Res, _$DashboardSummaryImpl>
    implements _$$DashboardSummaryImplCopyWith<$Res> {
  __$$DashboardSummaryImplCopyWithImpl(
    _$DashboardSummaryImpl _value,
    $Res Function(_$DashboardSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unreadNotificationsCount = null,
    Object? nextAppointment = freezed,
  }) {
    return _then(
      _$DashboardSummaryImpl(
        unreadNotificationsCount:
            null == unreadNotificationsCount
                ? _value.unreadNotificationsCount
                : unreadNotificationsCount // ignore: cast_nullable_to_non_nullable
                    as int,
        nextAppointment:
            freezed == nextAppointment
                ? _value.nextAppointment
                : nextAppointment // ignore: cast_nullable_to_non_nullable
                    as DashboardNextAppointment?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardSummaryImpl implements _DashboardSummary {
  const _$DashboardSummaryImpl({
    this.unreadNotificationsCount = 0,
    this.nextAppointment,
  });

  factory _$DashboardSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardSummaryImplFromJson(json);

  @override
  @JsonKey()
  final int unreadNotificationsCount;
  @override
  final DashboardNextAppointment? nextAppointment;

  @override
  String toString() {
    return 'DashboardSummary(unreadNotificationsCount: $unreadNotificationsCount, nextAppointment: $nextAppointment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardSummaryImpl &&
            (identical(
                  other.unreadNotificationsCount,
                  unreadNotificationsCount,
                ) ||
                other.unreadNotificationsCount == unreadNotificationsCount) &&
            (identical(other.nextAppointment, nextAppointment) ||
                other.nextAppointment == nextAppointment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, unreadNotificationsCount, nextAppointment);

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardSummaryImplCopyWith<_$DashboardSummaryImpl> get copyWith =>
      __$$DashboardSummaryImplCopyWithImpl<_$DashboardSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardSummaryImplToJson(this);
  }
}

abstract class _DashboardSummary implements DashboardSummary {
  const factory _DashboardSummary({
    final int unreadNotificationsCount,
    final DashboardNextAppointment? nextAppointment,
  }) = _$DashboardSummaryImpl;

  factory _DashboardSummary.fromJson(Map<String, dynamic> json) =
      _$DashboardSummaryImpl.fromJson;

  @override
  int get unreadNotificationsCount;
  @override
  DashboardNextAppointment? get nextAppointment;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardSummaryImplCopyWith<_$DashboardSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardNextAppointment _$DashboardNextAppointmentFromJson(
  Map<String, dynamic> json,
) {
  return _DashboardNextAppointment.fromJson(json);
}

/// @nodoc
mixin _$DashboardNextAppointment {
  int? get id => throw _privateConstructorUsedError;
  String? get appointmentDate => throw _privateConstructorUsedError;
  String? get appointmentTime => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get serviceName => throw _privateConstructorUsedError;
  String? get employeeName => throw _privateConstructorUsedError;

  /// Serializes this DashboardNextAppointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardNextAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardNextAppointmentCopyWith<DashboardNextAppointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardNextAppointmentCopyWith<$Res> {
  factory $DashboardNextAppointmentCopyWith(
    DashboardNextAppointment value,
    $Res Function(DashboardNextAppointment) then,
  ) = _$DashboardNextAppointmentCopyWithImpl<$Res, DashboardNextAppointment>;
  @useResult
  $Res call({
    int? id,
    String? appointmentDate,
    String? appointmentTime,
    String? status,
    String? serviceName,
    String? employeeName,
  });
}

/// @nodoc
class _$DashboardNextAppointmentCopyWithImpl<
  $Res,
  $Val extends DashboardNextAppointment
>
    implements $DashboardNextAppointmentCopyWith<$Res> {
  _$DashboardNextAppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardNextAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? appointmentDate = freezed,
    Object? appointmentTime = freezed,
    Object? status = freezed,
    Object? serviceName = freezed,
    Object? employeeName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            appointmentDate:
                freezed == appointmentDate
                    ? _value.appointmentDate
                    : appointmentDate // ignore: cast_nullable_to_non_nullable
                        as String?,
            appointmentTime:
                freezed == appointmentTime
                    ? _value.appointmentTime
                    : appointmentTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String?,
            serviceName:
                freezed == serviceName
                    ? _value.serviceName
                    : serviceName // ignore: cast_nullable_to_non_nullable
                        as String?,
            employeeName:
                freezed == employeeName
                    ? _value.employeeName
                    : employeeName // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardNextAppointmentImplCopyWith<$Res>
    implements $DashboardNextAppointmentCopyWith<$Res> {
  factory _$$DashboardNextAppointmentImplCopyWith(
    _$DashboardNextAppointmentImpl value,
    $Res Function(_$DashboardNextAppointmentImpl) then,
  ) = __$$DashboardNextAppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? appointmentDate,
    String? appointmentTime,
    String? status,
    String? serviceName,
    String? employeeName,
  });
}

/// @nodoc
class __$$DashboardNextAppointmentImplCopyWithImpl<$Res>
    extends
        _$DashboardNextAppointmentCopyWithImpl<
          $Res,
          _$DashboardNextAppointmentImpl
        >
    implements _$$DashboardNextAppointmentImplCopyWith<$Res> {
  __$$DashboardNextAppointmentImplCopyWithImpl(
    _$DashboardNextAppointmentImpl _value,
    $Res Function(_$DashboardNextAppointmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardNextAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? appointmentDate = freezed,
    Object? appointmentTime = freezed,
    Object? status = freezed,
    Object? serviceName = freezed,
    Object? employeeName = freezed,
  }) {
    return _then(
      _$DashboardNextAppointmentImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        appointmentDate:
            freezed == appointmentDate
                ? _value.appointmentDate
                : appointmentDate // ignore: cast_nullable_to_non_nullable
                    as String?,
        appointmentTime:
            freezed == appointmentTime
                ? _value.appointmentTime
                : appointmentTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String?,
        serviceName:
            freezed == serviceName
                ? _value.serviceName
                : serviceName // ignore: cast_nullable_to_non_nullable
                    as String?,
        employeeName:
            freezed == employeeName
                ? _value.employeeName
                : employeeName // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardNextAppointmentImpl implements _DashboardNextAppointment {
  const _$DashboardNextAppointmentImpl({
    this.id,
    this.appointmentDate,
    this.appointmentTime,
    this.status,
    this.serviceName,
    this.employeeName,
  });

  factory _$DashboardNextAppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardNextAppointmentImplFromJson(json);

  @override
  final int? id;
  @override
  final String? appointmentDate;
  @override
  final String? appointmentTime;
  @override
  final String? status;
  @override
  final String? serviceName;
  @override
  final String? employeeName;

  @override
  String toString() {
    return 'DashboardNextAppointment(id: $id, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, status: $status, serviceName: $serviceName, employeeName: $employeeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardNextAppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.appointmentDate, appointmentDate) ||
                other.appointmentDate == appointmentDate) &&
            (identical(other.appointmentTime, appointmentTime) ||
                other.appointmentTime == appointmentTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    appointmentDate,
    appointmentTime,
    status,
    serviceName,
    employeeName,
  );

  /// Create a copy of DashboardNextAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardNextAppointmentImplCopyWith<_$DashboardNextAppointmentImpl>
  get copyWith => __$$DashboardNextAppointmentImplCopyWithImpl<
    _$DashboardNextAppointmentImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardNextAppointmentImplToJson(this);
  }
}

abstract class _DashboardNextAppointment implements DashboardNextAppointment {
  const factory _DashboardNextAppointment({
    final int? id,
    final String? appointmentDate,
    final String? appointmentTime,
    final String? status,
    final String? serviceName,
    final String? employeeName,
  }) = _$DashboardNextAppointmentImpl;

  factory _DashboardNextAppointment.fromJson(Map<String, dynamic> json) =
      _$DashboardNextAppointmentImpl.fromJson;

  @override
  int? get id;
  @override
  String? get appointmentDate;
  @override
  String? get appointmentTime;
  @override
  String? get status;
  @override
  String? get serviceName;
  @override
  String? get employeeName;

  /// Create a copy of DashboardNextAppointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardNextAppointmentImplCopyWith<_$DashboardNextAppointmentImpl>
  get copyWith => throw _privateConstructorUsedError;
}
