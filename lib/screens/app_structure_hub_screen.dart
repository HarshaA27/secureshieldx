import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_card.dart';
import '../router/route_paths.dart';

class AppStructureHubScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AppStructureHubScreen({
    super.key,
    this.onToggleTheme,
    this.currentThemeMode,
  });

  @override
  State<AppStructureHubScreen> createState() => _AppStructureHubScreenState();
}

class _AppStructureHubScreenState extends State<AppStructureHubScreen> {
  String _searchQuery = '';
  ScreenCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredScreens = RoutePaths.allScreens.where((screen) {
      final matchesSearch = screen.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          screen.path.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          screen.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || screen.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'App Structure Navigator',
        subtitle: '55 Screens • 10 Security Architecture Groups',
        showBackButton: false,
        actions: [
          if (widget.onToggleTheme != null)
            IconButton(
              onPressed: widget.onToggleTheme,
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
            // Overview Header Banner
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Icon(Icons.account_tree_rounded, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SecureShield X Route Architecture',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Complete 55-screen blueprint powered by go_router. Click any item to inspect its structure.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search Bar
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search 55 screens by name, path, or description...',
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Groups (55)'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = null);
                    },
                    selectedColor: AppColors.primary.withAlpha(40),
                    side: BorderSide(
                      color: _selectedCategory == null
                          ? AppColors.primary
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...ScreenCategory.values.map((category) {
                    final count = RoutePaths.allScreens
                        .where((s) => s.category == category)
                        .length;
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        avatar: Icon(category.icon, size: 16, color: category.color),
                        label: Text('${category.label} ($count)'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                        selectedColor: category.color.withAlpha(40),
                        side: BorderSide(
                          color: isSelected
                              ? category.color
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Results Counter Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Screens List (${filteredScreens.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  _selectedCategory != null ? _selectedCategory!.label : 'All Categories',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Screens List
            if (filteredScreens.isEmpty)
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'No screens found matching "$_searchQuery"',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredScreens.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final screen = filteredScreens[index];
                  final globalIndex = RoutePaths.allScreens.indexOf(screen) + 1;
                  return CustomCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: InkWell(
                      onTap: () => context.go(screen.path),
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: screen.category.color.withAlpha(35),
                            ),
                            child: Center(
                              child: Icon(
                                screen.icon,
                                color: screen.category.color,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '#$globalIndex ',
                                      style: TextStyle(
                                        color: screen.category.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        screen.name,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  screen.path,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontFamily: 'monospace',
                                        fontSize: 11,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  screen.description,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
                        ],
                      ),
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
}
