// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppFailure {
  AppFailureKind get kind => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  int? get statusCode => throw _privateConstructorUsedError;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppFailureCopyWith<AppFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppFailureCopyWith<$Res> {
  factory $AppFailureCopyWith(
    AppFailure value,
    $Res Function(AppFailure) then,
  ) = _$AppFailureCopyWithImpl<$Res, AppFailure>;
  @useResult
  $Res call({AppFailureKind kind, String message, int? statusCode});
}

/// @nodoc
class _$AppFailureCopyWithImpl<$Res, $Val extends AppFailure>
    implements $AppFailureCopyWith<$Res> {
  _$AppFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? message = null,
    Object? statusCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            kind:
                null == kind
                    ? _value.kind
                    : kind // ignore: cast_nullable_to_non_nullable
                        as AppFailureKind,
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
            statusCode:
                freezed == statusCode
                    ? _value.statusCode
                    : statusCode // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppFailureImplCopyWith<$Res>
    implements $AppFailureCopyWith<$Res> {
  factory _$$AppFailureImplCopyWith(
    _$AppFailureImpl value,
    $Res Function(_$AppFailureImpl) then,
  ) = __$$AppFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AppFailureKind kind, String message, int? statusCode});
}

/// @nodoc
class __$$AppFailureImplCopyWithImpl<$Res>
    extends _$AppFailureCopyWithImpl<$Res, _$AppFailureImpl>
    implements _$$AppFailureImplCopyWith<$Res> {
  __$$AppFailureImplCopyWithImpl(
    _$AppFailureImpl _value,
    $Res Function(_$AppFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? message = null,
    Object? statusCode = freezed,
  }) {
    return _then(
      _$AppFailureImpl(
        kind:
            null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                    as AppFailureKind,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        statusCode:
            freezed == statusCode
                ? _value.statusCode
                : statusCode // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc

class _$AppFailureImpl implements _AppFailure {
  const _$AppFailureImpl({
    required this.kind,
    required this.message,
    this.statusCode,
  });

  @override
  final AppFailureKind kind;
  @override
  final String message;
  @override
  final int? statusCode;

  @override
  String toString() {
    return 'AppFailure(kind: $kind, message: $message, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppFailureImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, kind, message, statusCode);

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppFailureImplCopyWith<_$AppFailureImpl> get copyWith =>
      __$$AppFailureImplCopyWithImpl<_$AppFailureImpl>(this, _$identity);
}

abstract class _AppFailure implements AppFailure {
  const factory _AppFailure({
    required final AppFailureKind kind,
    required final String message,
    final int? statusCode,
  }) = _$AppFailureImpl;

  @override
  AppFailureKind get kind;
  @override
  String get message;
  @override
  int? get statusCode;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppFailureImplCopyWith<_$AppFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
