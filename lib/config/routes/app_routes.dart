/// Route path and name constants used throughout the app.
///
/// Centralising these prevents typos and makes refactoring easier.
class AppRoutes {
  AppRoutes._();

  // Paths
  static const String splash = '/splash';
  static const String login = '/login';
  static const String authGateway = '/auth-gateway';
  static const String phoneLogin = '/phone-login';
  static const String otpVerification = '/otp-verification';
  static const String completeProfile = '/complete-profile';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String savedAddresses = '/profile/saved-addresses';
  static const String helpSupport = '/profile/help-support';

  // Named route identifiers (mirrors the path without the leading slash)
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String authGatewayName = 'authGateway';
  static const String phoneLoginName = 'phoneLogin';
  static const String otpVerificationName = 'otpVerification';
  static const String completeProfileName = 'completeProfile';
  static const String homeName = 'home';
  static const String profileName = 'profile';
  static const String editProfileName = 'editProfile';
  static const String savedAddressesName = 'savedAddresses';
  static const String helpSupportName = 'helpSupport';
  static const String productDetailsName = 'productDetails';
  static const String cartDetailName = 'cartDetail';
  static const String checkoutName = 'checkout';
}
