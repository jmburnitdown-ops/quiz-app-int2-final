class SecurityService {
  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static final RegExp _passwordPattern = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
  );

  static String sanitizeInput(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '')
        .replaceAll('<', '')
        .replaceAll('>', '');
  }

  static String sanitizeEmail(String value) {
    return sanitizeInput(value).toLowerCase();
  }

  static bool isValidEmail(String value) {
    return _emailPattern.hasMatch(sanitizeEmail(value));
  }

  static bool isStrongPassword(String value) {
    return _passwordPattern.hasMatch(value);
  }
}
