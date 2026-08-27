import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';
import 'custom_card.dart';

class CustomEmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? actionButtonText;
  final VoidCallback? onActionButtonTap;

  const CustomEmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.shield_outlined,
    this.actionButtonText,
    this.onActionButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(25),
                border: Border.all(
                  color: AppColors.primary.withAlpha(60),
                  width: 1.5,
                ),
              ),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionButtonText != null && onActionButtonTap != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: actionButtonText!,
                variant: CustomButtonVariant.primary,
                isFullWidth: false,
                onPressed: onActionButtonTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String errorCode;
  final String errorMessage;
  final String diagnosticText;
  final VoidCallback? onRetryTap;

  const CustomErrorWidget({
    super.key,
    this.errorCode = 'ERR_NETWORK_TIMEOUT',
    required this.errorMessage,
    required this.diagnosticText,
    this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomCard(
      borderGradient: AppColors.criticalGradient,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.riskCriticalBgLight,
                ),
                child: const Icon(Icons.error_outline_rounded, color: AppColors.riskCritical, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      errorMessage,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.riskCritical,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.riskCritical.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Code: $errorCode',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.riskCritical,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            diagnosticText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
          ),
          if (onRetryTap != null) ...[
            const SizedBox(height: 18),
            CustomButton(
              text: 'Retry Connection / Diagnostic',
              variant: CustomButtonVariant.outline,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              onPressed: onRetryTap,
            ),
          ],
        ],
      ),
    );
  }
}
