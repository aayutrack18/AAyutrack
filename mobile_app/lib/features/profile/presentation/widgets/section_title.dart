import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final EdgeInsetsGeometry? margin;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
    this.margin,
    this.iconBackgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    final resolvedIconBackgroundColor = iconBackgroundColor ??
        theme.colorScheme.primary.withValues(alpha: 0.10);
    final resolvedIconColor = iconColor ?? theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: resolvedIconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: resolvedIconColor.withValues(alpha: 0.10),
              ),
            ),
            child: Icon(
              icon,
              size: 22,
              color: resolvedIconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  if (hasSubtitle) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}
