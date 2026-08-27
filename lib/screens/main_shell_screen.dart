import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../router/route_paths.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(RoutePaths.apps)) return 1;
    if (location.startsWith(RoutePaths.aiChat)) return 2;
    if (location.startsWith(RoutePaths.fraudReporting)) return 3;
    if (location.startsWith(RoutePaths.appStructureHub)) return 4;
    if (location.startsWith(RoutePaths.home) || location == '/') return 0;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RoutePaths.home);
        break;
      case 1:
        context.go(RoutePaths.apps);
        break;
      case 2:
        context.go(RoutePaths.aiChat);
        break;
      case 3:
        context.go(RoutePaths.fraudReporting);
        break;
      case 4:
        context.go(RoutePaths.appStructureHub);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _onItemTapped(index, context),
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primary.withAlpha(50),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.shield_outlined),
              selectedIcon: Icon(Icons.shield_rounded, color: AppColors.primary),
              label: 'Shield',
            ),
            NavigationDestination(
              icon: Icon(Icons.apps_outlined),
              selectedIcon: Icon(Icons.apps_rounded, color: AppColors.secondary),
              label: 'Apps',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome_rounded, color: AppColors.secondary),
              label: 'AI Cyber',
            ),
            NavigationDestination(
              icon: Icon(Icons.report_problem_outlined),
              selectedIcon: Icon(Icons.report_problem_rounded, color: AppColors.riskCritical),
              label: 'Fraud',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
              label: '55 Hub',
            ),
          ],
        ),
      ),
    );
  }
}
