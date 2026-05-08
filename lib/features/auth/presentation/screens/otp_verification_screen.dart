import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/auth_gradient_background.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/providers/pending_cart_item_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_redirect_provider.dart';
import '../widgets/otp_input_widget.dart';

/// OTP Verification Screen
/// 
/// Allows users to enter the 6-digit OTP code sent to their phone number.
/// Features:
/// - 6-digit OTP input with auto-focus and auto-advance
/// - Countdown timer (60 seconds)
/// - Resend OTP button (enabled after countdown)
/// - Change Number link
/// - Auto-submit when all 6 digits entered
/// - Error handling with dialog
/// - Post-verification navigation with redirect support
/// 
/// Requirements: 30.1, 30.2, 30.4, 30.5, 30.6, 30.7, 30.8, 30.9, 30.10, 
///               30.11, 30.12, 30.13, 30.14, 37.3, 37.5, 37.6, 27.7
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _otpCode = '';
  bool _isLoading = false;
  bool _isVerifying = false; // Prevent concurrent verification attempts
  Timer? _countdownTimer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// Starts the countdown timer for OTP resend.
  /// Requirements: 30.5, 30.6, 37.5
  void _startCountdown() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  /// Handles OTP code changes from the input widget.
  /// Auto-submits when all 6 digits are entered.
  /// Requirements: 30.4
  void _onOtpChanged(String otp) {
    setState(() {
      _otpCode = otp;
    });

    // Auto-submit when all 6 digits are entered
    // Check _isVerifying to prevent double API calls
    if (otp.length == 6 && !_isVerifying) {
      _verifyOtp();
    }
  }

  /// Verifies the OTP code with the backend.
  /// Shows loading state, handles errors with dialog, and navigates on success.
  /// Requirements: 30.9, 30.10, 30.13, 37.3
  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6) return;
    
    // Prevent concurrent verification attempts
    if (_isVerifying) return;

    final l10n = AppLocalizations.of(context);

    setState(() {
      _isLoading = true;
      _isVerifying = true;
    });

    bool verificationSucceeded = false;

    try {
      await ref.read(authProvider.notifier).verifyOtp(
            widget.phoneNumber,
            _otpCode,
          );

      verificationSucceeded = true;

      if (!mounted) return;

      // Navigate after successful verification
      await _navigateAfterVerification();
    } on Failure catch (failure) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isVerifying = false;
        _otpCode = ''; // Clear OTP input on error
      });

      // Show error dialog
      await AppDialog.showErrorDialog(
        context: context,
        title: 'Verification Failed',
        message: ErrorHandler.toUserMessage(failure),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isVerifying = false;
        _otpCode = ''; // Clear OTP input on error
      });

      // Show generic error dialog
      await AppDialog.showErrorDialog(
        context: context,
        title: 'Verification Failed',
        message: l10n.invalidOtp,
      );
    }

    // Ensure we don't navigate if verification failed
    if (!verificationSucceeded) {
      return;
    }
  }

  /// Navigates to the appropriate screen after successful verification.
  /// Checks for pending cart items and adds them to cart if present.
  /// Checks for intended route in authRedirectProvider and navigates there,
  /// otherwise navigates to Home.
  /// Requirements: 30.11, 30.12, 27.7, 40.4, 40.5, JWT Auth Upgrade Phase 5
  Future<void> _navigateAfterVerification() async {
    // Check if user is new
    final authState = ref.read(authProvider).value;
    final isNewUser = authState?.user?.isNewUser ?? false;
    
    if (isNewUser) {
      // Navigate to complete profile screen for new users
      if (!mounted) return;
      context.goNamed(AppRoutes.completeProfileName);
      return;
    }
    
    // Check for pending cart item
    final pendingProduct = ref.read(pendingCartItemProvider);
    
    if (pendingProduct != null) {
      // Add the pending product to cart
      await ref.read(cartProvider.notifier).addItem(
            productId: pendingProduct.id,
            name: pendingProduct.name,
            imageUrl: pendingProduct.imageUrl,
            price: pendingProduct.price,
            discountPrice: pendingProduct.discountPrice,
            quantity: 1,
          );
      
      // Clear the pending item
      ref.read(pendingCartItemProvider.notifier).state = null;
      
      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${pendingProduct.name} to cart'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    
    // Navigate to intended route or home
    final intendedRoute = ref
        .read(authRedirectProvider.notifier)
        .getAndClearIntendedRoute();

    if (!mounted) return;
    if (intendedRoute != null) {
      context.go(intendedRoute);
    } else {
      context.goNamed(AppRoutes.homeName);
    }
  }

  /// Resends the OTP by calling requestOtp again.
  /// Shows success snackbar and restarts countdown.
  /// Requirements: 30.7, 37.6
  Future<void> _resendOtp() async {
    if (!_canResend) return;

    final l10n = AppLocalizations.of(context);

    try {
      await ref.read(authProvider.notifier).requestOtp(widget.phoneNumber);

      if (!mounted) return;

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.otpSentSuccess),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Restart countdown
      _startCountdown();
    } on Failure catch (failure) {
      if (!mounted) return;

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ErrorHandler.toUserMessage(failure)),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Navigates back to Phone Login Screen.
  /// Requirements: 30.8
  void _changeNumber() {
    context.pop();
  }

  /// Formats the countdown timer display.
  String _formatCountdown() {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Masks the phone number for display (e.g., +880 1700-***000).
  String _maskPhoneNumber() {
    if (widget.phoneNumber.length < 10) return widget.phoneNumber;
    
    final countryCode = widget.phoneNumber.substring(0, 4); // +880
    final firstPart = widget.phoneNumber.substring(4, 8); // 1700
    final lastPart = widget.phoneNumber.substring(widget.phoneNumber.length - 3); // last 3 digits
    
    return '$countryCode $firstPart-***$lastPart';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return GestureDetector(
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
                      hint: 'Return to phone login screen',
                      enabled: !_isLoading,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                        onPressed: _isLoading ? null : () => context.pop(),
                      ),
                    ),
                  ),
                ),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                      vertical: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.xxxl),
                        // Title
                        Text(
                          l10n.otpVerificationTitle,
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Subtitle with phone number
                        Text(
                          l10n.otpVerificationSubtitle(_maskPhoneNumber()),
                          style: AppTextStyles.bodySecondary.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxxl),

                        // OTP Input in white container
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: OtpInputWidget(
                            onCompleted: _onOtpChanged,
                            onChanged: _onOtpChanged,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // Countdown timer and resend button
                        if (!_canResend)
                          Semantics(
                            label: 'Resend code timer',
                            value: 'Resend code in ${_formatCountdown()}',
                            child: Text(
                              'Resend code in ${_formatCountdown()}',
                              style: AppTextStyles.bodySecondary.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          Center(
                            child: Semantics(
                              button: true,
                              label: 'Resend OTP',
                              hint: 'Request a new verification code',
                              enabled: !_isLoading,
                              child: TextButton(
                                onPressed: _isLoading ? null : _resendOtp,
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xl,
                                    vertical: AppSpacing.md,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  l10n.resendOtp,
                                  style: AppTextStyles.buttonSmall.copyWith(
                                    color: AppColors.authPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: AppSpacing.md),

                        // Change number link
                        Center(
                          child: Semantics(
                            button: true,
                            label: 'Change number',
                            hint: 'Go back to enter a different phone number',
                            enabled: !_isLoading,
                            child: TextButton(
                              onPressed: _isLoading ? null : _changeNumber,
                              child: Text(
                                l10n.changeNumber,
                                style: AppTextStyles.buttonSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),

                        // Verify button
                        AppButton(
                          label: l10n.verify,
                          onPressed: _otpCode.length == 6 && !_isLoading
                              ? _verifyOtp
                              : null,
                          isLoading: _isLoading,
                          variant: AppButtonVariant.primary,
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
