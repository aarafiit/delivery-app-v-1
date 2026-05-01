import 'app_localizations.dart';

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ডেলিভারি অ্যাপ';

  @override
  String get welcomeMessage => 'আবার স্বাগতম!';

  @override
  String get loginButton => 'লগইন';

  @override
  String get authGatewayTitle => 'সুস্বাদু খাবার, মুদি ও প্রয়োজনীয় জিনিস দ্রুত ডেলিভারি';

  @override
  String get continueWithPhone => 'ফোন দিয়ে চালিয়ে যান';

  @override
  String get continueAsGuest => 'অতিথি হিসেবে চালিয়ে যান';

  @override
  String get phoneLoginTitle => 'আপনার মোবাইল নম্বর দিয়ে সাইন ইন করুন';

  @override
  String get phoneInputHint => 'ফোন নম্বর';

  @override
  String get otpVerificationTitle => '৬-সংখ্যার কোড লিখুন';

  @override
  String otpVerificationSubtitle(String phoneNumber) {
    return '$phoneNumber এ পাঠানো হয়েছে';
  }

  @override
  String get resendOtp => 'OTP পুনরায় পাঠান';

  @override
  String get changeNumber => 'নম্বর পরিবর্তন করুন';

  @override
  String get verify => 'যাচাই করুন';

  @override
  String get invalidPhoneNumber => 'অনুগ্রহ করে একটি বৈধ ফোন নম্বর লিখুন';

  @override
  String get invalidOtp => 'ভুল OTP কোড। আবার চেষ্টা করুন।';

  @override
  String get otpSentSuccess => 'OTP সফলভাবে পাঠানো হয়েছে';

  @override
  String get logoutConfirmTitle => 'লগআউট';

  @override
  String get logoutConfirmMessage => 'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get logout => 'লগআউট';
}
