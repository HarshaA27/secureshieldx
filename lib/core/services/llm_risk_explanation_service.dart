import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';
import '../models/app_models.dart';
import '../widgets/risk_badge.dart';

class LlmRiskExplanationResult {
  final String summary;
  final String detailedAnalysis;
  final List<String> privacyConcerns;
  final String recommendedAction;
  final bool isLiveLlmGenerated;
  final String modelUsed;
  final DateTime generatedAt;
  final String? errorMessage;

  const LlmRiskExplanationResult({
    required this.summary,
    required this.detailedAnalysis,
    required this.privacyConcerns,
    required this.recommendedAction,
    required this.isLiveLlmGenerated,
    required this.modelUsed,
    required this.generatedAt,
    this.errorMessage,
  });
}

class FraudComplaintResult {
  final String complaintBody;
  final bool isLiveLlmGenerated;
  final String modelUsed;
  final String languageName;
  final String? errorMessage;

  const FraudComplaintResult({
    required this.complaintBody,
    required this.isLiveLlmGenerated,
    required this.modelUsed,
    required this.languageName,
    this.errorMessage,
  });
}

class LlmRiskExplanationService {
  static final LlmRiskExplanationService _instance = LlmRiskExplanationService._internal();
  factory LlmRiskExplanationService() => _instance;
  LlmRiskExplanationService._internal();

  final Map<String, LlmRiskExplanationResult> _cache = {};

  /// Generates dynamic contextual risk explanation using real LLM API HTTP call
  Future<LlmRiskExplanationResult> generateExplanation(
    InstalledAppModel app, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${app.packageName}_${EnvConfig.llmApiKey.hashCode}';
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Fallback if no API key is provided
    if (!EnvConfig.hasApiKey) {
      final fallback = _generateLocalHeuristicFallback(
        app,
        notice: 'No LLM API Key detected. Add LLM_API_KEY in .env or via --dart-define=LLM_API_KEY=your_key to activate live LLM explanations.',
      );
      _cache[cacheKey] = fallback;
      return fallback;
    }

    try {
      final provider = EnvConfig.llmProvider.toLowerCase();
      LlmRiskExplanationResult result;

      if (provider == 'openai') {
        result = await _callOpenAiApi(app);
      } else {
        result = await _callGeminiApi(app);
      }

      _cache[cacheKey] = result;
      return result;
    } catch (e, stack) {
      debugPrint('LLM API Error for ${app.name}: $e\n$stack');
      final fallback = _generateLocalHeuristicFallback(
        app,
        notice: 'LLM API Request failed: $e. Displaying offline heuristic breakdown.',
        error: e.toString(),
      );
      return fallback;
    }
  }

  /// Generates multi-lingual formal legal cyber crime complaint draft using real LLM API HTTP call
  Future<FraudComplaintResult> generateFraudComplaint({
    required String category,
    required String lossAmount,
    required String scammerIdentifier,
    required String description,
    required String languageCode,
    required String languageName,
    String? associatedAppName,
    List<String>? evidenceFiles,
  }) async {
    if (!EnvConfig.hasApiKey) {
      return _generateLocalComplaintFallback(
        category: category,
        lossAmount: lossAmount,
        scammerIdentifier: scammerIdentifier,
        description: description,
        languageName: languageName,
        notice: 'No LLM_API_KEY set. Showing template complaint. Set LLM_API_KEY in .env to generate live AI complaints in any language.',
      );
    }

    try {
      final provider = EnvConfig.llmProvider.toLowerCase();
      final model = EnvConfig.llmModel;
      final promptText = _buildFraudComplaintPrompt(
        category: category,
        lossAmount: lossAmount,
        scammerIdentifier: scammerIdentifier,
        description: description,
        languageCode: languageCode,
        languageName: languageName,
        associatedAppName: associatedAppName,
        evidenceFiles: evidenceFiles,
      );

      String rawResponseText = '';
      if (provider == 'openai') {
        final apiKey = EnvConfig.llmApiKey;
        final openAiModel = model.contains('gemini') ? 'gpt-4o-mini' : model;
        final url = Uri.parse('https://api.openai.com/v1/chat/completions');

        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': openAiModel,
            'messages': [
              {
                'role': 'system',
                'content': 'You are a senior cybercrime legal drafting AI assistant. Write clear, professional legal complaint letters.'
              },
              {'role': 'user', 'content': promptText}
            ],
            'temperature': 0.3,
          }),
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
          final choices = jsonResponse['choices'] as List<dynamic>?;
          if (choices != null && choices.isNotEmpty) {
            rawResponseText = choices[0]['message']['content'] as String? ?? '';
          }
        } else {
          throw Exception('OpenAI API HTTP ${response.statusCode}: ${response.body}');
        }
      } else {
        // Gemini REST API
        final apiKey = EnvConfig.llmApiKey;
        final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': promptText}
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.3,
              'maxOutputTokens': 800,
            }
          }),
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
          final candidates = jsonResponse['candidates'] as List<dynamic>?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]['content']['parts'] as List<dynamic>?;
            if (parts != null && parts.isNotEmpty) {
              rawResponseText = parts[0]['text'] as String? ?? '';
            }
          }
        } else {
          throw Exception('Gemini API HTTP ${response.statusCode}: ${response.body}');
        }
      }

      if (rawResponseText.isNotEmpty) {
        return FraudComplaintResult(
          complaintBody: rawResponseText.trim(),
          isLiveLlmGenerated: true,
          modelUsed: model,
          languageName: languageName,
        );
      } else {
        throw Exception('Received empty text from LLM response.');
      }
    } catch (e) {
      debugPrint('Fraud Complaint LLM Error: $e');
      return _generateLocalComplaintFallback(
        category: category,
        lossAmount: lossAmount,
        scammerIdentifier: scammerIdentifier,
        description: description,
        languageName: languageName,
        notice: 'LLM Error: $e. Falling back to template complaint.',
        error: e.toString(),
      );
    }
  }

  String _buildFraudComplaintPrompt({
    required String category,
    required String lossAmount,
    required String scammerIdentifier,
    required String description,
    required String languageCode,
    required String languageName,
    String? associatedAppName,
    List<String>? evidenceFiles,
  }) {
    final todayStr = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    final evidenceText = evidenceFiles != null && evidenceFiles.isNotEmpty
        ? evidenceFiles.join(', ')
        : 'Digital screenshots, bank transaction receipts, and call logs attached.';

    return '''Draft a formal legal cybercrime complaint letter addressed to the Station House Officer / Cyber Crime Cell / National Cyber Crime Reporting Portal (NCRP).

CRITICAL REQUIREMENT: Write the complete complaint in $languageName ($languageCode).

Incident Details:
- Complaint Date: $todayStr
- Crime Category: $category
- Financial Loss: ₹$lossAmount INR
- Suspect / Scammer Identifier: $scammerIdentifier
${associatedAppName != null ? '- Malicious Application Involved: $associatedAppName' : ''}
- Brief Incident Narrative: $description
- Attached Evidence Vault Files: $evidenceText

Format Requirements:
1. Formal Addressee (To the Officer in Charge, Cyber Crime Portal)
2. Clear Subject line stating the crime category, financial loss, and date
3. Structured numbered incident facts detailing chronological events
4. Formal request under Information Technology Act 2000 (Sec 43, 66D, 66C) to freeze suspect accounts/VPA and issue official FIR reference.
5. Professional closing with applicant signature block.

Return ONLY the complete formal complaint letter text without extra preamble or conversational text.''';
  }

  FraudComplaintResult _generateLocalComplaintFallback({
    required String category,
    required String lossAmount,
    required String scammerIdentifier,
    required String description,
    required String languageName,
    required String notice,
    String? error,
  }) {
    final todayStr = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    final body = '''TO THE OFFICER IN CHARGE,
NATIONAL CYBER CRIME REPORTING PORTAL (NCRP) / CYBER CRIME CELL

SUBJECT: FORMAL COMPLAINT REGARDING $category (LOSS AMOUNT: ₹$lossAmount INR)

Respected Sir/Madam,

I am submitting this formal cyber crime complaint regarding an incident occurring on $todayStr.

INCIDENT SUMMARY:
1. Category: $category
2. Financial Loss: ₹$lossAmount INR
3. Offender / Scammer Identifier: $scammerIdentifier
4. Incident Description: $description

EVIDENCE ATTACHED:
- Digital evidence screenshots, bank statement transaction logs, and phone record logs.

REQUESTED ACTION:
I request immediate freezing of suspect beneficiary accounts under Sec 43/66D IT Act 2000 and registration of FIR.

Yours faithfully,
Verified SecureShield X User
[System Note]: $notice''';

    return FraudComplaintResult(
      complaintBody: body,
      isLiveLlmGenerated: false,
      modelUsed: 'Local Heuristic Template',
      languageName: languageName,
      errorMessage: error,
    );
  }

  /// Simple HTTP REST API POST call for Google Gemini API
  Future<LlmRiskExplanationResult> _callGeminiApi(InstalledAppModel app) async {
    final apiKey = EnvConfig.llmApiKey;
    final model = EnvConfig.llmModel;
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
    );

    final promptText = _buildPrompt(app);

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': promptText}
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.3,
              'maxOutputTokens': 500,
              'responseMimeType': 'application/json',
            }
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final candidates = jsonResponse['candidates'] as List<dynamic>?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List<dynamic>?;
        if (parts != null && parts.isNotEmpty) {
          final String rawText = parts[0]['text'] ?? '';
          return _parseLlmJsonResponse(rawText, app, model);
        }
      }
      throw Exception('Empty candidates in Gemini response.');
    } else {
      final errBody = response.body;
      throw Exception('Gemini API HTTP ${response.statusCode}: $errBody');
    }
  }

  /// Simple HTTP REST API POST call for OpenAI / OpenAI-compatible API
  Future<LlmRiskExplanationResult> _callOpenAiApi(InstalledAppModel app) async {
    final apiKey = EnvConfig.llmApiKey;
    final model = EnvConfig.llmModel.contains('gemini') ? 'gpt-4o-mini' : EnvConfig.llmModel;
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final promptText = _buildPrompt(app);

    final response = await http
        .post(
          url,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': model,
            'messages': [
              {
                'role': 'system',
                'content':
                    'You are an expert mobile cybersecurity AI analyzer. Output valid JSON with keys: "summary", "detailedAnalysis", "privacyConcerns" (array of strings), "recommendedAction".'
              },
              {'role': 'user', 'content': promptText}
            ],
            'response_format': {'type': 'json_object'},
            'temperature': 0.3,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final choices = jsonResponse['choices'] as List<dynamic>?;
      if (choices != null && choices.isNotEmpty) {
        final rawText = choices[0]['message']['content'] as String? ?? '';
        return _parseLlmJsonResponse(rawText, app, model);
      }
      throw Exception('Empty choices in OpenAI response.');
    } else {
      throw Exception('OpenAI API HTTP ${response.statusCode}: ${response.body}');
    }
  }

  /// Constructs concise cybersecurity analysis prompt for the LLM
  String _buildPrompt(InstalledAppModel app) {
    final permList = app.permissions
        .map((p) => '${p.name} [${p.riskLevel.name.toUpperCase()}]: ${p.description}')
        .join('; ');

    return '''Analyze the mobile cybersecurity risk for this scanned application and generate a structured JSON analysis:

App Name: ${app.name}
Package: ${app.packageName}
Developer: ${app.developer}
Category: ${app.category}
Assessed Risk Level: ${app.riskLevel.name.toUpperCase()} (Score: ${app.riskScore}/100)
Third-Party Analytics Trackers: ${app.trackersCount}
Network Traffic Volume: ${app.networkUsage}
Declared Permissions: ${permList.isEmpty ? 'Standard non-sensitive permissions' : permList}

Respond strictly in valid JSON with these keys:
{
  "summary": "1-2 sentence executive threat summary tailored to this app and permissions",
  "detailedAnalysis": "Detailed 2-3 paragraph explanation of security risks, telemetry, potential data leaks or privacy impact",
  "privacyConcerns": ["Concern 1", "Concern 2", "Concern 3"],
  "recommendedAction": "Clear advice for user (e.g. revoke specific permissions, quarantine, or retain safely)"
}''';
  }

  /// Parses LLM JSON output string into LlmRiskExplanationResult model
  LlmRiskExplanationResult _parseLlmJsonResponse(String rawText, InstalledAppModel app, String model) {
    try {
      // Clean possible markdown code fences (```json ... ```)
      String cleaned = rawText.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.substring(7);
      } else if (cleaned.startsWith('```')) {
        cleaned = cleaned.substring(3);
      }
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3);
      }
      cleaned = cleaned.trim();

      final parsed = jsonDecode(cleaned) as Map<String, dynamic>;
      final summary = parsed['summary'] as String? ?? app.threatDescription;
      final detailed = parsed['detailedAnalysis'] as String? ?? summary;
      final rawConcerns = parsed['privacyConcerns'] as List<dynamic>? ?? [];
      final concerns = rawConcerns.map((e) => e.toString()).toList();
      final action = parsed['recommendedAction'] as String? ?? 'Review permissions in settings.';

      return LlmRiskExplanationResult(
        summary: summary,
        detailedAnalysis: detailed,
        privacyConcerns: concerns.isNotEmpty ? concerns : ['Background permission utilization'],
        recommendedAction: action,
        isLiveLlmGenerated: true,
        modelUsed: model,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('JSON parsing failed for LLM response: $e. Raw text was: $rawText');
      return _generateLocalHeuristicFallback(
        app,
        notice: 'LLM returned unstructured response. Displaying heuristic analysis.',
      );
    }
  }

  /// Generates dynamic local heuristic fallback when API key is missing or network fails
  LlmRiskExplanationResult _generateLocalHeuristicFallback(
    InstalledAppModel app, {
    required String notice,
    String? error,
  }) {
    List<String> concerns = [];
    String action = 'Keep app updated and monitor permission grants in system settings.';

    if (app.riskLevel == RiskLevel.critical) {
      concerns = [
        'Requests high-risk banking SMS / OTP interception capabilities.',
        'Can observe screen keystrokes or simulate tap events.',
        'High background network transmission (${app.networkUsage}).',
      ];
      action = 'Immediately revoke sensitive permissions or isolate app in Quarantine Vault.';
    } else if (app.riskLevel == RiskLevel.high) {
      concerns = [
        'Accesses 24/7 background location, camera or audio recording.',
        'Contains ${app.trackersCount} active telemetry analytics trackers.',
        'Unverified developer credentials or third-party distribution.',
      ];
      action = 'Revoke background location and camera permissions in Permission Sentinel.';
    } else if (app.riskLevel == RiskLevel.medium) {
      concerns = [
        'Reads personal contacts address book or external file storage.',
        'Embedded advertising telemetry trackers active (${app.trackersCount} trackers).',
      ];
      action = 'Limit storage permissions to read-only mode.';
    } else {
      concerns = [
        'Standard verified application framework signatures.',
        'Zero suspicious background permission hooks detected.',
      ];
      action = 'Verified Safe: No immediate remediation required.';
    }

    return LlmRiskExplanationResult(
      summary: app.threatDescription,
      detailedAnalysis:
          '${app.threatDescription}\n\n[System Note]: $notice\n\nTo enable real-time generative AI contextual risk breakdowns, configure your LLM_API_KEY in your local .env file or build with --dart-define=LLM_API_KEY=your_key.',
      privacyConcerns: concerns,
      recommendedAction: action,
      isLiveLlmGenerated: false,
      modelUsed: 'Local Heuristic Engine',
      generatedAt: DateTime.now(),
      errorMessage: error,
    );
  }
}

