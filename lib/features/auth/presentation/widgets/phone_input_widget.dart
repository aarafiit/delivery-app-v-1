import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils/phone_validator.dart';
import 'validation_pill_widget.dart';

/// Production-grade Bangladesh phone number input widget.
///
/// Features:
/// - Fixed +880 country code
/// - 10-digit input validation (1[3-9]XXXXXXXX)
/// - Real-time validation with premium animated feedback
/// - Operator validation (must start with 1[3-9])
/// - Length validation (exactly 10 digits)
/// - Paste handling with normalization
/// - Numeric keyboard only
/// - Auto-enable continue button on valid input
///
/// Requirements: 29.2, 29.3, 38.1
class PhoneInputWidget extends StatefulWidget {
  const PhoneInputWidget({
    super.key,
    required this.controller,
    required this.countryCode,
    required this.onCountryCodeTap,
    required this.onValidationChanged,
    this.enabled = true,
  });

  /// Controller for the phone number text field
  final TextEditingController controller;

  /// Country code to display (e.g., "+880")
  final String countryCode;

  /// Callback when country code button is tapped
  final VoidCallback onCountryCodeTap;

  /// Callback when validation state changes
  final ValueChanged<bool> onValidationChanged;

  /// Whether the input is enabled
  final bool enabled;

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  String? _validationMessage;
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    // Listen to text changes for real-time validation
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  /// Handles text changes and validates in real-time.
  void _onTextChanged() {
    final text = widget.controller.text;
    final validationError = PhoneValidator.validateBangladeshPhone(text);
    final isValid = PhoneValidator.isValid(text);

    setState(() {
      _validationMessage = validationError;
      // Only show validation if there's an actual error (not null)
      _showValidation = validationError != null;
    });

    // Notify parent of validation state change
    widget.onValidationChanged(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.enabled
                ? AppColors.surfaceVariant
                : AppColors.disabled.withOpacity(0.3),
            borderRadius: AppRadius.smAll,
            border: _showValidation
                ? Border.all(
                    color: _validationMessage == 'Invalid operator.'
                        ? Colors.amber.shade300
                        : Colors.red.shade300,
                    width: 1.5,
                  )
                : null,
          ),
          child: Row(
            children: [
              // Country code selector button
              Semantics(
                button: true,
                label: 'Country code selector',
                value: widget.countryCode,
                hint: 'Tap to change country code',
                enabled: widget.enabled,
                child: InkWell(
                  onTap: widget.enabled ? widget.onCountryCodeTap : null,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.sm),
                    bottomLeft: Radius.circular(AppRadius.sm),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md + 2,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: AppColors.divider,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.countryCode,
                          style: AppTextStyles.body.copyWith(
                            color: widget.enabled
                                ? AppColors.textPrimary
                                : AppColors.disabledText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: widget.enabled
                              ? AppColors.textSecondary
                              : AppColors.disabledText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Phone number input field
              Expanded(
                child: Semantics(
                  textField: true,
                  label: 'Phone number',
                  hint: 'Enter 10-digit phone number starting with 1',
                  enabled: widget.enabled,
                  child: TextField(
                    controller: widget.controller,
                    enabled: widget.enabled,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                      _PhoneNumberFormatter(),
                    ],
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    decoration: InputDecoration(
                      hintText: '1XXXXXXXXX',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.textHint,
                        letterSpacing: 0.5,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Premium animated validation pill
        ValidationPillWidget(
          message: _validationMessage,
          isVisible: _showValidation,
        ),
      ],
    );
  }
}

/// Custom text input formatter for phone number paste handling.
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Handle paste - normalize the input
    if (newValue.text.length > oldValue.text.length + 1) {
      // Likely a paste operation
      final normalized = PhoneValidator.normalizePasted(newValue.text);
      return TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
    }

    return newValue;
  }
}
