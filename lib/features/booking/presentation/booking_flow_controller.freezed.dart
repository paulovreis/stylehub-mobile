// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_flow_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BookingDraft {
  Service? get service => throw _privateConstructorUsedError;
  Employee? get employee => throw _privateConstructorUsedError;
  String? get dateYmd => throw _privateConstructorUsedError;
  String? get timeHm => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  /// Create a copy of BookingDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingDraftCopyWith<BookingDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDraftCopyWith<$Res> {
  factory $BookingDraftCopyWith(
    BookingDraft value,
    $Res Function(BookingDraft) then,
  ) = _$BookingDraftCopyWithImpl<$Res, BookingDraft>;
  @useResult
  $Res call({
    Service? service,
    Employee? employee,
    String? dateYmd,
    String? timeHm,
    String notes,
  });

  $ServiceCopyWith<$Res>? get service;
  $EmployeeCopyWith<$Res>? get employee;
}

/// @nodoc
class _$BookingDraftCopyWithImpl<$Res, $Val extends BookingDraft>
    implements $BookingDraftCopyWith<$Res> {
  _$BookingDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? service = freezed,
    Object? employee = freezed,
    Object? dateYmd = freezed,
    Object? timeHm = freezed,
    Object? notes = null,
  }) {
    return _then(
      _value.copyWith(
            service:
                freezed == service
                    ? _value.service
                    : service // ignore: cast_nullable_to_non_nullable
                        as Service?,
            employee:
                freezed == employee
                    ? _value.employee
                    : employee // ignore: cast_nullable_to_non_nullable
                        as Employee?,
            dateYmd:
                freezed == dateYmd
                    ? _value.dateYmd
                    : dateYmd // ignore: cast_nullable_to_non_nullable
                        as String?,
            timeHm:
                freezed == timeHm
                    ? _value.timeHm
                    : timeHm // ignore: cast_nullable_to_non_nullable
                        as String?,
            notes:
                null == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }

  /// Create a copy of BookingDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceCopyWith<$Res>? get service {
    if (_value.service == null) {
      return null;
    }

    return $ServiceCopyWith<$Res>(_value.service!, (value) {
      return _then(_value.copyWith(service: value) as $Val);
    });
  }

  /// Create a copy of BookingDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmployeeCopyWith<$Res>? get employee {
    if (_value.employee == null) {
      return null;
    }

    return $EmployeeCopyWith<$Res>(_value.employee!, (value) {
      return _then(_value.copyWith(employee: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingDraftImplCopyWith<$Res>
    implements $BookingDraftCopyWith<$Res> {
  factory _$$BookingDraftImplCopyWith(
    _$BookingDraftImpl value,
    $Res Function(_$BookingDraftImpl) then,
  ) = __$$BookingDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Service? service,
    Employee? employee,
    String? dateYmd,
    String? timeHm,
    String notes,
  });

  @override
  $ServiceCopyWith<$Res>? get service;
  @override
  $EmployeeCopyWith<$Res>? get employee;
}

/// @nodoc
class __$$BookingDraftImplCopyWithImpl<$Res>
    extends _$BookingDraftCopyWithImpl<$Res, _$BookingDraftImpl>
    implements _$$BookingDraftImplCopyWith<$Res> {
  __$$BookingDraftImplCopyWithImpl(
    _$BookingDraftImpl _value,
    $Res Function(_$BookingDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? service = freezed,
    Object? employee = freezed,
    Object? dateYmd = freezed,
    Object? timeHm = freezed,
    Object? notes = null,
  }) {
    return _then(
      _$BookingDraftImpl(
        service:
            freezed == service
                ? _value.service
                : service // ignore: cast_nullable_to_non_nullable
                    as Service?,
        employee:
            freezed == employee
                ? _value.employee
                : employee // ignore: cast_nullable_to_non_nullable
                    as Employee?,
        dateYmd:
            freezed == dateYmd
                ? _value.dateYmd
                : dateYmd // ignore: cast_nullable_to_non_nullable
                    as String?,
        timeHm:
            freezed == timeHm
                ? _value.timeHm
                : timeHm // ignore: cast_nullable_to_non_nullable
                    as String?,
        notes:
            null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$BookingDraftImpl extends _BookingDraft {
  const _$BookingDraftImpl({
    this.service,
    this.employee,
    this.dateYmd,
    this.timeHm,
    this.notes = '',
  }) : super._();

  @override
  final Service? service;
  @override
  final Employee? employee;
  @override
  final String? dateYmd;
  @override
  final String? timeHm;
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'BookingDraft(service: $service, employee: $employee, dateYmd: $dateYmd, timeHm: $timeHm, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDraftImpl &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.employee, employee) ||
                other.employee == employee) &&
            (identical(other.dateYmd, dateYmd) || other.dateYmd == dateYmd) &&
            (identical(other.timeHm, timeHm) || other.timeHm == timeHm) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, service, employee, dateYmd, timeHm, notes);

  /// Create a copy of BookingDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDraftImplCopyWith<_$BookingDraftImpl> get copyWith =>
      __$$BookingDraftImplCopyWithImpl<_$BookingDraftImpl>(this, _$identity);
}

abstract class _BookingDraft extends BookingDraft {
  const factory _BookingDraft({
    final Service? service,
    final Employee? employee,
    final String? dateYmd,
    final String? timeHm,
    final String notes,
  }) = _$BookingDraftImpl;
  const _BookingDraft._() : super._();

  @override
  Service? get service;
  @override
  Employee? get employee;
  @override
  String? get dateYmd;
  @override
  String? get timeHm;
  @override
  String get notes;

  /// Create a copy of BookingDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingDraftImplCopyWith<_$BookingDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
