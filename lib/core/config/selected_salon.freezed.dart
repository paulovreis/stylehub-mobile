// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_salon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SelectedSalon _$SelectedSalonFromJson(Map<String, dynamic> json) {
  return _SelectedSalon.fromJson(json);
}

/// @nodoc
mixin _$SelectedSalon {
  String get baseUrl =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _salonMetaFromJson, toJson: _salonMetaToJson)
  SalonMeta? get meta => throw _privateConstructorUsedError;

  /// Serializes this SelectedSalon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectedSalon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectedSalonCopyWith<SelectedSalon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedSalonCopyWith<$Res> {
  factory $SelectedSalonCopyWith(
    SelectedSalon value,
    $Res Function(SelectedSalon) then,
  ) = _$SelectedSalonCopyWithImpl<$Res, SelectedSalon>;
  @useResult
  $Res call({
    String baseUrl,
    @JsonKey(fromJson: _salonMetaFromJson, toJson: _salonMetaToJson)
    SalonMeta? meta,
  });

  $SalonMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class _$SelectedSalonCopyWithImpl<$Res, $Val extends SelectedSalon>
    implements $SelectedSalonCopyWith<$Res> {
  _$SelectedSalonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectedSalon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? baseUrl = null, Object? meta = freezed}) {
    return _then(
      _value.copyWith(
            baseUrl:
                null == baseUrl
                    ? _value.baseUrl
                    : baseUrl // ignore: cast_nullable_to_non_nullable
                        as String,
            meta:
                freezed == meta
                    ? _value.meta
                    : meta // ignore: cast_nullable_to_non_nullable
                        as SalonMeta?,
          )
          as $Val,
    );
  }

  /// Create a copy of SelectedSalon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SalonMetaCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $SalonMetaCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SelectedSalonImplCopyWith<$Res>
    implements $SelectedSalonCopyWith<$Res> {
  factory _$$SelectedSalonImplCopyWith(
    _$SelectedSalonImpl value,
    $Res Function(_$SelectedSalonImpl) then,
  ) = __$$SelectedSalonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String baseUrl,
    @JsonKey(fromJson: _salonMetaFromJson, toJson: _salonMetaToJson)
    SalonMeta? meta,
  });

  @override
  $SalonMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$SelectedSalonImplCopyWithImpl<$Res>
    extends _$SelectedSalonCopyWithImpl<$Res, _$SelectedSalonImpl>
    implements _$$SelectedSalonImplCopyWith<$Res> {
  __$$SelectedSalonImplCopyWithImpl(
    _$SelectedSalonImpl _value,
    $Res Function(_$SelectedSalonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectedSalon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? baseUrl = null, Object? meta = freezed}) {
    return _then(
      _$SelectedSalonImpl(
        baseUrl:
            null == baseUrl
                ? _value.baseUrl
                : baseUrl // ignore: cast_nullable_to_non_nullable
                    as String,
        meta:
            freezed == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                    as SalonMeta?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectedSalonImpl implements _SelectedSalon {
  const _$SelectedSalonImpl({
    required this.baseUrl,
    @JsonKey(fromJson: _salonMetaFromJson, toJson: _salonMetaToJson) this.meta,
  });

  factory _$SelectedSalonImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedSalonImplFromJson(json);

  @override
  final String baseUrl;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _salonMetaFromJson, toJson: _salonMetaToJson)
  final SalonMeta? meta;

  @override
  String toString() {
    return 'SelectedSalon(baseUrl: $baseUrl, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedSalonImpl &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, baseUrl, meta);

  /// Create a copy of SelectedSalon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedSalonImplCopyWith<_$SelectedSalonImpl> get copyWith =>
      __$$SelectedSalonImplCopyWithImpl<_$SelectedSalonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedSalonImplToJson(this);
  }
}

abstract class _SelectedSalon implements SelectedSalon {
  const factory _SelectedSalon({
    required final String baseUrl,
    @JsonKey(fromJson: _salonMetaFromJson, toJson: _salonMetaToJson)
    final SalonMeta? meta,
  }) = _$SelectedSalonImpl;

  factory _SelectedSalon.fromJson(Map<String, dynamic> json) =
      _$SelectedSalonImpl.fromJson;

  @override
  String get baseUrl; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _salonMetaFromJson, toJson: _salonMetaToJson)
  SalonMeta? get meta;

  /// Create a copy of SelectedSalon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectedSalonImplCopyWith<_$SelectedSalonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
