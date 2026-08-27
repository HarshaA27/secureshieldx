import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/risk_badge.dart';

class DesignSystemShowcaseScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const DesignSystemShowcaseScreen({
    super.key,
    this.onToggleTheme,
    this.currentThemeMode,
  });

  @override
  State<DesignSystemShowcaseScreen> createState() => _DesignSystemShowcaseScreenState();
}

class _DesignSystemShowcaseScreenState extends State<DesignSystemShowcaseScreen> {
  bool _isLoadingButton = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'SecureShield X',
        subtitle: 'Material 3 Design System Foundation',
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
            // Header Banner
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2026 Security & Fintech UI System',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dynamic risk colors, ambient glows, rounded cards & modern glassmorphism.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Section 1: Risk Badges
            _buildSectionHeader(context, '1. Risk Level Badges'),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Standard Badges', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      RiskBadge(level: RiskLevel.critical),
                      RiskBadge(level: RiskLevel.high),
                      RiskBadge(level: RiskLevel.medium),
                      RiskBadge(level: RiskLevel.safe),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Gradient Pill Badges (High Impact)', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      RiskBadge(level: RiskLevel.critical, useGradientFill: true),
                      RiskBadge(level: RiskLevel.high, useGradientFill: true),
                      RiskBadge(level: RiskLevel.medium, useGradientFill: true),
                      RiskBadge(level: RiskLevel.safe, useGradientFill: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Sizing Variants', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      RiskBadge(level: RiskLevel.critical, size: RiskBadgeSize.small),
                      RiskBadge(level: RiskLevel.high, size: RiskBadgeSize.medium),
                      RiskBadge(level: RiskLevel.safe, size: RiskBadgeSize.large),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Section 2: Custom Buttons
            _buildSectionHeader(context, '2. Custom Buttons'),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  CustomButton(
                    text: 'Primary Gradient Shield Action',
                    icon: const Icon(Icons.security_rounded),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Secondary Cyber Action',
                    variant: CustomButtonVariant.secondary,
                    icon: const Icon(Icons.auto_awesome_rounded),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Report Misuse to Cyber Authorities',
                    variant: CustomButtonVariant.critical,
                    icon: const Icon(Icons.report_problem_rounded),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Outline Button',
                          variant: CustomButtonVariant.outline,
                          isFullWidth: false,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: _isLoadingButton ? 'Scanning...' : 'Loading Demo',
                          variant: CustomButtonVariant.primary,
                          isLoading: _isLoadingButton,
                          isFullWidth: false,
                          onPressed: () {
                            setState(() => _isLoadingButton = true);
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) setState(() => _isLoadingButton = false);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Section 3: Cards & Elevation
            _buildSectionHeader(context, '3. Cards & Glassmorphism'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RiskBadge(level: RiskLevel.critical, size: RiskBadgeSize.small),
                        const SizedBox(height: 12),
                        Text('Photo Gallery App', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('12 Risky Permissions', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomCard(
                    borderGradient: AppColors.safeGradient,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RiskBadge(level: RiskLevel.safe, size: RiskBadgeSize.small),
                        const SizedBox(height: 12),
                        Text('Calculator App', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('0 Risks Detected', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Section 4: Typography Scale
            _buildSectionHeader(context, '4. Typography Scale'),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Large', style: Theme.of(context).textTheme.displaySmall),
                  const Divider(height: 20),
                  Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
                  const Divider(height: 20),
                  Text('Title Large (App Headers)', style: Theme.of(context).textTheme.titleLarge),
                  const Divider(height: 20),
                  Text(
                    'Body Medium: AI-generated risk explanation describing photo misuse, background location tracking, and unauthorized data transmission.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Divider(height: 20),
                  Text('LABEL LARGE (BUTTON TEXT)', style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
    );
  }
}
