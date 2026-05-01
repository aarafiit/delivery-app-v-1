import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Reusable 6-digit OTP input widget with auto-focus and auto-advance.
///
/// Features:
/// - 6 individual input boxes for each digit
/// - Auto-focus on first box when widget loads
/// - Auto-advance to next box when digit is entered
/// - Backspace support to move to previous box
/// - Calls onCompleted when all 6 digits are entered
/// - Numeric keyboard
///
/// Requirements: 30.1, 30.2, 30.3, 30.4, 38.2, 38.4, 38.5
class OtpInputWidget extends StatefulWidget {
  const OtpInputWidget({
    super.key,
    required this.onCompleted,
    required this.onChanged,
  });

  /// Callback when all 6 digits are entered
  final Function(String) onCompleted;

  /// Callback when any digit changes
  final Function(String) onChanged;

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  // Controllers for each OTP box
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  // Focus nodes for each OTP box
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    // Auto-focus first box on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Get the complete OTP code from all controllers
  String _getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  /// Handle text change in a specific box
  void _onChanged(int index, String value) {
    // Notify parent of change
    widget.onChanged(_getOtpCode());

    if (value.isNotEmpty) {
      // Move to next box if not the last one
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last box - unfocus and check if complete
        _focusNodes[index].unfocus();
        final otpCode = _getOtpCode();
        if (otpCode.length == 6) {
          widget.onCompleted(otpCode);
        }
      }
    }
  }

  /// Handle backspace/delete key
  void _onBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      // Move to previous box if current is empty
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'OTP verification code input',
      hint: 'Enter the 6-digit code sent to your phone',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index < 5 ? AppSpacing.sm : 0,
              ),
              child: Semantics(
                textField: true,
                label: 'Digit ${index + 1}',
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: AppTextStyles.heading2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: '', // Hide character counter
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: AppRadius.smAll,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.smAll,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.smAll,
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length > 1) {
                      // Handle paste - take only first character
                      _controllers[index].text = value[0];
                      _controllers[index].selection = TextSelection.fromPosition(
                        const TextPosition(offset: 1),
                      );
                    }
                    
                    // Handle backspace - move to previous box if empty
                    if (value.isEmpty) {
                      _onBackspace(index);
                    }
                    
                    _onChanged(index, _controllers[index].text);
                  },
                  onTap: () {
                    // Select all text when tapped for easy replacement
                    _controllers[index].selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _controllers[index].text.length,
                    );
                  },
                  onEditingComplete: () {
                    // Handle "Done" button on keyboard
                    if (index < 5) {
                      _focusNodes[index + 1].requestFocus();
                    }
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
