import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secureshieldx/screens/home_scanning_screens.dart';

void main() {
  group('Home Dashboard Screen Widget Tests', () {
    Widget buildTestableWidget(Widget child) {
      return MaterialApp(
        home: child,
      );
    }

    testWidgets('Renders Home Dashboard main headers and title', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('SecureShield X'), findsOneWidget);
      expect(find.text('2026 AI Mobile Security Engine'), findsOneWidget);
    });

    testWidgets('Renders Security Score Hero Card and action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('/100'), findsOneWidget);
      expect(find.text('Quick Scan (15s)'), findsOneWidget);
      expect(find.text('Scan Results'), findsOneWidget);
    });

    testWidgets('Renders Security Management Hub items', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Security Management Hub'), findsOneWidget);
      expect(find.text('App Analysis'), findsOneWidget);
      expect(find.text('Permission Guard'), findsOneWidget);
      expect(find.text('AI Cyber Assistant'), findsOneWidget);
      expect(find.text('Cyber Fraud Portal'), findsOneWidget);
    });
  });
}
