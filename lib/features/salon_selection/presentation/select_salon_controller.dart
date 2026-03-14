import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/providers.dart';
import '../../../core/config/salon_meta.dart';
import '../../../core/config/selected_salon.dart';
import '../../../core/network/error_mapper.dart';

class SelectSalonUiState {
  const SelectSalonUiState({
    required this.isValidating,
    required this.validSalon,
    required this.errorMessage,
  });

  final bool isValidating;
  final SelectedSalon? validSalon;
  final String? errorMessage;

  bool get isValid => validSalon != null;

  SelectSalonUiState copyWith({
    bool? isValidating,
    SelectedSalon? validSalon,
    String? errorMessage,
    bool clearValid = false,
    bool clearError = false,
  }) {
    return SelectSalonUiState(
      isValidating: isValidating ?? this.isValidating,
      validSalon: clearValid ? null : (validSalon ?? this.validSalon),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static const initial = SelectSalonUiState(
    isValidating: false,
    validSalon: null,
    errorMessage: null,
  );
}

final selectSalonControllerProvider =
    NotifierProvider<SelectSalonController, SelectSalonUiState>(
  SelectSalonController.new,
);

class SelectSalonController extends Notifier<SelectSalonUiState> {
  @override
  SelectSalonUiState build() => SelectSalonUiState.initial;

  Future<void> validate({required String urlInput, required String slugInput}) async {
    final appConfig = ref.read(appConfigProvider);

    final baseUri = _resolveBaseUrl(appConfig, urlInput, slugInput);
    if (baseUri == null) {
      state = state.copyWith(
        errorMessage: 'Informe uma URL ou um código válido.',
        clearValid: true,
      );
      return;
    }

    state = state.copyWith(isValidating: true, clearError: true, clearValid: true);

    final dio = Dio(
      BaseOptions(
        baseUrl: _mobileBase(baseUri.toString()),
        connectTimeout: appConfig.connectTimeout,
        receiveTimeout: appConfig.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    try {
      final res = await dio.get<Object?>('/public/meta');
      SalonMeta? meta;
      final data = res.data;
      if (data is Map) {
        meta = SalonMeta.fromJson(data.map((k, v) => MapEntry(k.toString(), v)));
      }

      state = state.copyWith(
        isValidating: false,
        validSalon: SelectedSalon(baseUrl: baseUri.toString(), meta: meta),
      );
    } catch (e) {
      final failure = mapDioError(e);
      state = state.copyWith(
        isValidating: false,
        errorMessage: failure.message,
        clearValid: true,
      );
    }
  }

  Uri? _resolveBaseUrl(AppConfig config, String urlInput, String slugInput) {
    final url = urlInput.trim();
    if (url.isNotEmpty) {
      final parsed = Uri.tryParse(url);
      if (parsed == null) return null;
      if (!parsed.hasScheme) {
        return Uri.tryParse('https://$url');
      }
      return parsed.replace(path: '', query: '', fragment: '');
    }

    final slug = slugInput.trim();
    if (slug.isEmpty) return null;
    return config.buildBaseUrlFromSlug(slug);
  }
}

String _mobileBase(String baseUrl) {
  final trimmed = baseUrl.trim().replaceAll(RegExp(r'/*$'), '');
  return '$trimmed/mobile';
}
