import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/data/mock_data.dart';
import '../core/models/app_models.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/risk_badge.dart';
import '../router/route_paths.dart';
import 'placeholder_screen.dart';

/// 1 & 2. Security Dashboard with Trend Graph & Risk Distribution Chart
class SecurityDashboardScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const SecurityDashboardScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<SecurityDashboardScreen> createState() => _SecurityDashboardScreenState();
}

class _SecurityDashboardScreenState extends State<SecurityDashboardScreen> {
  String _selectedTimeframe = '7 Days';
  int _touchedPieIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trendData = MockData.historicalScoreTrend;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Security Score Analytics',
        subtitle: 'Historical Trend & Threat Distribution',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () => context.go(RoutePaths.securityReports),
            icon: const Icon(Icons.picture_as_pdf_rounded),
            tooltip: 'Export Audit Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeframe Selector & Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '7-Day Protection Trend',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['7 Days', '30 Days', '6 Months'].map((tf) {
                      final isSel = _selectedTimeframe == tf;
                      return Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: ChoiceChip(
                          label: Text(tf, style: const TextStyle(fontSize: 11)),
                          selected: isSel,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedTimeframe = tf);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 1. Security Score Trend Graph (fl_chart)
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Health Score', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          Text(
                            '98 / 100',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.riskSafeBgLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.riskSafeBorderLight),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.trending_up_rounded, color: AppColors.riskSafe, size: 16),
                            SizedBox(width: 4),
                            Text('+6% this week', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.riskSafe)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // FL Chart Line Graph
                  SizedBox(
                    height: 190,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (val) => FlLine(
                            color: isDark ? Colors.white10 : Colors.black12,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 20,
                              getTitlesWidget: (val, meta) => Text(
                                '${val.toInt()}',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                int index = val.toInt();
                                if (index >= 0 && index < trendData.length) {
                                  return Text(
                                    trendData[index]['day'],
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 6,
                        minY: 60,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(trendData.length, (i) {
                              return FlSpot(i.toDouble(), (trendData[i]['score'] as double));
                            }),
                            isCurved: true,
                            gradient: AppColors.primaryGradient,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withAlpha(80),
                                  AppColors.primary.withAlpha(5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Score Callout Summary Cards
            Row(
              children: [
                _buildMetricBox(context, 'Highest Score', '98 / 100', AppColors.riskSafe),
                const SizedBox(width: 10),
                _buildMetricBox(context, 'Lowest Score', '72 / 100', AppColors.riskCritical),
                const SizedBox(width: 10),
                _buildMetricBox(context, 'Avg Stability', '88.4 / 100', AppColors.secondary),
              ],
            ),

            const SizedBox(height: 28),

            // 2. Risk Distribution Chart (PieChart / Donut Chart)
            Text(
              'Threat & Risk Level Distribution',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            CustomCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      // Pie Chart Container
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    _touchedPieIndex = -1;
                                    return;
                                  }
                                  _touchedPieIndex =
                                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 3,
                            centerSpaceRadius: 36,
                            sections: [
                              PieChartSectionData(
                                color: AppColors.riskCritical,
                                value: 1,
                                title: '1',
                                radius: _touchedPieIndex == 0 ? 32 : 26,
                                titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                color: AppColors.riskHigh,
                                value: 3,
                                title: '3',
                                radius: _touchedPieIndex == 1 ? 32 : 26,
                                titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                color: AppColors.riskMedium,
                                value: 9,
                                title: '9',
                                radius: _touchedPieIndex == 2 ? 32 : 26,
                                titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                color: AppColors.riskSafe,
                                value: 115,
                                title: '115',
                                radius: _touchedPieIndex == 3 ? 32 : 26,
                                titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Legend Items
                      Expanded(
                        child: Column(
                          children: [
                            _buildLegendItem(context, 'Critical Threat (1)', AppColors.riskCritical),
                            const SizedBox(height: 6),
                            _buildLegendItem(context, 'High Risk (3)', AppColors.riskHigh),
                            const SizedBox(height: 6),
                            _buildLegendItem(context, 'Medium Risk (9)', AppColors.riskMedium),
                            const SizedBox(height: 6),
                            _buildLegendItem(context, 'Safe Apps (115)', AppColors.riskSafe),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            CustomButton(
              text: 'Generate Full Security Audit Report',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.picture_as_pdf_rounded),
              onPressed: () => context.go(RoutePaths.securityReports),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: CustomCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

/// 4. Weekly / Monthly Security Report Screen
class SecurityReportsScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const SecurityReportsScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Weekly Security Audit',
        subtitle: 'Aug 10 - Aug 17, 2026 Digest',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.securityDashboard),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Executive Summary Banner
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.assessment_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Executive Protection Digest',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '1,240 Total Scans • 4 Threats Isolated • 99.4% Shield Uptime',
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
                          text: 'Export PDF Report',
                          variant: CustomButtonVariant.primary,
                          icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('PDF Report exported to downloads!')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          text: 'Export CSV Log',
                          variant: CustomButtonVariant.outline,
                          icon: const Icon(Icons.table_chart_rounded, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('CSV Log exported!')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Weekly Incident Breakdown',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            CustomCard(
              child: Column(
                children: [
                  _buildReportRow(context, 'Malware Heuristic Intercepts', '4 Blocked', RiskLevel.critical),
                  const Divider(height: 16),
                  _buildReportRow(context, 'Background Camera & Mic Audits', '18 Monitored', RiskLevel.high),
                  const Divider(height: 16),
                  _buildReportRow(context, 'Phishing SMS & URL Intercepts', '12 Blocked', RiskLevel.medium),
                  const Divider(height: 16),
                  _buildReportRow(context, 'Cloud Signature Sync Updates', '14,200 Synced', RiskLevel.safe),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildReportRow(BuildContext context, String label, String value, RiskLevel level) {
    return Row(
      children: [
        RiskBadge(level: level, size: RiskBadgeSize.small),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }
}

class ThreatHistoryScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const ThreatHistoryScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Scan & Threat Audit History',
        subtitle: 'Real-Time Firestore Scan Log',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.home),
      ),
      body: StreamBuilder<List<ScanResultModel>>(
        stream: FirestoreService().getScanHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data ?? [MockData.lastScanResult];

          return ListView.separated(
            padding: const EdgeInsets.all(20.0),
            itemCount: scans.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final scan = scans[index];
              final dateStr = '${scan.scanTime.day}/${scan.scanTime.month}/${scan.scanTime.year} ${scan.scanTime.hour}:${scan.scanTime.minute.toString().padLeft(2, '0')}';
              final isClean = scan.criticalCount == 0 && scan.highCount == 0;

              return CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isClean ? AppColors.riskSafeBgLight : AppColors.riskCriticalBgLight,
                          child: Icon(
                            isClean ? Icons.shield_rounded : Icons.warning_amber_rounded,
                            color: isClean ? AppColors.riskSafe : AppColors.riskCritical,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'System Heuristic Scan Audit',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dateStr,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isClean ? AppColors.riskSafe.withAlpha(20) : AppColors.riskCritical.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Score: ${scan.securityScore}/100',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isClean ? AppColors.riskSafe : AppColors.riskCritical,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Scanned: ${scan.totalAppsScanned} apps', style: const TextStyle(fontSize: 11)),
                        Text('Safe: ${scan.safeCount} • Med: ${scan.mediumCount}', style: const TextStyle(fontSize: 11)),
                        Text(
                          'Threats: ${scan.criticalCount + scan.highCount}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: (scan.criticalCount + scan.highCount > 0) ? AppColors.riskCritical : AppColors.riskSafe,
                          ),
                        ),
                      ],
                    ),
                    if (scan.detectedThreats.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Flagged Packages:',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.riskCritical),
                      ),
                      const SizedBox(height: 6),
                      ...scan.detectedThreats.take(3).map((t) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.bug_report_rounded, size: 14, color: AppColors.riskCritical),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${t.name} (${t.packageName})',
                                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class DataBreachCheckerScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const DataBreachCheckerScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.dataBreachChecker),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class NetworkSecurityScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const NetworkSecurityScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.networkSecurity),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class DeviceHealthScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const DeviceHealthScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.deviceHealth),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}



