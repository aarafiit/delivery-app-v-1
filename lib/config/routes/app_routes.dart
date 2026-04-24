/// Route path and name constants used throughout the app.
///
/// Centralising these prevents typos and makes refactoring easier.
class AppRoutes {
  AppRoutes._();

  // Paths
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  // Named route identifiers (mirrors the path without the leading slash)
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
}
