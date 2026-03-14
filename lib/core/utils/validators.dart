class Validators {
  static bool isValidEmail(String value) {
    final v = value.trim();
    if (v.isEmpty) return false;
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(v);
  }

  static bool isStrongEnoughPassword(String value) {
    final v = value;
    return v.trim().length >= 6;
  }

  static bool isValidPhoneBR(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10 && digits.length <= 13;
  }
}
