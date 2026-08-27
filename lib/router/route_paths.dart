import 'package:flutter/material.dart';

enum ScreenCategory {
  onboardingAuth('Onboarding & Auth', Icons.lock_open_rounded, Color(0xFF3B82F6)),
  homeScanning('Home & Scanning', Icons.shield_rounded, Color(0xFF10B981)),
  appAnalysis('App Analysis', Icons.apps_rounded, Color(0xFF8B5CF6)),
  aiAssistant('AI Cyber Assistant', Icons.auto_awesome_rounded, Color(0xFFEC4899)),
  dashboardAnalytics('Dashboard & Analytics', Icons.bar_chart_rounded, Color(0xFFF59E0B)),
  settingsPreferences('Settings & Preferences', Icons.settings_rounded, Color(0xFF64748B)),
  notificationsAlerts('Notifications & Alerts', Icons.notifications_active_rounded, Color(0xFFEF4444)),
  backendAccount('Backend / Account', Icons.manage_accounts_rounded, Color(0xFF06B6D4)),
  miscPolish('Misc / Polish', Icons.auto_fix_high_rounded, Color(0xFF6366F1)),
  cyberFraud('Cyber Fraud Reporting', Icons.report_problem_rounded, Color(0xFFDC2626));

  final String label;
  final IconData icon;
  final Color color;

  const ScreenCategory(this.label, this.icon, this.color);
}

class AppScreenInfo {
  final String id;
  final String name;
  final ScreenCategory category;
  final String path;
  final String description;
  final IconData icon;

  const AppScreenInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.path,
    required this.description,
    required this.icon,
  });
}

class RoutePaths {
  // Category 1: Onboarding & Auth (7)
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String authPinBiometrics = '/auth-pin-biometrics';

  // Category 2: Home & Scanning (6)
  static const String home = '/home';
  static const String quickScan = '/quick-scan';
  static const String fullScan = '/full-scan';
  static const String scanProgress = '/scan-progress';
  static const String scanResults = '/scan-results';
  static const String scheduledScans = '/scheduled-scans';

  // Category 3: App Analysis (8)
  static const String apps = '/apps';
  static const String appDetails = '/apps/details';
  static const String permissionManager = '/apps/permissions';
  static const String behaviorTracker = '/apps/behavior';
  static const String uninstallerAssistant = '/apps/uninstaller';
  static const String appComparison = '/apps/comparison';
  static const String appQuarantine = '/apps/quarantine';
  static const String appPrivacyScorecard = '/apps/privacy-scorecard';

  // Category 4: AI Cyber Assistant (5)
  static const String aiChat = '/ai-assistant';
  static const String aiThreatExplainer = '/ai-assistant/threat-explainer';
  static const String aiPrivacyAdvisor = '/ai-assistant/privacy-advisor';
  static const String aiFixRecommendations = '/ai-assistant/fix-recommendations';
  static const String aiVoiceCommand = '/ai-assistant/voice-command';

  // Category 5: Dashboard & Analytics (6)
  static const String securityDashboard = '/dashboard';
  static const String threatHistory = '/dashboard/threat-history';
  static const String dataBreachChecker = '/dashboard/breach-checker';
  static const String networkSecurity = '/dashboard/network-security';
  static const String deviceHealth = '/dashboard/device-health';
  static const String securityReports = '/dashboard/reports';

  // Category 6: Settings & Preferences (8)
  static const String settings = '/settings';
  static const String securityRules = '/settings/security-rules';
  static const String themeSettings = '/settings/theme';
  static const String privacyPreferences = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String scannerSensitivity = '/settings/scanner';
  static const String backupRestore = '/settings/backup-restore';
  static const String languageSettings = '/settings/language';

  // Category 7: Notifications & Alerts (4)
  static const String notifications = '/notifications';
  static const String notificationDetail = '/notifications/detail';
  static const String notificationHistory = '/notifications/history';
  static const String notificationRules = '/notifications/rules';

  // Category 8: Backend / Account (4)
  static const String profile = '/account/profile';
  static const String subscription = '/account/subscription';
  static const String cloudSync = '/account/cloud-sync';
  static const String connectedDevices = '/account/connected-devices';

  // Category 9: Misc / Polish (2)
  static const String designShowcase = '/design-showcase';
  static const String helpSupport = '/help-support';

  // Category 10: Cyber Fraud Reporting (5)
  static const String fraudReporting = '/fraud-reporting';
  static const String phishingReport = '/fraud-reporting/phishing';
  static const String financialFraudReport = '/fraud-reporting/financial';
  static const String fraudReportStatus = '/fraud-reporting/status';
  static const String evidenceVault = '/fraud-reporting/evidence-vault';

  // Hub Route
  static const String appStructureHub = '/app-structure-hub';

  static const List<AppScreenInfo> allScreens = [
    // 1. Onboarding & Auth (7)
    AppScreenInfo(
      id: 'splash',
      name: 'Splash Screen',
      category: ScreenCategory.onboardingAuth,
      path: splash,
      description: 'Animated brand splash screen with security engine initialization.',
      icon: Icons.shield_sharp,
    ),
    AppScreenInfo(
      id: 'welcome',
      name: 'Welcome & Value Prop',
      category: ScreenCategory.onboardingAuth,
      path: welcome,
      description: 'Introductory hero screen introducing key shield protections.',
      icon: Icons.waving_hand_rounded,
    ),
    AppScreenInfo(
      id: 'onboarding',
      name: 'Interactive Onboarding',
      category: ScreenCategory.onboardingAuth,
      path: onboarding,
      description: 'Multi-step wizard for initial permission grants & threat baseline.',
      icon: Icons.touch_app_rounded,
    ),
    AppScreenInfo(
      id: 'login',
      name: 'Login Screen',
      category: ScreenCategory.onboardingAuth,
      path: login,
      description: 'Secure user login portal supporting credentials and single sign-on.',
      icon: Icons.login_rounded,
    ),
    AppScreenInfo(
      id: 'register',
      name: 'Register & Account Setup',
      category: ScreenCategory.onboardingAuth,
      path: register,
      description: 'Account creation flow with verification code entry.',
      icon: Icons.person_add_rounded,
    ),
    AppScreenInfo(
      id: 'forgotPassword',
      name: 'Forgot / Reset Password',
      category: ScreenCategory.onboardingAuth,
      path: forgotPassword,
      description: 'Password recovery flow with email/SMS token verification.',
      icon: Icons.lock_reset_rounded,
    ),
    AppScreenInfo(
      id: 'authPinBiometrics',
      name: 'PIN & Biometric Auth',
      category: ScreenCategory.onboardingAuth,
      path: authPinBiometrics,
      description: 'Fingerprint, FaceID, and secure 6-digit PIN unlock verification.',
      icon: Icons.fingerprint_rounded,
    ),

    // 2. Home & Scanning (6)
    AppScreenInfo(
      id: 'home',
      name: 'Main Security Shield',
      category: ScreenCategory.homeScanning,
      path: home,
      description: 'Primary dashboard hub displaying real-time security posture & score.',
      icon: Icons.shield_rounded,
    ),
    AppScreenInfo(
      id: 'quickScan',
      name: 'Quick Security Scan',
      category: ScreenCategory.homeScanning,
      path: quickScan,
      description: 'Fast 15-second system scan checking running processes and high-risk apps.',
      icon: Icons.flash_on_rounded,
    ),
    AppScreenInfo(
      id: 'fullScan',
      name: 'Deep System Scan',
      category: ScreenCategory.homeScanning,
      path: fullScan,
      description: 'Comprehensive deep inspection of file system, APKs, and open ports.',
      icon: Icons.radar_rounded,
    ),
    AppScreenInfo(
      id: 'scanProgress',
      name: 'Live Scan Progress',
      category: ScreenCategory.homeScanning,
      path: scanProgress,
      description: 'Real-time animated scan visualization showing active scanning steps.',
      icon: Icons.sync_rounded,
    ),
    AppScreenInfo(
      id: 'scanResults',
      name: 'Scan Results Summary',
      category: ScreenCategory.homeScanning,
      path: scanResults,
      description: 'Detailed post-scan threat summary breakdown with recommended actions.',
      icon: Icons.fact_check_rounded,
    ),
    AppScreenInfo(
      id: 'scheduledScans',
      name: 'Scheduled Scans Manager',
      category: ScreenCategory.homeScanning,
      path: scheduledScans,
      description: 'Configure automated background scanning frequency and rules.',
      icon: Icons.schedule_rounded,
    ),

    // 3. App Analysis (8)
    AppScreenInfo(
      id: 'apps',
      name: 'App Inventory & Overview',
      category: ScreenCategory.appAnalysis,
      path: apps,
      description: 'Complete list of installed applications categorized by threat level.',
      icon: Icons.apps_rounded,
    ),
    AppScreenInfo(
      id: 'appDetails',
      name: 'Detailed App Analysis',
      category: ScreenCategory.appAnalysis,
      path: appDetails,
      description: 'In-depth safety audit, permissions, tracker list, and APK signature info.',
      icon: Icons.find_in_page_rounded,
    ),
    AppScreenInfo(
      id: 'permissionManager',
      name: 'Permission Manager',
      category: ScreenCategory.appAnalysis,
      path: permissionManager,
      description: 'Audit apps accessing microphone, camera, contacts, location, and SMS.',
      icon: Icons.admin_panel_settings_rounded,
    ),
    AppScreenInfo(
      id: 'behaviorTracker',
      name: 'App Behavior Tracker',
      category: ScreenCategory.appAnalysis,
      path: behaviorTracker,
      description: 'Monitor background network connections and data usage per app.',
      icon: Icons.timeline_rounded,
    ),
    AppScreenInfo(
      id: 'uninstallerAssistant',
      name: 'Uninstaller & Threat Removal',
      category: ScreenCategory.appAnalysis,
      path: uninstallerAssistant,
      description: 'One-tap bulk removal assistant for suspicious or unwanted apps.',
      icon: Icons.delete_sweep_rounded,
    ),
    AppScreenInfo(
      id: 'appComparison',
      name: 'App Safety Comparison',
      category: ScreenCategory.appAnalysis,
      path: appComparison,
      description: 'Side-by-side risk score comparison between similar installed apps.',
      icon: Icons.compare_arrows_rounded,
    ),
    AppScreenInfo(
      id: 'appQuarantine',
      name: 'App Quarantine Zone',
      category: ScreenCategory.appAnalysis,
      path: appQuarantine,
      description: 'Isolate suspicious applications and block background execution.',
      icon: Icons.verified_user_rounded,
    ),
    AppScreenInfo(
      id: 'appPrivacyScorecard',
      name: 'App Privacy Scorecard',
      category: ScreenCategory.appAnalysis,
      path: appPrivacyScorecard,
      description: 'Privacy risk assessment rating app data collection against standards.',
      icon: Icons.assessment_rounded,
    ),

    // 4. AI Cyber Assistant (5)
    AppScreenInfo(
      id: 'aiChat',
      name: 'AI Cyber Assistant Chat',
      category: ScreenCategory.aiAssistant,
      path: aiChat,
      description: 'Conversational security assistant powered by specialized threat intelligence.',
      icon: Icons.auto_awesome_rounded,
    ),
    AppScreenInfo(
      id: 'aiThreatExplainer',
      name: 'AI Threat Explainer',
      category: ScreenCategory.aiAssistant,
      path: aiThreatExplainer,
      description: 'Translates technical CVEs and malware alerts into plain language advice.',
      icon: Icons.psychology_rounded,
    ),
    AppScreenInfo(
      id: 'aiPrivacyAdvisor',
      name: 'Personalized AI Privacy Advisor',
      category: ScreenCategory.aiAssistant,
      path: aiPrivacyAdvisor,
      description: 'Tailored recommendations to reduce digital footprint and exposure.',
      icon: Icons.lightbulb_rounded,
    ),
    AppScreenInfo(
      id: 'aiFixRecommendations',
      name: 'One-Tap AI Fixes',
      category: ScreenCategory.aiAssistant,
      path: aiFixRecommendations,
      description: 'AI-generated dynamic list of single-click remediation scripts.',
      icon: Icons.build_circle_rounded,
    ),
    AppScreenInfo(
      id: 'aiVoiceCommand',
      name: 'AI Voice Command Hub',
      category: ScreenCategory.aiAssistant,
      path: aiVoiceCommand,
      description: 'Hands-free voice query hub for instant security checks and actions.',
      icon: Icons.mic_rounded,
    ),

    // 5. Dashboard & Analytics (6)
    AppScreenInfo(
      id: 'securityDashboard',
      name: 'Security Analytics Dashboard',
      category: ScreenCategory.dashboardAnalytics,
      path: securityDashboard,
      description: 'Executive security health score, historical trends, and threat metrics.',
      icon: Icons.dashboard_rounded,
    ),
    AppScreenInfo(
      id: 'threatHistory',
      name: 'Threat Incident History',
      category: ScreenCategory.dashboardAnalytics,
      path: threatHistory,
      description: 'Timeline archive of all blocked malware, phishes, and suspicious events.',
      icon: Icons.history_rounded,
    ),
    AppScreenInfo(
      id: 'dataBreachChecker',
      name: 'Data Breach Checker',
      category: ScreenCategory.dashboardAnalytics,
      path: dataBreachChecker,
      description: 'Scan dark web leaks for exposed emails, passwords, and IDs.',
      icon: Icons.vpn_key_rounded,
    ),
    AppScreenInfo(
      id: 'networkSecurity',
      name: 'Wi-Fi & Network Monitor',
      category: ScreenCategory.dashboardAnalytics,
      path: networkSecurity,
      description: 'Inspect Wi-Fi encryption, ARP spoofing risks, and rogue hotspots.',
      icon: Icons.wifi_password_rounded,
    ),
    AppScreenInfo(
      id: 'deviceHealth',
      name: 'Device Security Integrity',
      category: ScreenCategory.dashboardAnalytics,
      path: deviceHealth,
      description: 'Check OS patch status, root detection, ADB status, and encryption.',
      icon: Icons.developer_board_rounded,
    ),
    AppScreenInfo(
      id: 'securityReports',
      name: 'Export Audit Reports',
      category: ScreenCategory.dashboardAnalytics,
      path: securityReports,
      description: 'Generate exportable PDF/CSV reports for organizational compliance.',
      icon: Icons.picture_as_pdf_rounded,
    ),

    // 6. Settings & Preferences (8)
    AppScreenInfo(
      id: 'settings',
      name: 'Settings & Preferences',
      category: ScreenCategory.settingsPreferences,
      path: settings,
      description: 'Main app settings overview and sub-system configuration options.',
      icon: Icons.settings_rounded,
    ),
    AppScreenInfo(
      id: 'securityRules',
      name: 'Auto-Protection Rules',
      category: ScreenCategory.settingsPreferences,
      path: securityRules,
      description: 'Configure active real-time shield rules and automated responses.',
      icon: Icons.gavel_rounded,
    ),
    AppScreenInfo(
      id: 'themeSettings',
      name: 'Theme & Appearance',
      category: ScreenCategory.settingsPreferences,
      path: themeSettings,
      description: 'Switch dark/light mode, accent color themes, and ambient lighting.',
      icon: Icons.palette_rounded,
    ),
    AppScreenInfo(
      id: 'privacyPreferences',
      name: 'Data & Privacy Controls',
      category: ScreenCategory.settingsPreferences,
      path: privacyPreferences,
      description: 'Manage telemetry opt-in, cloud diagnostic sharing, and local data.',
      icon: Icons.privacy_tip_rounded,
    ),
    AppScreenInfo(
      id: 'notificationSettings',
      name: 'Alert Channels & Push',
      category: ScreenCategory.settingsPreferences,
      path: notificationSettings,
      description: 'Customize push notification urgency, sound alerts, and email digest.',
      icon: Icons.notifications_active_rounded,
    ),
    AppScreenInfo(
      id: 'scannerSensitivity',
      name: 'Scan Engine Sensitivity',
      category: ScreenCategory.settingsPreferences,
      path: scannerSensitivity,
      description: 'Adjust heuristic detection thresholds and cloud lookup engines.',
      icon: Icons.tune_rounded,
    ),
    AppScreenInfo(
      id: 'backupRestore',
      name: 'Security Config Backup',
      category: ScreenCategory.settingsPreferences,
      path: backupRestore,
      description: 'Export and import encrypted application settings and custom rules.',
      icon: Icons.settings_backup_restore_rounded,
    ),
    AppScreenInfo(
      id: 'languageSettings',
      name: 'Language & Region',
      category: ScreenCategory.settingsPreferences,
      path: languageSettings,
      description: 'Select app display language and localized threat advisories region.',
      icon: Icons.language_rounded,
    ),

    // 7. Notifications & Alerts (4)
    AppScreenInfo(
      id: 'notifications',
      name: 'Security Alerts Feed',
      category: ScreenCategory.notificationsAlerts,
      path: notifications,
      description: 'Live feed of system alerts, malware detection warnings, and advice.',
      icon: Icons.notifications_rounded,
    ),
    AppScreenInfo(
      id: 'notificationDetail',
      name: 'Critical Alert Deep-Dive',
      category: ScreenCategory.notificationsAlerts,
      path: notificationDetail,
      description: 'Detailed analysis of a specific security alert with immediate actions.',
      icon: Icons.error_outline_rounded,
    ),
    AppScreenInfo(
      id: 'notificationHistory',
      name: 'Alert Archive & History',
      category: ScreenCategory.notificationsAlerts,
      path: notificationHistory,
      description: 'Searchable log of past alerts, dismissed notifications, and fixes.',
      icon: Icons.history_edu_rounded,
    ),
    AppScreenInfo(
      id: 'notificationRules',
      name: 'Alert Filter & Rules',
      category: ScreenCategory.notificationsAlerts,
      path: notificationRules,
      description: 'Set severity filters and mute low-priority system messages.',
      icon: Icons.filter_alt_rounded,
    ),

    // 8. Backend / Account (4)
    AppScreenInfo(
      id: 'profile',
      name: 'User Profile & Identity',
      category: ScreenCategory.backendAccount,
      path: profile,
      description: 'Manage user identity, linked recovery contacts, and 2FA keys.',
      icon: Icons.person_rounded,
    ),
    AppScreenInfo(
      id: 'subscription',
      name: 'Subscription & Shield Tier',
      category: ScreenCategory.backendAccount,
      path: subscription,
      description: 'Manage SecureShield X Pro subscription, license keys, and billing.',
      icon: Icons.workspace_premium_rounded,
    ),
    AppScreenInfo(
      id: 'cloudSync',
      name: 'Cloud Intelligence Sync',
      category: ScreenCategory.backendAccount,
      path: cloudSync,
      description: 'Sync threat signature database with global SecureShield cloud network.',
      icon: Icons.cloud_sync_rounded,
    ),
    AppScreenInfo(
      id: 'connectedDevices',
      name: 'Multi-Device Manager',
      category: ScreenCategory.backendAccount,
      path: connectedDevices,
      description: 'Monitor protection status across linked smartphones, tablets, and PCs.',
      icon: Icons.devices_rounded,
    ),

    // 9. Misc / Polish (2)
    AppScreenInfo(
      id: 'designShowcase',
      name: 'Design System Showcase',
      category: ScreenCategory.miscPolish,
      path: designShowcase,
      description: 'Live interactive catalog of tokens, risk badges, buttons, and cards.',
      icon: Icons.style_rounded,
    ),
    AppScreenInfo(
      id: 'helpSupport',
      name: 'Help, FAQ & Support Hub',
      category: ScreenCategory.miscPolish,
      path: helpSupport,
      description: 'Knowledge base, emergency contact hotlines, and ticket submission.',
      icon: Icons.help_outline_rounded,
    ),

    // 10. Cyber Fraud Reporting (5)
    AppScreenInfo(
      id: 'fraudReporting',
      name: 'Cyber Fraud Reporting Portal',
      category: ScreenCategory.cyberFraud,
      path: fraudReporting,
      description: 'Central portal to report phishing, identity theft, and scam calls.',
      icon: Icons.report_problem_rounded,
    ),
    AppScreenInfo(
      id: 'phishingReport',
      name: 'Phishing & SMS Fraud Reporter',
      category: ScreenCategory.cyberFraud,
      path: phishingReport,
      description: 'Report malicious URLs, SMS smishing, and spoofed emails.',
      icon: Icons.mark_as_unread_rounded,
    ),
    AppScreenInfo(
      id: 'financialFraudReport',
      name: 'Financial Cyber Fraud Reporter',
      category: ScreenCategory.cyberFraud,
      path: financialFraudReport,
      description: 'Report unauthorized UPI, card, or banking transactions.',
      icon: Icons.account_balance_rounded,
    ),
    AppScreenInfo(
      id: 'fraudReportStatus',
      name: 'Report Status & Case Tracking',
      category: ScreenCategory.cyberFraud,
      path: fraudReportStatus,
      description: 'Track official response status and authority incident reference IDs.',
      icon: Icons.track_changes_rounded,
    ),
    AppScreenInfo(
      id: 'evidenceVault',
      name: 'Digital Evidence Vault',
      category: ScreenCategory.cyberFraud,
      path: evidenceVault,
      description: 'Securely store and attach screenshots, logs, and headers for legal reporting.',
      icon: Icons.inventory_2_rounded,
    ),
  ];

  static AppScreenInfo getScreenByPath(String path) {
    return allScreens.firstWhere(
      (screen) => screen.path == path,
      orElse: () => allScreens.first,
    );
  }
}
