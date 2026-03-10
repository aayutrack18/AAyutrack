import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

// ─── Primary CTA Button ────────────────────────────────────────────────────

class AayuPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AayuPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  State<AayuPrimaryButton> createState() => _AayuPrimaryButtonState();
}

class _AayuPrimaryButtonState extends State<AayuPrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.38),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                      ],
                      Text(widget.label, style: AppTextStyles.labelLarge),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Logo + Brand Widget ───────────────────────────────────────────────────

class AayuBrandLogo extends StatelessWidget {
  final bool dark;
  final double size;

  const AayuBrandLogo({super.key, this.dark = false, this.size = 64});

  @override
  Widget build(BuildContext context) {
    final color = dark ? AppColors.primary : Colors.white;
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: dark ? AppColors.surfaceVariant : Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(size * 0.28),
            border: Border.all(
              color: dark
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.monitor_heart_rounded,
              size: size * 0.55,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppConstants.appName,
          style: dark
              ? AppTextStyles.appBrand.copyWith(
                  color: AppColors.primary,
                  fontSize: 26,
                  letterSpacing: 3,
                )
              : AppTextStyles.appBrand,
        ),
      ],
    );
  }
}

// ─── Secure Badge ─────────────────────────────────────────────────────────

class SecureBadge extends StatelessWidget {
  final String label;

  const SecureBadge({super.key, this.label = 'Secure OTP Authentication'});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.shield_rounded, size: 14, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────

class AuthSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.displayMedium),
        const SizedBox(height: 8),
        Text(subtitle, style: AppTextStyles.bodyLarge),
      ],
    );
  }
}

// ─── Country Code Selector ─────────────────────────────────────────────────

class CountryCodeSelector extends StatelessWidget {
  final String flag;
  final String code;
  final VoidCallback? onTap;

  const CountryCodeSelector({
    super.key,
    this.flag = '🇮🇳',
    this.code = '+91',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: AppColors.divider, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(
              code,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single OTP Box ───────────────────────────────────────────────────────

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFilled;

  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFilled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: isFilled ? AppColors.primary.withOpacity(0.07) : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFilled
              ? AppColors.primary
              : focusNode.hasFocus
                  ? AppColors.primaryLight
                  : AppColors.divider,
          width: isFilled ? 2.0 : 1.5,
        ),
        boxShadow: isFilled
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

// ─── Divider with label ────────────────────────────────────────────────────

class LabeledDivider extends StatelessWidget {
  final String label;

  const LabeledDivider({super.key, this.label = 'or'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: AppTextStyles.labelSmall),
        ),
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const InfoChip({
    super.key,
    required this.icon,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: c.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: c),
          const SizedBox(width: 7),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: c,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}