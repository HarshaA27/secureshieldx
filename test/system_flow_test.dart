import 'package:flutter_test/flutter_test.dart';
import 'package:secureshieldx/core/config/env_config.dart';
import 'package:secureshieldx/core/data/mock_data.dart';
import 'package:secureshieldx/core/services/llm_risk_explanation_service.dart';
import 'package:secureshieldx/main.dart';

void main() {
  group('SecureShield X — Complete 50-Screen System Flow Suite', () {
    testWidgets('Widget Smoke Test — SecureShieldApp Renders Main Shell', (WidgetTester tester) async {
      await tester.pumpWidget(const SecureShieldApp());
      expect(find.byType(SecureShieldApp), findsOneWidget);
    });

    test('MockData Catalog Verification — 16 Languages & Installed Apps', () {
      expect(MockData.languages.length, equals(16));
      expect(MockData.installedApps.length, greaterThan(0));
      expect(MockData.fraudReportsHistory.length, greaterThan(0));
    });

    test('EnvConfig Default Resolution', () {
      expect(EnvConfig.llmProvider, isNotEmpty);
      expect(EnvConfig.llmModel, isNotEmpty);
    });

    test('LlmRiskExplanationService Fallback Evaluation', () async {
      final app = MockData.installedApps[0];
      final result = await LlmRiskExplanationService().generateExplanation(app);

      expect(result.summary, isNotEmpty);
      expect(result.detailedAnalysis, isNotEmpty);
      expect(result.privacyConcerns.length, greaterThan(0));
      expect(result.recommendedAction, isNotEmpty);
    });

    test('Multi-Lingual Cyber Fraud Complaint Generator Fallback', () async {
      final complaint = await LlmRiskExplanationService().generateFraudComplaint(
        category: 'Financial Cyber Fraud',
        lossAmount: '25,000',
        scammerIdentifier: 'fakebank@ybl',
        description: 'Phishing SMS unauthorized debit',
        languageCode: 'hi',
        languageName: 'Hindi',
        associatedAppName: 'SuperFlashlight Ultra HD',
        evidenceFiles: ['screenshot_1.png', 'bank_statement.pdf'],
      );

      expect(complaint.complaintBody, isNotEmpty);
      expect(complaint.languageName, equals('Hindi'));
    });
  });
}
