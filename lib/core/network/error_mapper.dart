import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'app_failure.dart';

AppFailure mapDioError(Object error) {
  if (error is AppFailure) return error;

  if (error is DioException) {
    final status = error.response?.statusCode;
    final messageFromBody = _extractMessage(error.response?.data);

    if (status != null) {
      if (status == 400) {
        return AppFailure(
          kind: AppFailureKind.validation,
          message: messageFromBody ?? 'Verifique os dados e tente novamente.',
          statusCode: status,
        );
      }
      if (status == 401) {
        return AppFailure(
          kind: AppFailureKind.unauthorized,
          message: 'Sessão expirada. Faça login novamente.',
          statusCode: status,
        );
      }
      if (status == 403) {
        return AppFailure(
          kind: AppFailureKind.forbidden,
          message: 'Você não tem permissão para isso.',
          statusCode: status,
        );
      }
      if (status == 404) {
        return AppFailure(
          kind: AppFailureKind.notFound,
          message: messageFromBody ?? 'Recurso não encontrado.',
          statusCode: status,
        );
      }
      if (status == 409) {
        return AppFailure(
          kind: AppFailureKind.conflict,
          message: messageFromBody ?? 'Conflito. Tente novamente.',
          statusCode: status,
        );
      }
      if (status >= 500) {
        return AppFailure(
          kind: AppFailureKind.server,
          message: 'Instabilidade no servidor. Tente novamente em instantes.',
          statusCode: status,
        );
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const AppFailure(
        kind: AppFailureKind.network,
        message: 'Tempo esgotado. Verifique sua conexão.',
      );
    }

    final underlying = error.error;
    if (underlying is SocketException) {
      return const AppFailure(
        kind: AppFailureKind.network,
        message: 'Sem conexão. Verifique a internet e tente novamente.',
      );
    }

    return AppFailure(
      kind: AppFailureKind.unknown,
      message: messageFromBody ?? 'Não foi possível completar sua solicitação.',
      statusCode: status,
    );
  }

  return const AppFailure(
    kind: AppFailureKind.unknown,
    message: 'Erro inesperado.',
  );
}

String? _extractMessage(Object? data) {
  if (data == null) return null;
  if (data is String) {
    final v = data.trim();
    if (v.isEmpty) return null;

    // Avoid leaking HTML pages as error messages.
    final upper = v.toUpperCase();
    if (upper.contains('<HTML') || upper.contains('<!DOCTYPE') || upper.contains('<BODY')) {
      return null;
    }

    // If looks like JSON, try decoding.
    if ((v.startsWith('{') && v.endsWith('}')) || (v.startsWith('[') && v.endsWith(']'))) {
      try {
        final decoded = jsonDecode(v);
        return _extractMessage(decoded) ?? (v.length <= 200 ? v : null);
      } catch (_) {
        // Fall through.
      }
    }

    return v.length <= 200 ? v : null;
  }
  if (data is Map) {
    final msg = data['message'];
    if (msg is String && msg.trim().isNotEmpty) {
      return msg.trim();
    }

    // express-validator format: { errors: [ { msg, path, ... } ] }
    final errors = data['errors'];
    if (errors is List && errors.isNotEmpty) {
      final first = errors.first;
      if (first is String && first.trim().isNotEmpty) {
        return first.trim();
      }
      if (first is Map) {
        final m = first.map((k, v) => MapEntry(k.toString(), v));
        final emsg = m['msg'] ?? m['message'];
        final path = m['path'] ?? m['field'];
        if (emsg is String && emsg.trim().isNotEmpty) {
          final p = path is String ? path.trim() : '';
          return p.isEmpty ? emsg.trim() : '${emsg.trim()} ($p)';
        }
      }
    }
  }
  return null;
}
