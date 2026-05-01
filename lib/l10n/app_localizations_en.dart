import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Delivery App';

  @override
  String get welcomeMessage => 'Welcome back!';

  @override
  String get loginButton => 'Login';

  @override
  String get authGatewayTitle => 'Delicious food, groceries & essentials delivered fast';

  @override
  String get continueWithPhone => 'Continue with Phone';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get phoneLoginTitle => 'Sign in with your mobile number';

  @override
  String get phoneInputHint => 'Phone Number';

  @override
  String get otpVerificationTitle => 'Enter the 6-digit code';

  @override
  String otpVerificationSubtitle(String phoneNumber) {
    return 'sent to $phoneNumber';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get changeNumber => 'Change Number';

  @override
  String get verify => 'Verify';

  @override
  String get invalidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get invalidOtp => 'Invalid OTP code. Please try again.';

  @override
  String get otpSentSuccess => 'OTP sent successfully';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logout => 'Logout';
}
