import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/data/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/risk_badge.dart';
import '../router/route_paths.dart';
import 'placeholder_screen.dart';

/// 8. Notifications List Screen
class NotificationsFeedScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const NotificationsFeedScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<NotificationsFeedScreen> createState() => _NotificationsFeedScreenState();
}

class _NotificationsFeedScreenState extends State<NotificationsFeedScreen> {
  String _selectedFilter = 'All';
  final List<Map<String, dynamic>> _notifs = List.from(MockData.notificationsFeed);

  @override
  Widget build(BuildContext context) {
    final filteredNotifs = _notifs.where((item) {
      if (_selectedFilter == 'Critical Only') {
        return item['riskLevel'] == RiskLevel.critical || item['riskLevel'] == RiskLevel.high;
      } else if (_selectedFilter == 'System Info') {
        return item['riskLevel'] == RiskLevel.safe || item['riskLevel'] == RiskLevel.medium;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Security Alerts Feed',
        subtitle: 'Live System & Threat Notifications',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'Mark All Read',
            onPressed: () {
              setState(() {
                for (var item in _notifs) {
                  item['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Choice Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Critical Only', 'System Info'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedFilter = filter);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alerts Feed (${filteredNotifs.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${_notifs.where((n) => !(n['isRead'] as bool)).length} Unread',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: filteredNotifs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = filteredNotifs[index];
                  final isRead = item['isRead'] as bool;
                  final RiskLevel risk = item['riskLevel'] as RiskLevel;

                  Color accentColor;
                  switch (risk) {
                    case RiskLevel.critical:
                      accentColor = AppColors.riskCritical;
                      break;
                    case RiskLevel.high:
                      accentColor = AppColors.riskHigh;
                      break;
                    case RiskLevel.medium:
                      accentColor = AppColors.riskMedium;
                      break;
                    case RiskLevel.safe:
                      accentColor = AppColors.riskSafe;
                      break;
                  }

                  return CustomCard(
                    padding: const EdgeInsets.all(14),
                    borderGradient: !isRead && risk == RiskLevel.critical ? AppColors.criticalGradient : null,
                    child: InkWell(
                      onTap: () {
                        setState(() => item['isRead'] = true);
                        if (risk == RiskLevel.critical) {
                          context.go(RoutePaths.appDetails);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: accentColor.withAlpha(30),
                                child: Icon(item['icon'] as IconData, size: 18, color: accentColor),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: !isRead ? FontWeight.bold : FontWeight.normal,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item['category']} • ${item['time']}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['body'] as String,
                            style: Theme.of(context).textTheme.bodySmall,
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

class NotificationDetailScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const NotificationDetailScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.notificationDetail),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class NotificationHistoryScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const NotificationHistoryScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.notificationHistory),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

class NotificationRulesScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const NotificationRulesScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return SecureShieldPlaceholderScreen(
      screenInfo: RoutePaths.getScreenByPath(RoutePaths.notificationRules),
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}
