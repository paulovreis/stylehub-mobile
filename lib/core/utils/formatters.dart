import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  static final DateFormat _dateBr = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeHm = DateFormat('HH:mm');
  static final NumberFormat _currencyBr = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  static String formatDateFlexible(String? raw) {
    final dt = parseDateFlexible(raw);
    if (dt == null) return (raw ?? '').trim();
    return _dateBr.format(dt);
  }

  static DateTime? parseDateFlexible(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return null;

    // ISO (2026-03-14T00:00:00.000Z) or (2026-03-14)
    final iso = DateTime.tryParse(v);
    if (iso != null) {
      // Convert to local for display.
      return iso.toLocal();
    }

    // dd/MM/yyyy
    final brMatch = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(v);
    if (brMatch != null) {
      final d = int.tryParse(brMatch.group(1)!);
      final m = int.tryParse(brMatch.group(2)!);
      final y = int.tryParse(brMatch.group(3)!);
      if (d != null && m != null && y != null) return DateTime(y, m, d);
    }

    return null;
  }

  static String formatTimeFlexible(String? raw) {
    final dt = parseTimeFlexible(raw);
    if (dt == null) return (raw ?? '').trim();
    return _timeHm.format(dt);
  }

  static DateTime? parseTimeFlexible(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return null;

    // Accept HH:mm, HH:mm:ss
    final match = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$').firstMatch(v);
    if (match == null) return null;

    final h = int.tryParse(match.group(1)!);
    final m = int.tryParse(match.group(2)!);
    final s = int.tryParse(match.group(3) ?? '0');
    if (h == null || m == null || s == null) return null;
    if (h < 0 || h > 23 || m < 0 || m > 59 || s < 0 || s > 59) return null;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, h, m, s);
  }

  static String formatCurrencyBR(num? value) {
    if (value == null) return '';
    return _currencyBr.format(value);
  }

  static String formatPhoneBR(String? raw) {
    final digits = onlyDigits(raw);
    if (digits.isEmpty) return '';

    // Heurística para BR: assume que já vem com DDD.
    // 10 dígitos: (DD) XXXX-XXXX
    // 11 dígitos: (DD) 9XXXX-XXXX
    final ddd = digits.length >= 2 ? digits.substring(0, 2) : digits;
    final rest = digits.length > 2 ? digits.substring(2) : '';

    if (rest.length == 8) {
      return '($ddd) ${rest.substring(0, 4)}-${rest.substring(4)}';
    }
    if (rest.length == 9) {
      return '($ddd) ${rest.substring(0, 5)}-${rest.substring(5)}';
    }

    // Fallback: não força máscara se tamanho inesperado.
    return digits;
  }

  static String onlyDigits(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return '';
    return v.replaceAll(RegExp(r'\D'), '');
  }
}

/// Formata telefone BR enquanto digita.
/// Mantém apenas dígitos e aplica (DD) 9XXXX-XXXX / (DD) XXXX-XXXX.
class BrPhoneTextInputFormatter extends TextInputFormatter {
  const BrPhoneTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Evita crescer indefinidamente.
    final capped = digits.length > 13 ? digits.substring(0, 13) : digits;

    final formatted = AppFormatters.formatPhoneBR(capped);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
