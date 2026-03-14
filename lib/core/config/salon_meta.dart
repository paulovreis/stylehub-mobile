import 'package:freezed_annotation/freezed_annotation.dart';

part 'salon_meta.freezed.dart';
part 'salon_meta.g.dart';

@freezed
class SalonMeta with _$SalonMeta {
  const factory SalonMeta({
    String? slug,
    String? name,
    String? city,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'logo_url') String? logoUrl,
  }) = _SalonMeta;

  factory SalonMeta.fromJson(Map<String, dynamic> json) =>
      _$SalonMetaFromJson(json);
}
