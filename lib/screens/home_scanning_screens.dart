import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/data/mock_data.dart';
import '../core/models/app_models.dart';
import '../core/services/app_scanner_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/risk_badge.dart';
import '../router/route_paths.dart';
import 'placeholder_screen.dart';

/// 6. Home Dashboard Screen
class HomeScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const HomeScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<List<ScanResultModel>>(
      stream: FirestoreService().getScanHistoryStream(),
      builder: (context, snapshot) {
        final scanResult = (snapshot.hasData && snapshot.data!.isNotEmpty)
            ? snapshot.data!.first
            : MockData.lastScanResult;
        final threats = scanResult.detectedThreats;
        final topThreat = threats.isNotEmpty ? threats.first : null;

        return Scaffold(
          appBar: CustomAppBar(
            title: 'SecureShield X',
            subtitle: '2026 AI Mobile Security Engine',
            showBackButton: false,
            actions: [
              IconButton(
                onPressed: () => context.go(RoutePaths.notifications),
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Alerts Feed',
              ),
              if (onToggleTheme != null)
                IconButton(
                  onPressed: onToggleTheme,
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: isDark ? AppColors.secondary : AppColors.primary,
                  ),
                  tooltip: 'Toggle Light/Dark Theme',
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Security Score Hero Card
                CustomCard(
                  borderGradient: AppColors.primaryGradient,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Score Circular Meter
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(80),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${scanResult.securityScore}',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                  const Text(
                                    '/100',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RiskBadge(
                                      level: (scanResult.criticalCount > 0)
                                          ? RiskLevel.critical
                                          : (scanResult.highCount > 0)
                                              ? RiskLevel.high
                                              : RiskLevel.safe,
                                      size: RiskBadgeSize.small,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${scanResult.criticalCount + scanResult.highCount} Threats Pending',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: (scanResult.criticalCount + scanResult.highCount > 0)
                                                ? AppColors.riskHigh
                                                : AppColors.riskSafe,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Device Protection Rating',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Audited ${scanResult.totalAppsScanned} apps. ${scanResult.criticalCount} critical & ${scanResult.highCount} high risk apps.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Quick Scan (15s)',
                              variant: CustomButtonVariant.primary,
                              icon: const Icon(Icons.flash_on_rounded, size: 18),
                              onPressed: () => context.go(RoutePaths.scanProgress),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: 'Scan Results',
                              variant: CustomButtonVariant.outline,
                              icon: const Icon(Icons.fact_check_rounded, size: 18),
                              onPressed: () => context.go(RoutePaths.scanResults),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // High Risk Threat Warning Banner
                if (topThreat != null)
                  CustomCard(
                    borderGradient: AppColors.criticalGradient,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.riskCriticalBgLight,
                          child: Icon(Icons.warning_amber_rounded, color: AppColors.riskCritical),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topThreat.name,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.riskCritical,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                topThreat.threatDescription,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => context.go(RoutePaths.appDetails, extra: topThreat),
                          child: const Text('Resolve', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),


            const SizedBox(height: 24),

            // Feature Quick Hub Grid
            Text(
              'Security Management Hub',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _buildHubCard(
                  context,
                  title: 'App Analysis',
                  subtitle: '128 Apps Monitored',
                  icon: Icons.apps_rounded,
                  color: AppColors.primary,
                  onTap: () => context.go(RoutePaths.apps),
                ),
                _buildHubCard(
                  context,
                  title: 'Permission Guard',
                  subtitle: 'Camera & Mic Audit',
                  icon: Icons.admin_panel_settings_rounded,
                  color: AppColors.secondary,
                  onTap: () => context.go(RoutePaths.permissionManager),
                ),
                _buildHubCard(
                  context,
                  title: 'AI Cyber Assistant',
                  subtitle: 'Ask Security Queries',
                  icon: Icons.auto_awesome_rounded,
                  color: Colors.pinkAccent,
                  onTap: () => context.go(RoutePaths.aiChat),
                ),
                _buildHubCard(
                  context,
                  title: 'Cyber Fraud Portal',
                  subtitle: 'Report Scams & Phishing',
                  icon: Icons.report_problem_rounded,
                  color: AppColors.riskCritical,
                  onTap: () => context.go(RoutePaths.fraudReporting),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Real-Time Activity Log
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Real-Time Security Log',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => context.go(RoutePaths.threatHistory),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _buildActivityItem(
                    context,
                    title: 'Background Network Socket Blocked',
                    subtitle: 'Prevented outbound transmission to suspicious IP 192.168.1.102',
                    time: '12m ago',
                    icon: Icons.block_rounded,
                    color: AppColors.riskCritical,
                  ),
                  const Divider(height: 20),
                  _buildActivityItem(
                    context,
                    title: 'Virus Signatures Updated',
                    subtitle: 'Downloaded 14,200 new malware definitions from Cloud Hub',
                    time: '1h ago',
                    icon: Icons.cloud_download_rounded,
                    color: AppColors.secondary,
                  ),
                  const Divider(height: 20),
                  _buildActivityItem(
                    context,
                    title: 'Automatic Heuristic Scan',
                    subtitle: 'Scanned 4 newly installed APK packages. 0 viruses.',
                    time: '3h ago',
                    icon: Icons.verified_user_rounded,
                    color: AppColors.riskSafe,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  },
);
  }


  Widget _buildHubCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withAlpha(35),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withAlpha(30),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}

/// 7. Animated Scanning in Progress Screen
class ScanProgressScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const ScanProgressScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<ScanProgressScreen> createState() => _ScanProgressScreenState();
}

class _ScanProgressScreenState extends State<ScanProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _radarController;
  int _scannedApps = 12;
  double _progress = 0.1;
  String _currentStepText = 'Auditing installed APK signatures & hash integrity...';
  InstalledAppModel _currentApp = MockData.installedApps[0];
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _startScanningAnimation();
  }

  void _startScanningAnimation() async {
    final realApps = await AppScannerService().scanInstalledApps(forceRefresh: true);
    final total = realApps.isEmpty ? 1 : realApps.length;

    _scanTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (!mounted) return;
      if (_scannedApps < total) {
        setState(() {
          _scannedApps += 1;
          _progress = _scannedApps / total;
          _currentApp = realApps[(_scannedApps - 1) % realApps.length];

          if (_progress < 0.3) {
            _currentStepText = 'Scanning native Android packages & API levels...';
          } else if (_progress < 0.6) {
            _currentStepText = 'Auditing SMS, Camera & Location requested permissions...';
          } else if (_progress < 0.9) {
            _currentStepText = 'Evaluating risk scores & background network sockets...';
          } else {
            _currentStepText = 'Finalizing 2026 AI heuristic threat summary...';
          }
        });
      } else {
        _scanTimer?.cancel();

        final criticals = realApps.where((a) => a.riskLevel == RiskLevel.critical).toList();
        final highs = realApps.where((a) => a.riskLevel == RiskLevel.high).toList();
        final mediums = realApps.where((a) => a.riskLevel == RiskLevel.medium).toList();
        final safes = realApps.where((a) => a.riskLevel == RiskLevel.safe).toList();
        final threats = [...criticals, ...highs];

        int computedScore = 100 - (criticals.length * 25 + highs.length * 10 + mediums.length * 2);
        if (computedScore < 15) computedScore = 15;

        final scanResult = ScanResultModel(
          scanTime: DateTime.now(),
          totalAppsScanned: total,
          safeCount: safes.length,
          mediumCount: mediums.length,
          highCount: highs.length,
          criticalCount: criticals.length,
          detectedThreats: threats,
          securityScore: computedScore,
        );

        await FirestoreService().saveScanResult(scanResult);
        await FirestoreService().logSecurityAction(
          title: 'Full System Scan Completed',
          subtitle: 'Scanned $total packages. Detected ${threats.length} high/critical risk apps.',
          category: 'HeuristicScan',
          riskLevel: threats.isNotEmpty ? 'critical' : 'safe',
        );

        Timer(const Duration(milliseconds: 400), () {
          if (mounted) {
            context.go(RoutePaths.scanResults);
          }
        });
      }
    });
  }


  @override
  void dispose() {
    _radarController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Deep System Scan',
        subtitle: 'Live Heuristic Engine Active',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.home),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),

            // Animated Radar Pulse
            RotationTransition(
              turns: _radarController,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(90),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.radar_rounded,
                  size: 90,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              'Scanning System (${(_progress * 100).toInt()}%)',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentStepText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
            ),

            const SizedBox(height: 24),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
                backgroundColor: isDark ? Colors.white10 : Colors.black12,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ),

            const SizedBox(height: 28),

            // Currently Scanning App Card
            CustomCard(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _currentApp.riskLevel == RiskLevel.critical
                        ? AppColors.riskCriticalBgLight
                        : AppColors.primary.withAlpha(30),
                    child: Icon(_currentApp.icon, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inspecting: ${_currentApp.name}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _currentApp.packageName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$_scannedApps/128',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                  ),
                ],
              ),
            ),

            const Spacer(),

            CustomButton(
              text: 'Cancel Scan',
              variant: CustomButtonVariant.outline,
              onPressed: () => context.go(RoutePaths.home),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickScanScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const QuickScanScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return ScanProgressScreen(
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class FullScanScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const FullScanScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return ScanProgressScreen(
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

/// 8. Scan Results Summary Screen
class ScanResultsScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const ScanResultsScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    final scannedApps = AppScannerService().cachedApps ?? MockData.installedApps;
    final totalCount = scannedApps.length;
    final criticalCount = scannedApps.where((a) => a.riskLevel == RiskLevel.critical).length;
    final highCount = scannedApps.where((a) => a.riskLevel == RiskLevel.high).length;
    final mediumCount = scannedApps.where((a) => a.riskLevel == RiskLevel.medium).length;
    final safeCount = scannedApps.where((a) => a.riskLevel == RiskLevel.safe).length;
    final threatsCount = criticalCount + highCount;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Scan Summary',
        subtitle: '$totalCount Apps Audited • $threatsCount Threats Flagged',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.home),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result Header Banner
            CustomCard(
              borderGradient: AppColors.criticalGradient,
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.criticalGradient,
                    ),
                    child: const Icon(Icons.gavel_rounded, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Action Required: 3 High-Risk Threats',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.riskCritical,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Immediate quarantine or uninstallation recommended to prevent data theft.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Breakdown Grid
            Row(
              children: [
                _buildStatBox(context, 'Total Scanned', '$totalCount', AppColors.primary),
                const SizedBox(width: 10),
                _buildStatBox(context, 'Safe Apps', '$safeCount', AppColors.riskSafe),
                const SizedBox(width: 10),
                _buildStatBox(context, 'Medium Risk', '$mediumCount', AppColors.riskMedium),
                const SizedBox(width: 10),
                _buildStatBox(context, 'Critical', '$threatsCount', AppColors.riskCritical),
              ],
            ),

            const SizedBox(height: 24),

            // Detected Threats List Header
            Text(
              'Detected Threats & Remediations',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (scannedApps.where((a) => a.riskLevel == RiskLevel.critical || a.riskLevel == RiskLevel.high).isNotEmpty)
                  ? scannedApps.where((a) => a.riskLevel == RiskLevel.critical || a.riskLevel == RiskLevel.high).length
                  : 2,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final threatApps = scannedApps.where((a) => a.riskLevel == RiskLevel.critical || a.riskLevel == RiskLevel.high).toList();
                final app = threatApps.isNotEmpty ? threatApps[index] : MockData.installedApps[index];
                return CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(app.icon, color: AppColors.primary, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.name,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  app.packageName,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontFamily: 'monospace',
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          RiskBadge(level: app.riskLevel),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        app.threatDescription,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Inspect Details',
                              variant: CustomButtonVariant.outline,
                              onPressed: () => context.go(RoutePaths.appDetails),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              text: 'Uninstall Threat',
                              variant: CustomButtonVariant.critical,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed ${app.name} safely!'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Resolve All Threats (One-Tap Fix)',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.auto_fix_high_rounded),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All 3 threats isolated and resolved! Device Score: 100/100'),
                    duration: Duration(seconds: 3),
                  ),
                );
                context.go(RoutePaths.home);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: CustomCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduledScansScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const ScheduledScansScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.scheduledScans),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}
