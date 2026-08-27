import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/models/app_models.dart';
import '../screens/account_backend_screens.dart';
import '../screens/ai_assistant_screens.dart';
import '../screens/app_analysis_screens.dart';
import '../screens/app_structure_hub_screen.dart';
import '../screens/cyber_fraud_screens.dart';
import '../screens/dashboard_analytics_screens.dart';
import '../screens/home_scanning_screens.dart';
import '../screens/main_shell_screen.dart';
import '../screens/misc_polish_screens.dart';
import '../screens/notifications_alerts_screens.dart';
import '../screens/onboarding_auth_screens.dart';
import '../screens/settings_preferences_screens.dart';
import '../screens/showcase_screen.dart';
import 'route_paths.dart';

GoRouter createRouter({
  required VoidCallback onToggleTheme,
  required ThemeMode currentThemeMode,
}) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      // Fullscreen routes (without bottom shell navigation)
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => SplashScreen(
          onToggleTheme: onToggleTheme,
          currentThemeMode: currentThemeMode,
        ),
      ),
      GoRoute(
        path: RoutePaths.welcome,
        builder: (context, state) => WelcomeScreen(
          onToggleTheme: onToggleTheme,
          currentThemeMode: currentThemeMode,
        ),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => OnboardingScreen(
          onToggleTheme: onToggleTheme,
          currentThemeMode: currentThemeMode,
        ),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => LoginScreen(
          onToggleTheme: onToggleTheme,
          currentThemeMode: currentThemeMode,
        ),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => RegisterScreen(
          onToggleTheme: onToggleTheme,
          currentThemeMode: currentThemeMode,
          authData: state.extra as Map<String, String>?,
        ),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => ForgotPasswordScreen(
          onToggleTheme: onToggleTheme,
          currentThemeMode: currentThemeMode,
        ),
      ),
      GoRoute(
        path: RoutePaths.authPinBiometrics,
        builder: (context, state) => AuthPinBiometricsScreen(
          onToggleTheme: onToggleTheme,
          currentThemeMode: currentThemeMode,
        ),
      ),

      // ShellRoute for main app navigation with persistent bottom navigation bar
      ShellRoute(
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
          // Home & Scanning Group
          GoRoute(
            path: RoutePaths.home,
            builder: (context, state) => HomeScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.quickScan,
            builder: (context, state) => QuickScanScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.fullScan,
            builder: (context, state) => FullScanScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.scanProgress,
            builder: (context, state) => ScanProgressScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.scanResults,
            builder: (context, state) => ScanResultsScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.scheduledScans,
            builder: (context, state) => ScheduledScansScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // App Analysis Group
          GoRoute(
            path: RoutePaths.apps,
            builder: (context, state) => AppsOverviewScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.appDetails,
            builder: (context, state) => AppDetailsScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
              selectedApp: state.extra as InstalledAppModel?,
            ),
          ),
          GoRoute(
            path: RoutePaths.permissionManager,
            builder: (context, state) => PermissionManagerScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.behaviorTracker,
            builder: (context, state) => BehaviorTrackerScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.uninstallerAssistant,
            builder: (context, state) => UninstallerAssistantScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.appComparison,
            builder: (context, state) => AppComparisonScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.appQuarantine,
            builder: (context, state) => AppQuarantineScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.appPrivacyScorecard,
            builder: (context, state) => AppPrivacyScorecardScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // AI Cyber Assistant Group
          GoRoute(
            path: RoutePaths.aiChat,
            builder: (context, state) => AiChatScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.aiThreatExplainer,
            builder: (context, state) => AiThreatExplainerScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.aiPrivacyAdvisor,
            builder: (context, state) => AiPrivacyAdvisorScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.aiFixRecommendations,
            builder: (context, state) => AiFixRecommendationsScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.aiVoiceCommand,
            builder: (context, state) => AiVoiceCommandScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // Dashboard & Analytics Group
          GoRoute(
            path: RoutePaths.securityDashboard,
            builder: (context, state) => SecurityDashboardScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.threatHistory,
            builder: (context, state) => ThreatHistoryScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.dataBreachChecker,
            builder: (context, state) => DataBreachCheckerScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.networkSecurity,
            builder: (context, state) => NetworkSecurityScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.deviceHealth,
            builder: (context, state) => DeviceHealthScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.securityReports,
            builder: (context, state) => SecurityReportsScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // Settings & Preferences Group
          GoRoute(
            path: RoutePaths.settings,
            builder: (context, state) => SettingsOverviewScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.securityRules,
            builder: (context, state) => SecurityRulesScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.themeSettings,
            builder: (context, state) => ThemeSettingsScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.privacyPreferences,
            builder: (context, state) => PrivacyPreferencesScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.notificationSettings,
            builder: (context, state) => NotificationSettingsScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.scannerSensitivity,
            builder: (context, state) => ScannerSensitivityScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.backupRestore,
            builder: (context, state) => BackupRestoreScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.languageSettings,
            builder: (context, state) => LanguageSettingsScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // Notifications & Alerts Group
          GoRoute(
            path: RoutePaths.notifications,
            builder: (context, state) => NotificationsFeedScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.notificationDetail,
            builder: (context, state) => NotificationDetailScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.notificationHistory,
            builder: (context, state) => NotificationHistoryScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.notificationRules,
            builder: (context, state) => NotificationRulesScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // Backend / Account Group
          GoRoute(
            path: RoutePaths.profile,
            builder: (context, state) => UserProfileScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.subscription,
            builder: (context, state) => SubscriptionScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.cloudSync,
            builder: (context, state) => CloudSyncScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.connectedDevices,
            builder: (context, state) => ConnectedDevicesScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // Misc / Polish Group
          GoRoute(
            path: RoutePaths.designShowcase,
            builder: (context, state) => DesignSystemShowcaseScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.helpSupport,
            builder: (context, state) => HelpSupportScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // Cyber Fraud Reporting Group
          GoRoute(
            path: RoutePaths.fraudReporting,
            builder: (context, state) => FraudReportingPortalScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.phishingReport,
            builder: (context, state) => PhishingReportScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.financialFraudReport,
            builder: (context, state) => FinancialFraudReportScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.fraudReportStatus,
            builder: (context, state) => FraudReportStatusScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
          GoRoute(
            path: RoutePaths.evidenceVault,
            builder: (context, state) => EvidenceVaultScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),

          // Navigator Hub
          GoRoute(
            path: RoutePaths.appStructureHub,
            builder: (context, state) => AppStructureHubScreen(
              onToggleTheme: onToggleTheme,
              currentThemeMode: currentThemeMode,
            ),
          ),
        ],
      ),
    ],
  );
}
