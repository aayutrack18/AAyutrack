import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/auth_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Hero gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          ),

          // ── Decorative circles
          Positioned(
            top: -size.width * 0.28,
            right: -size.width * 0.18,
            child: _DecorativeCircle(
              size: size.width * 0.75,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            top: size.height * 0.12,
            left: -size.width * 0.22,
            child: _DecorativeCircle(
              size: size.width * 0.55,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
          Positioned(
            bottom: size.height * 0.25,
            right: -size.width * 0.12,
            child: _DecorativeCircle(
              size: size.width * 0.42,
              color: AppColors.accent.withOpacity(0.12),
            ),
          ),

          // ── Cross/plus grid pattern (medical aesthetic)
          Positioned.fill(
            child: CustomPaint(painter: _MedicalGridPainter()),
          ),

          // ── Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo & brand
                  ScaleTransition(
                    scale: _logoScale,
                    child: const AayuBrandLogo(size: 76),
                  ),

                  const SizedBox(height: 28),

                  // Subtitle pill
                  FadeTransition(
                    opacity: _fadeIn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusFull,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        AppConstants.appSubtitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // ── Feature highlights
                  FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideUp,
                      child: Column(
                        children: [
                          _FeatureRow(
                            features: const [
                              _Feature(
                                icon: Icons.medication_rounded,
                                label: 'Medication Tracking',
                              ),
                              _Feature(
                                icon: Icons.favorite_rounded,
                                label: 'Vitals Monitoring',
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _FeatureRow(
                            features: const [
                              _Feature(
                                icon: Icons.bar_chart_rounded,
                                label: 'Compliance Score',
                              ),
                              _Feature(
                                icon: Icons.people_alt_rounded,
                                label: 'Doctor Connect',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ── Bottom card
                  FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideUp,
                      child: _WelcomeBottomCard(
                        onContinue: _navigateToLogin,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Feature helpers ──────────────────────────────────────────────────────

class _Feature {
  final IconData icon;
  final String label;

  const _Feature({required this.icon, required this.label});
}

class _FeatureRow extends StatelessWidget {
  final List<_Feature> features;

  const _FeatureRow({required this.features});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: features
          .map(
            (f) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: _FeatureChip(icon: f.icon, label: f.label),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: AppColors.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white.withOpacity(0.85),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Card ──────────────────────────────────────────────────────────

class _WelcomeBottomCard extends StatelessWidget {
  final VoidCallback onContinue;

  const _WelcomeBottomCard({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppConstants.appTagline,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Continue button — white on this dark background
          GestureDetector(
            onTap: onContinue,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.phone_android_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Phone',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Terms note
          Text(
            'By continuing, you agree to our Terms & Privacy Policy',
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white.withOpacity(0.55),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Decorative Circle ────────────────────────────────────────────────────

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorativeCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ─── Medical Grid Painter ─────────────────────────────────────────────────

class _MedicalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    const spacing = 36.0;
    const crossSize = 8.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        // Draw + cross
        canvas.drawLine(
          Offset(x - crossSize, y),
          Offset(x + crossSize, y),
          paint,
        );
        canvas.drawLine(
          Offset(x, y - crossSize),
          Offset(x, y + crossSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}