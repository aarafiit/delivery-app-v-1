import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/network/api_client_provider.dart';
import 'config/env/dev_config.dart';
import 'features/profile/presentation/providers/locale_provider.dart';
import 'features/profile/presentation/providers/theme_provider.dart';
import 'package:delivery_app/l10n/app_localizations.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        envConfigProvider.overrideWithValue(const DevConfig()),
      ],
      child: const DeliveryApp(),
    ),
  );
}

class DeliveryApp extends ConsumerWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = createAppRouter(ref);

    return MaterialApp.router(
      title: 'Delivery App (Dev)',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
