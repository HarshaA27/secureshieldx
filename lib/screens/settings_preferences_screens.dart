import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/data/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/risk_badge.dart';
import '../router/route_paths.dart';
import '../core/config/env_config.dart';
import '../core/services/llm_risk_explanation_service.dart';
import 'placeholder_screen.dart';


/// 5. Settings Overview Screen
class SettingsOverviewScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const SettingsOverviewScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<SettingsOverviewScreen> createState() => _SettingsOverviewScreenState();
}

class _SettingsOverviewScreenState extends State<SettingsOverviewScreen> {
  bool _realTimeShieldEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings & Preferences',
        subtitle: 'App Configuration & Security Engine Controls',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Shield Status Card
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.security_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SecureShield Engine Active',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Real-time APK heuristic monitoring enabled.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _realTimeShieldEnabled,
                    onChanged: (val) => setState(() => _realTimeShieldEnabled = val),
                    activeThumbColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 1: Security & Protection Rules
            _buildSectionTitle(context, 'Security Engine & Rules'),
            const SizedBox(height: 10),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    title: 'Auto-Protection Rules',
                    subtitle: 'Configure real-time virus & permission rules',
                    icon: Icons.gavel_rounded,
                    onTap: () => context.go(RoutePaths.securityRules),
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    context,
                    title: 'Scanner Sensitivity & Engines',
                    subtitle: 'Adjust heuristic detection threshold',
                    icon: Icons.tune_rounded,
                    onTap: () => context.go(RoutePaths.scannerSensitivity),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: Appearance & Localization
            _buildSectionTitle(context, 'Appearance & Localization'),
            const SizedBox(height: 10),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    title: 'Theme & Appearance',
                    subtitle: isDark ? 'Dark Theme (Cyber Slate OLED)' : 'Light Theme (Clean White)',
                    icon: Icons.palette_rounded,
                    onTap: () => context.go(RoutePaths.themeSettings),
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    context,
                    title: 'Language & Regional Advisories',
                    subtitle: 'Selected: English (US)',
                    icon: Icons.language_rounded,
                    onTap: () => context.go(RoutePaths.languageSettings),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 3: Notifications & Privacy
            _buildSectionTitle(context, 'Notifications & Privacy'),
            const SizedBox(height: 10),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    title: 'Notification Alert Channels',
                    subtitle: 'Push urgency & sound preferences',
                    icon: Icons.notifications_active_rounded,
                    onTap: () => context.go(RoutePaths.notificationSettings),
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    context,
                    title: 'Data & Privacy Controls',
                    subtitle: 'Telemetry opt-in & local storage',
                    icon: Icons.privacy_tip_rounded,
                    onTap: () => context.go(RoutePaths.privacyPreferences),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 4: Backup & Showcase
            _buildSectionTitle(context, 'System & Showcase'),
            const SizedBox(height: 10),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    title: 'Security Config Backup & Restore',
                    subtitle: 'Export encrypted app settings',
                    icon: Icons.settings_backup_restore_rounded,
                    onTap: () => context.go(RoutePaths.backupRestore),
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    context,
                    title: 'Design System Showcase',
                    subtitle: 'Inspect UI tokens, colors & buttons',
                    icon: Icons.style_rounded,
                    onTap: () => context.go(RoutePaths.designShowcase),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.primary.withAlpha(25),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }
}

/// 7. Theme Settings Screen
class ThemeSettingsScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const ThemeSettingsScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  String _selectedThemeOption = 'dark';
  Color _selectedAccent = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Theme & Appearance',
        subtitle: 'Customize Dark/Light Colors & Ambient Glows',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme Mode',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Theme Option Cards
            _buildThemeOptionCard(
              context,
              id: 'dark',
              title: 'Dark Theme (Cyber Slate OLED)',
              subtitle: 'Optimized for high contrast security displays & OLED battery savings.',
              icon: Icons.dark_mode_rounded,
              color: AppColors.darkBackground,
            ),
            const SizedBox(height: 10),
            _buildThemeOptionCard(
              context,
              id: 'light',
              title: 'Light Theme (Pure Clean White)',
              subtitle: 'Bright daylight high-clarity layout.',
              icon: Icons.light_mode_rounded,
              color: AppColors.lightBackground,
            ),

            const SizedBox(height: 24),

            Text(
              'Brand Accent Color Palette',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAccentCircle(context, AppColors.primary, 'Electric Violet'),
                _buildAccentCircle(context, AppColors.secondary, 'Cyber Cyan'),
                _buildAccentCircle(context, AppColors.riskSafe, 'Mint Emerald'),
                _buildAccentCircle(context, AppColors.riskCritical, 'Neon Crimson'),
              ],
            ),

            const SizedBox(height: 28),

            // Live Preview Card
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Theme Preview Box', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Previewing custom theme tokens with active surface contrast.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      CustomButton(
                        text: 'Toggle Mode',
                        variant: CustomButtonVariant.primary,
                        isFullWidth: false,
                        onPressed: widget.onToggleTheme ?? () {},
                      ),
                      const SizedBox(width: 12),
                      const RiskBadge(level: RiskLevel.safe),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOptionCard(
    BuildContext context, {
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedThemeOption == id;

    return CustomCard(
      borderGradient: isSelected ? AppColors.primaryGradient : null,
      child: InkWell(
        onTap: () {
          setState(() => _selectedThemeOption = id);
          if (widget.onToggleTheme != null) {
            widget.onToggleTheme!();
          }
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withAlpha(30),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : null,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccentCircle(BuildContext context, Color color, String name) {
    final isSelected = _selectedAccent == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedAccent = color),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(100),
                  blurRadius: 10,
                ),
              ],
            ),
            child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 22) : null,
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// 3. Language Selection Screen (Already Built & Refined)
class LanguageSettingsScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const LanguageSettingsScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguageCode = 'en';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allLanguages = MockData.languages;

    final filteredLanguages = allLanguages.where((lang) {
      final matchesSearch = lang.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lang.nativeName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Language Preferences',
        subtitle: 'Select Localized Security Advisories Region',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search language (e.g. English, हिन्दी, తెలుగు)...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Supported Regional Languages (${filteredLanguages.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${allLanguages.length} Available',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.secondary),
                ),

              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: filteredLanguages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final lang = filteredLanguages[index];
                  final isSelected = lang.code == _selectedLanguageCode;

                  return CustomCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    borderGradient: isSelected ? AppColors.primaryGradient : null,
                    child: InkWell(
                      onTap: () => setState(() => _selectedLanguageCode = lang.code),
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primary.withAlpha(40)
                                  : (isDark ? Colors.white10 : Colors.black.withAlpha(10)),
                            ),
                            child: Center(
                              child: Text(
                                lang.flagEmoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.name,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight:
                                            isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: isSelected ? AppColors.primary : null,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang.nativeName,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isSelected ? AppColors.primary : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            CustomButton(
              text: 'Save Language & Continue',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.check_rounded),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language updated to ${_selectedLanguageCode.toUpperCase()}!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
                context.go(RoutePaths.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityRulesScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const SecurityRulesScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.securityRules),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class PrivacyPreferencesScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const PrivacyPreferencesScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.privacyPreferences),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const NotificationSettingsScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.notificationSettings),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class ScannerSensitivityScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const ScannerSensitivityScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<ScannerSensitivityScreen> createState() => _ScannerSensitivityScreenState();
}

class _ScannerSensitivityScreenState extends State<ScannerSensitivityScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  String _selectedProvider = EnvConfig.llmProvider;
  String _selectedModel = EnvConfig.llmModel;
  bool _obscureKey = true;
  bool _isTestingConnection = false;
  String? _testResultStatus;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = EnvConfig.llmApiKey;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _testLlmConnection() async {
    final keyInput = _apiKeyController.text.trim();
    if (keyInput.isEmpty) {
      setState(() {
        _testSuccess = false;
        _testResultStatus = 'Please enter an API Key or add it to .env / --dart-define before testing.';
      });
      return;
    }

    EnvConfig.setRuntimeConfig(
      apiKey: keyInput,
      provider: _selectedProvider,
      model: _selectedModel,
    );

    setState(() {
      _isTestingConnection = true;
      _testResultStatus = null;
    });

    final testApp = MockData.installedApps[0]; // SuperFlashlight sample
    final result = await LlmRiskExplanationService().generateExplanation(testApp, forceRefresh: true);

    if (!mounted) return;

    setState(() {
      _isTestingConnection = false;
      _testSuccess = result.isLiveLlmGenerated;
      if (result.isLiveLlmGenerated) {
        _testResultStatus = 'SUCCESS! Live LLM API Connected (${result.modelUsed}).\n\nAI Explanation Output:\n"${result.summary}"';
      } else {
        _testResultStatus = 'FAILURE / FALLBACK: ${result.errorMessage ?? "No live response received. Check API key."}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar(
        title: 'LLM API & Heuristic Engine',
        subtitle: 'Configure Real-Time AI Risk Explanation Models',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Hero Card
            CustomCard(
              borderGradient: EnvConfig.hasApiKey ? AppColors.primaryGradient : null,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: EnvConfig.hasApiKey
                        ? AppColors.primary.withAlpha(40)
                        : AppColors.riskMediumBgLight,
                    child: Icon(
                      EnvConfig.hasApiKey ? Icons.auto_awesome_rounded : Icons.key_off_rounded,
                      color: EnvConfig.hasApiKey ? AppColors.primary : AppColors.riskMedium,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          EnvConfig.hasApiKey ? 'LLM API Active' : 'Offline Heuristic Engine Mode',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Key Source: ${EnvConfig.keySource}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Secure API Key Configuration Form
            Text(
              'Secure LLM API Key Settings',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'API keys can be supplied via local .env file, --dart-define=LLM_API_KEY=..., or entered below for live testing.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),

            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // API Provider Dropdown
                  Row(
                    children: [
                      const Text('LLM Provider: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedProvider,
                        items: const [
                          DropdownMenuItem(value: 'gemini', child: Text('Google Gemini API')),
                          DropdownMenuItem(value: 'openai', child: Text('OpenAI API / Compatible')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedProvider = val;
                              _selectedModel = val == 'gemini' ? 'gemini-1.5-flash' : 'gpt-4o-mini';
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Model Selection Input
                  TextField(
                    onChanged: (val) => _selectedModel = val.trim(),
                    controller: TextEditingController(text: _selectedModel),
                    decoration: const InputDecoration(
                      labelText: 'LLM Model Name',
                      hintText: 'gemini-1.5-flash, gpt-4o-mini, etc.',
                      prefixIcon: Icon(Icons.psychology_rounded, size: 20),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // API Key Field with Show/Hide toggle
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _obscureKey,
                    decoration: InputDecoration(
                      labelText: 'API Key (LLM_API_KEY)',
                      hintText: 'Paste Google Gemini or OpenAI API Key',
                      prefixIcon: const Icon(Icons.vpn_key_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureKey ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                        onPressed: () => setState(() => _obscureKey = !_obscureKey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: _isTestingConnection ? 'Connecting...' : 'Test LLM API Connection',
                          variant: CustomButtonVariant.primary,
                          icon: _isTestingConnection
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.network_check_rounded, size: 18),
                          onPressed: _isTestingConnection ? null : _testLlmConnection,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_testResultStatus != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _testSuccess
                      ? AppColors.riskSafeBgLight
                      : AppColors.riskCriticalBgLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _testSuccess ? AppColors.riskSafe : AppColors.riskCritical,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _testSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                      color: _testSuccess ? AppColors.riskSafe : AppColors.riskCritical,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _testResultStatus!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // How To Configure API Key Guide Card
            Text(
              'Where To Put Your API Key (Security Guide)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Method 1: Local .env File (Recommended for Local Dev)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text(
                    '1. Copy `.env.example` to `.env` in project root:\n'
                    '   cp .env.example .env\n'
                    '2. Open `.env` and set your key:\n'
                    '   LLM_API_KEY=AIzaSy...\n'
                    '3. `.env` is listed in `.gitignore` so your key is NEVER committed.',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, height: 1.4),
                  ),
                  const Divider(height: 20),
                  const Text('Method 2: Command Line --dart-define (Recommended for CI/CD & Prod)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text(
                    'Run or build Flutter app with compile-time flag:\n'
                    'flutter run --dart-define=LLM_API_KEY=AIzaSy...\n'
                    'flutter build apk --dart-define=LLM_API_KEY=AIzaSy...',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}


class BackupRestoreScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const BackupRestoreScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.backupRestore),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}
