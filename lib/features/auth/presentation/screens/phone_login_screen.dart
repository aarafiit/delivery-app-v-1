import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/phone_validator.dart';
import '../../../../core/widgets/auth_gradient_background.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/phone_input_widget.dart';

/// Production-grade Phone Login Screen with Bangladesh number validation.
///
/// Features:
/// - Back button to Auth Gateway
/// - Fixed +880 country code
/// - 10-digit phone input (1[3-9]XXXXXXXX)
/// - Real-time validation with premium animated feedback
/// - Auto-enable Continue button on valid input
/// - Loading state during API call
/// - Error handling with snackbar
/// - Keyboard dismissal on tap outside
/// - Paste handling with normalization
///
/// Requirements: 29.1, 29.2, 29.3, 29.4, 29.5, 29.6, 29.7, 29.8, 37.1, 37.2, 38.3
class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final String _countryCode = '+880';
  bool _isPhoneValid = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// Handles validation state changes from PhoneInputWidget.
  void _onValidationChanged(bool isValid) {
    setState(() {
      _isPhoneValid = isValid;
    });
  }

  /// Handles country code selection.
  /// Currently only supports Bangladesh (+880).
  void _onCountryCodeTap() {
    // For now, only Bangladesh is supported
    // Future enhancement: show country picker dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Currently only Bangladesh (+880) is supported'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Handles the continue button tap.
  /// Requests OTP from the backend and navigates to OTP verification on success.
  /// Requirements: 29.4, 29.5, 29.6, 37.2
  Future<void> _onContinue() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Double-check validation
    if (!_isPhoneValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format phone number with country code using validator
      final phoneNumber = PhoneValidator.formatForBackend(
        _phoneController.text.trim(),
        countryCode: _countryCode,
      );

      // Call requestOtp use case
      await ref.read(authProvider.notifier).requestOtp(phoneNumber);

      // Navigate to OTP verification screen on success
      if (mounted) {
        context.pushNamed(
          AppRoutes.otpVerificationName,
          extra: phoneNumber,
        );
      }
    } on Failure catch (failure) {
      // Show error snackbar on failure
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(failure)),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Maps Failure types to user-friendly error messages.
  /// Requirements: 37.2
  String _getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is ServerFailure) {
      return failure.message;
    } else {
      return 'An error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return GestureDetector(
      // Dismiss keyboard when tapping outside input fields
      // Requirements: 38.3
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AuthGradientBackground(
          child: SafeArea(
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Semantics(
                      button: true,
                      label: 'Back',
                      hint: 'Return to authentication gateway',
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.goNamed(AppRoutes.authGatewayName),
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                      vertical: AppSpacing.lg,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.xxxl),
                        // Header
                        AuthHeaderWidget(
                          title: l10n.phoneLoginTitle,
                          subtitle: 'We\'ll send you a verification code',
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        // Phone input - direct placement, no white card
                        PhoneInputWidget(
                          controller: _phoneController,
                          countryCode: _countryCode,
                          onCountryCodeTap: _onCountryCodeTap,
                          onValidationChanged: _onValidationChanged,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        // Continue button with animated state
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          child: Semantics(
                            button: true,
                            label: 'Continue',
                            hint: 'Request OTP code for phone number',
                            enabled: _isPhoneValid && !_isLoading,
                            child: ElevatedButton(
                              onPressed: _isPhoneValid && !_isLoading
                                  ? _onContinue
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.navSelected,
                                foregroundColor: AppColors.textOnPrimary,
                                disabledBackgroundColor: AppColors.disabled,
                                disabledForegroundColor:
                                    AppColors.disabledText,
                                elevation: _isPhoneValid && !_isLoading ? 3 : 0,
                                shadowColor: AppColors.navSelected.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.lg,
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.textOnPrimary,
                                      ),
                                    )
                                  : Text(
                                      'Continue',
                                      style: AppTextStyles.button.copyWith(
                                        color: _isPhoneValid && !_isLoading
                                            ? AppColors.textOnPrimary
                                            : AppColors.disabledText,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
