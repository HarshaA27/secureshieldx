import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secureshieldx/core/models/app_models.dart';
import 'package:secureshieldx/core/widgets/risk_badge.dart';
import 'package:secureshieldx/screens/app_analysis_screens.dart';

void main() {
  group('App Details Screen Widget Tests', () {
    final testApp = InstalledAppModel(
      id: 'test_pkg_1',
      name: 'Test Security App',
      packageName: 'com.secureshield.testapp',
      version: '2.4.1',
      developer: 'Shield Security Labs',
      icon: Icons.shield_rounded,
      riskLevel: RiskLevel.critical,
      riskScore: 85,
      category: 'Security Utility',
      permissions: [
        AppPermissionModel(
          id: 'android.permission.RECEIVE_SMS',
          name: 'RECEIVE SMS',
          description: 'Allows background SMS reading',
          riskLevel: RiskLevel.critical,
          icon: Icons.sms_rounded,
          isGranted: true,
        ),
        AppPermissionModel(
          id: 'android.permission.CAMERA',
          name: 'CAMERA',
          description: 'Accesses real-time camera',
          riskLevel: RiskLevel.high,
          icon: Icons.camera_alt_rounded,
          isGranted: true,
        ),
      ],
      trackersCount: 8,
      networkUsage: '45.2 MB/day',
      threatDescription: 'High risk SMS intercepter behavior detected',
      installDate: DateTime.now(),
    );

    Widget buildTestableWidget(Widget child) {
      return MaterialApp(
        home: child,
      );
    }

    testWidgets('Renders App Details with app name, package and developer', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(AppDetailsScreen(selectedApp: testApp)));
      await tester.pumpAndSettle();

      expect(find.text('Test Security App'), findsWidgets);
      expect(find.textContaining('com.secureshield.testapp'), findsOneWidget);
      expect(find.textContaining('Shield Security Labs'), findsOneWidget);
    });

    testWidgets('Renders Risk Score and Permissions section', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(AppDetailsScreen(selectedApp: testApp)));
      await tester.pumpAndSettle();

      expect(find.textContaining('85/100'), findsOneWidget);
      expect(find.textContaining('Sensitive Permissions Audit'), findsOneWidget);
      expect(find.text('RECEIVE SMS'), findsOneWidget);
      expect(find.text('CAMERA'), findsOneWidget);
    });
  });
}
