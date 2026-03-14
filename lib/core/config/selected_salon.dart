import 'package:freezed_annotation/freezed_annotation.dart';

import 'salon_meta.dart';

part 'selected_salon.freezed.dart';
part 'selected_salon.g.dart';

@freezed
class SelectedSalon with _$SelectedSalon {
  const factory SelectedSalon({
    required String baseUrl,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _salonMetaFromJson, toJson: _salonMetaToJson)
    SalonMeta? meta,
  }) = _SelectedSalon;

  factory SelectedSalon.fromJson(Map<String, Object?> json) =>
      _$SelectedSalonFromJson(json);
}

SalonMeta? _salonMetaFromJson(Object? json) {
  if (json is Map) {
    return SalonMeta.fromJson(json.map((k, v) => MapEntry(k.toString(), v)));
  }
  return null;
}

Object? _salonMetaToJson(SalonMeta? meta) => meta?.toJson();
