/// Secure Environment Configuration Reader for SecureShield X
/// Manages LLM API Key and LLM Provider configuration safely without hardcoding secrets.
class EnvConfig {

  // Compile-time environment variables passed via --dart-define
  static const String _dartDefineApiKey = String.fromEnvironment('LLM_API_KEY', defaultValue: '');
  static const String _dartDefineProvider = String.fromEnvironment('LLM_API_PROVIDER', defaultValue: 'gemini');
  static const String _dartDefineModel = String.fromEnvironment('LLM_MODEL', defaultValue: 'gemini-1.5-flash');

  // Runtime overrides (from .env file or user UI input in Settings)
  static String _runtimeApiKey = '';
  static String _runtimeProvider = 'gemini';
  static String _runtimeModel = 'gemini-1.5-flash';

  /// Sets runtime API key (e.g. parsed from local `.env` or input by user in settings)
  static void setRuntimeConfig({
    String? apiKey,
    String? provider,
    String? model,
  }) {
    if (apiKey != null) _runtimeApiKey = apiKey.trim();
    if (provider != null && provider.isNotEmpty) _runtimeProvider = provider.trim();
    if (model != null && model.isNotEmpty) _runtimeModel = model.trim();
  }

  /// Parse .env contents string directly into EnvConfig
  static void parseEnvContent(String envContent) {
    final lines = envContent.split('\n');
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim().replaceAll('"', '').replaceAll("'", '');
        if (key == 'LLM_API_KEY') {
          _runtimeApiKey = value;
        } else if (key == 'LLM_API_PROVIDER') {
          _runtimeProvider = value;
        } else if (key == 'LLM_MODEL') {
          _runtimeModel = value;
        }
      }
    }
  }

  /// Get active LLM API Key
  static String get llmApiKey {
    if (_dartDefineApiKey.isNotEmpty) return _dartDefineApiKey;
    return _runtimeApiKey;
  }

  /// Get active LLM Provider ('gemini' or 'openai')
  static String get llmProvider {
    if (_dartDefineProvider.isNotEmpty && _dartDefineProvider != 'gemini') {
      return _dartDefineProvider;
    }
    return _runtimeProvider.isNotEmpty ? _runtimeProvider : 'gemini';
  }

  /// Get active LLM Model Name
  static String get llmModel {
    if (_dartDefineModel.isNotEmpty && _dartDefineModel != 'gemini-1.5-flash') {
      return _dartDefineModel;
    }
    return _runtimeModel.isNotEmpty ? _runtimeModel : 'gemini-1.5-flash';
  }

  /// Check if a valid API Key is available
  static bool get hasApiKey => llmApiKey.isNotEmpty;

  /// Human-readable source description of where key is loaded from
  static String get keySource {
    if (_dartDefineApiKey.isNotEmpty) return '--dart-define (Build Flag)';
    if (_runtimeApiKey.isNotEmpty) return 'Local .env / Settings Override';
    return 'None (Using Offline Heuristic Fallback)';
  }
}
