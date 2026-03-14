import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

enum AppFailureKind {
  network,
  validation,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  server,
  unknown,
}

@freezed
class AppFailure with _$AppFailure {
  const factory AppFailure({
    required AppFailureKind kind,
    required String message,
    int? statusCode,
  }) = _AppFailure;
}
