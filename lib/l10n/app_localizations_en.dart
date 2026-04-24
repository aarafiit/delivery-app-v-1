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
}
