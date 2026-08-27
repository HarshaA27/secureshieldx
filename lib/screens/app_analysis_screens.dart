import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/data/mock_data.dart';
import '../core/models/app_models.dart';
import '../core/services/app_scanner_service.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/empty_error_widgets.dart';
import '../core/widgets/risk_badge.dart';
import '../router/route_paths.dart';
import '../core/config/env_config.dart';
import '../core/services/llm_risk_explanation_service.dart';
import 'placeholder_screen.dart';


/// 9. Installed Apps List with Risk Badges Screen
class AppsOverviewScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AppsOverviewScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<AppsOverviewScreen> createState() => _AppsOverviewScreenState();
}

class _AppsOverviewScreenState extends State<AppsOverviewScreen> {
  String _searchQuery = '';
  RiskLevel? _selectedRiskFilter;
  List<InstalledAppModel> _scannedApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScannedApps();
  }

  Future<void> _loadScannedApps({bool refresh = false}) async {
    if (_scannedApps.isEmpty) setState(() => _isLoading = true);
    final apps = await AppScannerService().scanInstalledApps(forceRefresh: refresh);
    if (!mounted) return;
    setState(() {
      _scannedApps = apps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allApps = _scannedApps.isNotEmpty ? _scannedApps : MockData.installedApps;

    final filteredApps = allApps.where((app) {
      final matchesSearch = app.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.packageName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRisk = _selectedRiskFilter == null || app.riskLevel == _selectedRiskFilter;
      return matchesSearch && matchesRisk;
    }).toList();

    final criticalCount = allApps.where((a) => a.riskLevel == RiskLevel.critical).length;
    final highCount = allApps.where((a) => a.riskLevel == RiskLevel.high).length;
    final mediumCount = allApps.where((a) => a.riskLevel == RiskLevel.medium).length;
    final safeCount = allApps.where((a) => a.riskLevel == RiskLevel.safe).length;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Installed App Inventory',
        subtitle: '${allApps.length} Apps Monitored • Heuristic Risk Auditing',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () => _loadScannedApps(refresh: true),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Rescan Device Packages',
          ),
          IconButton(
            onPressed: () => context.go(RoutePaths.permissionManager),
            icon: const Icon(Icons.admin_panel_settings_rounded),
            tooltip: 'Permission Sentinel',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Bar
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search apps by name, package, or category...',
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

            const SizedBox(height: 14),

            // Risk Level Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text('All Apps (${allApps.length})'),
                    selected: _selectedRiskFilter == null,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedRiskFilter = null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    avatar: const RiskBadge(level: RiskLevel.critical, size: RiskBadgeSize.small),
                    label: Text('Critical ($criticalCount)'),
                    selected: _selectedRiskFilter == RiskLevel.critical,
                    onSelected: (selected) {
                      setState(() => _selectedRiskFilter = selected ? RiskLevel.critical : null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    avatar: const RiskBadge(level: RiskLevel.high, size: RiskBadgeSize.small),
                    label: Text('High Risk ($highCount)'),
                    selected: _selectedRiskFilter == RiskLevel.high,
                    onSelected: (selected) {
                      setState(() => _selectedRiskFilter = selected ? RiskLevel.high : null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    avatar: const RiskBadge(level: RiskLevel.medium, size: RiskBadgeSize.small),
                    label: Text('Medium ($mediumCount)'),
                    selected: _selectedRiskFilter == RiskLevel.medium,
                    onSelected: (selected) {
                      setState(() => _selectedRiskFilter = selected ? RiskLevel.medium : null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    avatar: const RiskBadge(level: RiskLevel.safe, size: RiskBadgeSize.small),
                    label: Text('Safe ($safeCount)'),
                    selected: _selectedRiskFilter == RiskLevel.safe,
                    onSelected: (selected) {
                      setState(() => _selectedRiskFilter = selected ? RiskLevel.safe : null);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Counter Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Apps List (${filteredApps.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  _selectedRiskFilter != null
                      ? 'Filtered by ${_selectedRiskFilter!.name.toUpperCase()}'
                      : 'Sorted by Risk Score',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Installed Apps List
            Expanded(
              child: _isLoading && _scannedApps.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Scanning Android PackageManager packages...'),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredApps.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final app = filteredApps[index];
                        return CustomCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: InkWell(
                            onTap: () => context.go(RoutePaths.appDetails, extra: app),
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary.withAlpha(30),
                                      ),
                                      child: Icon(app.icon, color: AppColors.primary, size: 24),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            app.name,
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            app.packageName,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontFamily: 'monospace',
                                                  fontSize: 11,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    RiskBadge(level: app.riskLevel, useGradientFill: true),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Risk Score: ${app.riskScore}/100',
                                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                '${app.permissions.length} Sensitive Perms • ${app.trackersCount} Trackers',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: app.riskScore / 100,
                                              minHeight: 4,
                                              backgroundColor: isDark ? Colors.white10 : Colors.black12,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                app.riskScore > 75
                                                    ? AppColors.riskCritical
                                                    : app.riskScore > 40
                                                        ? AppColors.riskMedium
                                                        : AppColors.riskSafe,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 10. App Detail Screen with Permissions List
class AppDetailsScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;
  final InstalledAppModel? selectedApp;

  const AppDetailsScreen({
    super.key,
    this.onToggleTheme,
    this.currentThemeMode,
    this.selectedApp,
  });

  @override
  State<AppDetailsScreen> createState() => _AppDetailsScreenState();
}

class _AppDetailsScreenState extends State<AppDetailsScreen> {
  late InstalledAppModel _app;
  late Map<String, bool> _permissionState;
  LlmRiskExplanationResult? _llmResult;
  bool _isFetchingLlm = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedApp != null) {
      _app = widget.selectedApp!;
    } else {
      final cached = AppScannerService().cachedApps;
      if (cached != null && cached.isNotEmpty) {
        _app = cached.first;
      } else {
        _app = MockData.installedApps[0];
      }
    }
    _permissionState = {
      for (var p in _app.permissions) p.id: p.isGranted,
    };
    _loadLlmExplanation();
  }

  Future<void> _loadLlmExplanation({bool force = false}) async {
    setState(() => _isFetchingLlm = true);
    final result = await LlmRiskExplanationService().generateExplanation(_app, forceRefresh: force);
    if (!mounted) return;
    setState(() {
      _llmResult = result;
      _isFetchingLlm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'App Security Audit',
        subtitle: _app.name,
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.apps),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header Hero Card
            CustomCard(
              borderGradient: AppColors.criticalGradient,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.riskCriticalBgLight,
                          border: Border.all(color: AppColors.riskCritical, width: 2),
                        ),
                        child: Icon(_app.icon, color: AppColors.riskCritical, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _app.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _app.developer,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.riskCritical,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Package: ${_app.packageName} • v${_app.version}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      RiskBadge(level: _app.riskLevel, useGradientFill: true, size: RiskBadgeSize.large),
                    ],
                  ),
                  const Divider(height: 24),

                  // Threat Summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.riskCriticalBgLight.withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.riskCritical.withAlpha(80)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.riskCritical, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _llmResult?.summary ?? _app.threatDescription,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Uninstall App',
                          variant: CustomButtonVariant.critical,
                          icon: const Icon(Icons.delete_forever_rounded, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Uninstalled ${_app.name} safely!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            context.go(RoutePaths.apps);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          text: 'Quarantine',
                          variant: CustomButtonVariant.secondary,
                          icon: const Icon(Icons.security_rounded, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${_app.name} isolated in quarantine vault.'),
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
            ),

            const SizedBox(height: 20),

            // Risk Breakdown Cards Row
            Row(
              children: [
                _buildMetricTile(context, 'Risk Score', '${_app.riskScore}/100', AppColors.riskCritical),
                const SizedBox(width: 10),
                _buildMetricTile(context, 'Trackers', '${_app.trackersCount} Found', AppColors.riskHigh),
                const SizedBox(width: 10),
                _buildMetricTile(context, 'Net Traffic', '142 MB/d', AppColors.secondary),
              ],
            ),

            const SizedBox(height: 24),

            // AI Risk Explanation Card (Connected to Real LLM API)
            _buildLlmRiskExplanationCard(context, isDark),

            const SizedBox(height: 24),


            const SizedBox(height: 24),

            // Permissions Audit List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sensitive Permissions Audit (${_app.permissions.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Revoke Risky Perms',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _app.permissions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final perm = _app.permissions[index];
                final isGranted = _permissionState[perm.id] ?? true;

                return CustomCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(perm.icon, color: AppColors.primary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  perm.name,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  perm.description,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: isGranted,
                            onChanged: (val) {
                              setState(() {
                                _permissionState[perm.id] = val;
                              });
                            },
                            activeThumbColor: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          RiskBadge(level: perm.riskLevel, size: RiskBadgeSize.small),
                          const SizedBox(width: 8),
                          Text(
                            isGranted ? 'Permission Granted' : 'Permission Revoked (Blocked)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isGranted ? AppColors.riskCritical : AppColors.riskSafe,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: CustomCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLlmRiskExplanationCard(BuildContext context, bool isDark) {
    final hasLlm = _llmResult?.isLiveLlmGenerated ?? false;
    final modelName = _llmResult?.modelUsed ?? 'Local Engine';

    return CustomCard(
      borderGradient: hasLlm ? AppColors.primaryGradient : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title & Live LLM Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'AI Cyber Risk Explanation',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasLlm ? AppColors.primary.withAlpha(30) : Colors.grey.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasLlm ? AppColors.primary : Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasLlm ? Icons.bolt_rounded : Icons.shield_rounded,
                      size: 12,
                      color: hasLlm ? AppColors.primary : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hasLlm ? 'Live LLM API ($modelName)' : 'Heuristic Engine',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: hasLlm ? AppColors.primary : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // API Key Status Banner if not using live LLM
          if (!EnvConfig.hasApiKey)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.secondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'To enable live LLM explanations, set LLM_API_KEY in .env or run with --dart-define=LLM_API_KEY=your_key.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

          // Detailed AI Explanation Content
          if (_isFetchingLlm)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(height: 10),
                    Text('Connecting to LLM API for contextual risk analysis...', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            )
          else ...[
            Text(
              _llmResult?.detailedAnalysis ?? 'Analysis unavailable.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 14),

            // Privacy Concerns Checklist
            Text(
              'Key Privacy & Security Indicators:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 6),
            if (_llmResult != null)
              ..._llmResult!.privacyConcerns.map(
                (concern) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: AppColors.riskHigh, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          concern,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Action Recommendation Box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.riskSafe, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI Recommendation: ${_llmResult?.recommendedAction ?? "Review perms."}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Refresh Live Analysis Button
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: _isFetchingLlm ? null : () => _loadLlmExplanation(force: true),
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: Text(
                  EnvConfig.hasApiKey ? 'Re-analyze with LLM API' : 'Try Live LLM Analysis',
                  style: const TextStyle(fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

}

class PermissionManagerScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const PermissionManagerScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.permissionManager),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class BehaviorTrackerScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const BehaviorTrackerScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.behaviorTracker),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class UninstallerAssistantScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const UninstallerAssistantScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.uninstallerAssistant),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class AppComparisonScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AppComparisonScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.appComparison),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

/// 3. Flagged Apps Overview & Quarantine Screen
class AppQuarantineScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AppQuarantineScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<AppQuarantineScreen> createState() => _AppQuarantineScreenState();
}

class _AppQuarantineScreenState extends State<AppQuarantineScreen> {
  final List<InstalledAppModel> _quarantinedApps = [
    MockData.installedApps[0], // SuperFlashlight
    MockData.installedApps[2], // Speed Cleaner
  ];
  bool _showEmptyStateDemo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Flagged Apps & Quarantine',
        subtitle: 'Isolated Suspicious Packages',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.apps),
        actions: [
          IconButton(
            icon: Icon(_showEmptyStateDemo ? Icons.view_list_rounded : Icons.filter_alt_off_rounded),
            tooltip: 'Toggle Empty State Demo',
            onPressed: () => setState(() => _showEmptyStateDemo = !_showEmptyStateDemo),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            CustomCard(
              borderGradient: AppColors.criticalGradient,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.riskCriticalBgLight,
                    child: Icon(Icons.verified_user_rounded, color: AppColors.riskCritical),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Isolated Security Vault',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Quarantined apps cannot execute background threads or access permissions.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (_showEmptyStateDemo || _quarantinedApps.isEmpty)
              CustomEmptyStateWidget(
                title: 'Zero Flagged Apps in Quarantine',
                description: 'No malicious or suspicious applications currently isolated. System real-time protection is active.',
                icon: Icons.shield_rounded,
                actionButtonText: 'Run Deep Scan',
                onActionButtonTap: () => context.go(RoutePaths.fullScan),
              )
            else ...[
              Text(
                'Quarantined Applications (${_quarantinedApps.length})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _quarantinedApps.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final app = _quarantinedApps[index];
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
                                text: 'Unquarantine',
                                variant: CustomButtonVariant.outline,
                                onPressed: () {
                                  setState(() => _quarantinedApps.removeAt(index));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Restored ${app.name} from vault.')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                text: 'Force Delete',
                                variant: CustomButtonVariant.critical,
                                onPressed: () {
                                  setState(() => _quarantinedApps.removeAt(index));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Permanently removed ${app.name}!')),
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
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class AppPrivacyScorecardScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AppPrivacyScorecardScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.appPrivacyScorecard),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}
