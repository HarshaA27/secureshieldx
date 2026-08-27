import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;
  final bool showGradientBorder;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottom,
    this.showGradientBorder = true,
  });

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight + (showGradientBorder ? 2.0 : 0.0));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    final bottomWidget = bottom;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface.withValues(alpha: 0.85) : AppColors.lightSurface.withValues(alpha: 0.85),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        if (leading != null)
                          leading!
                        else if (showBackButton && canPop)
                          _buildGlassBackButton(context, isDark)
                        else
                          const SizedBox(width: 4),

                        const SizedBox(width: 12),

                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  subtitle!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Trailing Actions
                        ...?actions,
                      ],
                    ),
                  ),
                ),
                // ignore: use_null_aware_elements
                if (bottomWidget != null) bottomWidget,
                if (showGradientBorder)
                  Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassBackButton(BuildContext context, bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
      ),
    );
  }
}
