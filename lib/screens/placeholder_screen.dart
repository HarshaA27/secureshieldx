import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/risk_badge.dart';
import '../router/route_paths.dart';

class SecureShieldPlaceholderScreen extends StatelessWidget {
  final AppScreenInfo screenInfo;
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const SecureShieldPlaceholderScreen({
    super.key,
    required this.screenInfo,
    this.onToggleTheme,
    this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Find index in category for prev/next
    final categoryScreens = RoutePaths.allScreens
        .where((s) => s.category == screenInfo.category)
        .toList();
    final currentIndex = categoryScreens.indexWhere((s) => s.id == screenInfo.id);
    final prevScreen = currentIndex > 0 ? categoryScreens[currentIndex - 1] : null;
    final nextScreen =
        currentIndex >= 0 && currentIndex < categoryScreens.length - 1
            ? categoryScreens[currentIndex + 1]
            : null;

    final screenIndexInAll = RoutePaths.allScreens.indexWhere((s) => s.id == screenInfo.id) + 1;

    return Scaffold(
      appBar: CustomAppBar(
        title: screenInfo.name,
        subtitle: '${screenInfo.category.label} ($screenIndexInAll/55)',
        showBackButton: context.canPop(),
        onBackPressed: () => context.pop(),
        actions: [
          IconButton(
            onPressed: () => context.go(RoutePaths.appStructureHub),
            icon: const Icon(Icons.grid_view_rounded),
            tooltip: 'App Structure Hub',
          ),
          if (onToggleTheme != null)
            IconButton(
              onPressed: onToggleTheme,
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark ? AppColors.secondary : AppColors.primary,
              ),
              tooltip: 'Toggle Theme',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category & Screen Header Banner
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: screenInfo.category.color.withAlpha(40),
                        ),
                        child: Icon(
                          screenInfo.icon,
                          color: screenInfo.category.color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              screenInfo.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: screenInfo.category.color.withAlpha(30),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: screenInfo.category.color.withAlpha(80),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    screenInfo.category.icon,
                                    size: 14,
                                    color: screenInfo.category.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    screenInfo.category.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: screenInfo.category.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  // Route Path Bar
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: screenInfo.path));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied route "${screenInfo.path}" to clipboard!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black26 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.code_rounded, size: 18, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Route Path: ${screenInfo.path}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const Icon(Icons.copy_rounded, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Description Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Screen Purpose & Specification',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    screenInfo.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      RiskBadge(level: RiskLevel.safe, size: RiskBadgeSize.small),
                      RiskBadge(level: RiskLevel.medium, size: RiskBadgeSize.small),
                      RiskBadge(level: RiskLevel.high, size: RiskBadgeSize.small),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Navigation Controls
            Text(
              'Category Flow Controls',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: prevScreen != null ? '← ${prevScreen.name}' : 'No Prev',
                    variant: CustomButtonVariant.outline,
                    onPressed: prevScreen != null ? () => context.go(prevScreen.path) : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: nextScreen != null ? '${nextScreen.name} →' : 'No Next',
                    variant: CustomButtonVariant.primary,
                    onPressed: nextScreen != null ? () => context.go(nextScreen.path) : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'All 55 Screens Hub',
                    variant: CustomButtonVariant.secondary,
                    icon: const Icon(Icons.grid_view_rounded, size: 18),
                    onPressed: () => context.go(RoutePaths.appStructureHub),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Quick Jump Sheet',
                    variant: CustomButtonVariant.outline,
                    icon: const Icon(Icons.travel_explore_rounded, size: 18),
                    onPressed: () => _showQuickJumpBottomSheet(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Screen Preview Placeholder Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Component Showcase Preview',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Placeholder layout built using SecureShield X 2026 design tokens.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            screenInfo.icon,
                            size: 36,
                            color: screenInfo.category.color.withAlpha(180),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${screenInfo.name} Wireframe Ready',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickJumpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.travel_explore_rounded, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Jump to Any Screen (55 Total)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: RoutePaths.allScreens.length,
                    itemBuilder: (context, index) {
                      final item = RoutePaths.allScreens[index];
                      final isCurrent = item.id == screenInfo.id;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.category.color.withAlpha(40),
                          child: Icon(item.icon, color: item.category.color, size: 20),
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: isCurrent ? AppColors.primary : null,
                          ),
                        ),
                        subtitle: Text(
                          '${item.category.label} • ${item.path}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: isCurrent
                            ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                            : const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.pop(context);
                          context.go(item.path);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
