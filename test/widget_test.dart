import 'package:flutter_test/flutter_test.dart';
import 'package:secureshieldx/main.dart';


void main() {
  testWidgets('SecureShieldApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SecureShieldApp());
    expect(find.byType(SecureShieldApp), findsOneWidget);
  });
}

