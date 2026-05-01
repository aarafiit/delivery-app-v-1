import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:delivery_app/features/auth/presentation/screens/auth_gateway_screen.dart';
import 'package:delivery_app/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:delivery_app/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:delivery_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Tests to verify that auth screens handle system font scaling properly.
/// 
/// Requirements: 39.5
void main() {
  group('Auth Screens Text Scaling Tests', () {
    Widget createTestWidget(Widget child, {double textScaleFactor = 1.0}) {
      return ProviderScope(
        child: MediaQuery(
          data: MediaQueryData(textScaleFactor: textScaleFactor),
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('bn'),
            ],
            home: child,
          ),
        ),
      );
    }

    testWidgets('AuthGatewayScreen renders correctly with 1.0x text scale',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        const AuthGatewayScreen(),
        textScaleFactor: 1.0,
      ));

      // Verify screen renders without overflow
      expect(find.byType(AuthGatewayScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AuthGatewayScreen renders correctly with 2.0x text scale',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        const AuthGatewayScreen(),
        textScaleFactor: 2.0,
      ));

      // Verify screen renders without overflow
      expect(find.byType(AuthGatewayScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('PhoneLoginScreen renders correctly with 1.0x text scale',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        const PhoneLoginScreen(),
        textScaleFactor: 1.0,
      ));

      // Verify screen renders without overflow
      expect(find.byType(PhoneLoginScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('PhoneLoginScreen renders correctly with 2.0x text scale',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        const PhoneLoginScreen(),
        textScaleFactor: 2.0,
      ));

      // Verify screen renders without overflow
      expect(find.byType(PhoneLoginScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('OtpVerificationScreen renders correctly with 1.0x text scale',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        const OtpVerificationScreen(phoneNumber: '+8801700000000'),
        textScaleFactor: 1.0,
      ));

      // Verify screen renders without overflow
      expect(find.byType(OtpVerificationScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('OtpVerificationScreen renders correctly with 2.0x text scale',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        const OtpVerificationScreen(phoneNumber: '+8801700000000'),
        textScaleFactor: 2.0,
      ));

      // Verify screen renders without overflow
      expect(find.byType(OtpVerificationScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AuthGatewayScreen text scales proportionally',
        (WidgetTester tester) async {
      // Test with 1.0x scale
      await tester.pumpWidget(createTestWidget(
        const AuthGatewayScreen(),
        textScaleFactor: 1.0,
      ));
      await tester.pumpAndSettle();

      // Find a text widget to measure
      final textFinder = find.text('Continue with Phone');
      expect(textFinder, findsOneWidget);

      final text1x = tester.widget<Text>(textFinder);
      final size1x = tester.getSize(textFinder);

      // Test with 1.5x scale
      await tester.pumpWidget(createTestWidget(
        const AuthGatewayScreen(),
        textScaleFactor: 1.5,
      ));
      await tester.pumpAndSettle();

      final text15x = tester.widget<Text>(textFinder);
      final size15x = tester.getSize(textFinder);

      // Verify text scales (size should increase)
      expect(size15x.width, greaterThan(size1x.width));
    });

    testWidgets('PhoneLoginScreen handles large text without overflow',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        const PhoneLoginScreen(),
        textScaleFactor: 3.0, // Very large text
      ));
      await tester.pumpAndSettle();

      // Verify no overflow errors
      expect(tester.takeException(), isNull);
      expect(find.byType(PhoneLoginScreen), findsOneWidget);
    });

    testWidgets('OtpVerificationScreen handles large text without overflow',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        const OtpVerificationScreen(phoneNumber: '+8801700000000'),
        textScaleFactor: 3.0, // Very large text
      ));
      await tester.pumpAndSettle();

      // Verify no overflow errors
      expect(tester.takeException(), isNull);
      expect(find.byType(OtpVerificationScreen), findsOneWidget);
    });
  });
}
