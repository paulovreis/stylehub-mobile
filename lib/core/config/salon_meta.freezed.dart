// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalonMeta _$SalonMetaFromJson(Map<String, dynamic> json) {
  return _SalonMeta.fromJson(json);
}

/// @nodoc
mixin _$SalonMeta {
  String? get slug => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get city =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;

  /// Serializes this SalonMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonMetaCopyWith<SalonMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonMetaCopyWith<$Res> {
  factory $SalonMetaCopyWith(SalonMeta value, $Res Function(SalonMeta) then) =
      _$SalonMetaCopyWithImpl<$Res, SalonMeta>;
  @useResult
  $Res call({
    String? slug,
    String? name,
    String? city,
    @JsonKey(name: 'logo_url') String? logoUrl,
  });
}

/// @nodoc
class _$SalonMetaCopyWithImpl<$Res, $Val extends SalonMeta>
    implements $SalonMetaCopyWith<$Res> {
  _$SalonMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = freezed,
    Object? name = freezed,
    Object? city = freezed,
    Object? logoUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            slug:
                freezed == slug
                    ? _value.slug
                    : slug // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            city:
                freezed == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String?,
            logoUrl:
                freezed == logoUrl
                    ? _value.logoUrl
                    : logoUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalonMetaImplCopyWith<$Res>
    implements $SalonMetaCopyWith<$Res> {
  factory _$$SalonMetaImplCopyWith(
    _$SalonMetaImpl value,
    $Res Function(_$SalonMetaImpl) then,
  ) = __$$SalonMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? slug,
    String? name,
    String? city,
    @JsonKey(name: 'logo_url') String? logoUrl,
  });
}

/// @nodoc
class __$$SalonMetaImplCopyWithImpl<$Res>
    extends _$SalonMetaCopyWithImpl<$Res, _$SalonMetaImpl>
    implements _$$SalonMetaImplCopyWith<$Res> {
  __$$SalonMetaImplCopyWithImpl(
    _$SalonMetaImpl _value,
    $Res Function(_$SalonMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = freezed,
    Object? name = freezed,
    Object? city = freezed,
    Object? logoUrl = freezed,
  }) {
    return _then(
      _$SalonMetaImpl(
        slug:
            freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        city:
            freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String?,
        logoUrl:
            freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonMetaImpl implements _SalonMeta {
  const _$SalonMetaImpl({
    this.slug,
    this.name,
    this.city,
    @JsonKey(name: 'logo_url') this.logoUrl,
  });

  factory _$SalonMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonMetaImplFromJson(json);

  @override
  final String? slug;
  @override
  final String? name;
  @override
  final String? city;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;

  @override
  String toString() {
    return 'SalonMeta(slug: $slug, name: $name, city: $city, logoUrl: $logoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonMetaImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, slug, name, city, logoUrl);

  /// Create a copy of SalonMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonMetaImplCopyWith<_$SalonMetaImpl> get copyWith =>
      __$$SalonMetaImplCopyWithImpl<_$SalonMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonMetaImplToJson(this);
  }
}

abstract class _SalonMeta implements SalonMeta {
  const factory _SalonMeta({
    final String? slug,
    final String? name,
    final String? city,
    @JsonKey(name: 'logo_url') final String? logoUrl,
  }) = _$SalonMetaImpl;

  factory _SalonMeta.fromJson(Map<String, dynamic> json) =
      _$SalonMetaImpl.fromJson;

  @override
  String? get slug;
  @override
  String? get name;
  @override
  String? get city; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;

  /// Create a copy of SalonMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonMetaImplCopyWith<_$SalonMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
