/// Bangladesh phone number validation utility.
///
/// Validates phone numbers according to Bangladesh mobile operator rules:
/// - Must start with 1
/// - Second digit must be 3, 4, 5, 6, 7, 8, or 9
/// - Total length must be 10 digits (after +880)
/// - Full format: +8801[3-9]XXXXXXXX
class PhoneValidator {
  PhoneValidator._();

  /// Valid operator codes (second digit after 1)
  static const List<String> _validOperators = ['3', '4', '5', '6', '7', '8', '9'];

  /// Validates a Bangladesh phone number (without country code).
  ///
  /// Expected input format: 1[3-9]XXXXXXXX (10 digits)
  ///
  /// Returns:
  /// - `null` if valid or still typing valid input
  /// - `"Invalid operator."` if operator rule is violated
  /// - `"Invalid number."` if operator is valid but final length is incorrect
  ///
  /// Validation Rules:
  /// - Show "Invalid operator." ONLY when:
  ///   1. First digit is not 1 AND user typed more than 1 digit
  ///   2. Second digit is invalid (not 3-9) AND user typed more than 2 digits
  /// - Show "Invalid number." ONLY when:
  ///   1. Operator is valid (1[3-9]) AND length is exactly 10 but validation fails
  ///   2. This should rarely happen as we enforce 10 digits
  /// - Show nothing while user is still typing valid input
  static String? validateBangladeshPhone(String input) {
    // Remove any whitespace
    final phone = input.trim();

    // Empty input is not an error
    if (phone.isEmpty) {
      return null;
    }

    // Only 1 digit entered - don't show validation yet
    if (phone.length == 1) {
      return null;
    }

    // Check if first digit is 1
    if (phone[0] != '1') {
      // User entered invalid first digit and continued typing
      return 'Invalid operator.';
    }

    // First digit is valid (1), check if we have second digit
    if (phone.length == 2) {
      // Check second digit
      final secondDigit = phone[1];
      if (!_validOperators.contains(secondDigit)) {
        // Invalid operator, but only 2 digits - don't show error yet
        return null;
      }
      // Valid operator so far, still typing
      return null;
    }

    // More than 2 digits - validate operator
    if (phone.length > 2) {
      final secondDigit = phone[1];
      if (!_validOperators.contains(secondDigit)) {
        // Invalid operator and user continued typing
        return 'Invalid operator.';
      }
    }

    // Operator is valid (1[3-9]), user is typing remaining digits
    // Don't show "Invalid number" until they finish or try to submit
    // The button will remain disabled until exactly 10 digits
    
    // All validations passed or still typing valid input
    return null;
  }

  /// Checks if a phone number is valid (no error).
  static bool isValid(String input) {
    return validateBangladeshPhone(input) == null && input.trim().length == 10;
  }

  /// Sanitizes phone input by removing non-numeric characters.
  static String sanitize(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Normalizes pasted phone numbers.
  ///
  /// Handles:
  /// - +8801XXXXXXXXX → 1XXXXXXXXX
  /// - 01XXXXXXXXX → 1XXXXXXXXX
  /// - 8801XXXXXXXXX → 1XXXXXXXXX
  static String normalizePasted(String input) {
    String sanitized = sanitize(input);

    // Remove +880 prefix if present
    if (sanitized.startsWith('880')) {
      sanitized = sanitized.substring(3);
    }

    // Remove leading 0 if present (01XXXXXXXXX → 1XXXXXXXXX)
    if (sanitized.startsWith('0')) {
      sanitized = sanitized.substring(1);
    }

    // Limit to 10 digits
    if (sanitized.length > 10) {
      sanitized = sanitized.substring(0, 10);
    }

    return sanitized;
  }

  /// Formats phone number for backend (+880 prefix).
  static String formatForBackend(String input, {String countryCode = '+880'}) {
    final sanitized = sanitize(input);
    return '$countryCode$sanitized';
  }
}
