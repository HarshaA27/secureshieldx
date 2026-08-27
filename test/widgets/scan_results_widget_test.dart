import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secureshieldx/screens/home_scanning_screens.dart';

void main() {
  group('Scan Results Screen Widget Tests', () {
    Widget buildTestableWidget(Widget child) {
      return MaterialApp(
        home: child,
      );
    }

    testWidgets('Renders Scan Summary app bar and action banner', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const ScanResultsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Scan Summary'), findsOneWidget);
      expect(find.textContaining('Action Required'), findsOneWidget);
    });

    testWidgets('Renders statistics breakdown grid labels', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const ScanResultsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Total Scanned'), findsOneWidget);
      expect(find.text('Safe Apps'), findsOneWidget);
      expect(find.text('Medium Risk'), findsOneWidget);
      expect(find.text('Critical'), findsOneWidget);
    });

    testWidgets('Renders Detected Threats section header', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const ScanResultsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Detected Threats & Remediations'), findsOneWidget);
    });
  });
}
