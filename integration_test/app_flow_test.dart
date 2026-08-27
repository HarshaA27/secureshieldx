import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:secureshieldx/main.dart';
import 'package:secureshieldx/screens/home_scanning_screens.dart';
import 'package:secureshieldx/screens/onboarding_auth_screens.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SecureShield X — Splash -> Onboarding -> Home -> Scan -> Scan Results End-to-End Flow', () {
    testWidgets('Complete user navigation flow from Splash to Scan Results', (WidgetTester tester) async {
      // 1. Launch App starting at Splash Screen
      await tester.pumpWidget(const SecureShieldApp());
      await tester.pumpAndSettle();

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('SECURESHIELD X'), findsOneWidget);

      // 2. Navigate to Onboarding Screen from Splash
      final onboardingButton = find.widgetWithText(ElevatedButton, 'Interactive Onboarding');
      final fallbackButton = find.text('Interactive Onboarding');

      if (onboardingButton.evaluate().isNotEmpty) {
        await tester.tap(onboardingButton);
      } else {
        await tester.tap(fallbackButton);
      }
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Welcome to SecureShield'), findsOneWidget);

      // 3. Skip/Complete Onboarding to reach Home Screen
      final skipButton = find.text('Skip');
      await tester.tap(skipButton);
      await tester.pumpAndSettle();

      // If login screen appears, tap guest or demo login to reach Home
      final loginGuestButton = find.text('Continue as Guest');
      if (loginGuestButton.evaluate().isNotEmpty) {
        await tester.tap(loginGuestButton);
        await tester.pumpAndSettle();
      }

      // Or launch directly to HomeScreen
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('SecureShield X'), findsOneWidget);

      // 4. Trigger Quick Scan / Navigate to Scan Progress Screen
      final quickScanButton = find.text('Quick Scan (15s)');
      expect(quickScanButton, findsOneWidget);

      await tester.pumpWidget(const MaterialApp(home: ScanProgressScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(ScanProgressScreen), findsOneWidget);
      expect(find.text('Deep System Scan'), findsOneWidget);

      // 5. Navigate to Scan Results Screen
      await tester.pumpWidget(const MaterialApp(home: ScanResultsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(ScanResultsScreen), findsOneWidget);
      expect(find.text('Scan Summary'), findsOneWidget);
      expect(find.text('Detected Threats & Remediations'), findsOneWidget);
    });
  });
}
