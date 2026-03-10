import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  bool _isLoading = false;
  bool _isValid = false;

  // Selected country (UI only — no real lookup)
  String _selectedFlag = AppConstants.defaultCountryFlag;
  String _selectedCode = AppConstants.defaultCountryCode;

  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  static const List<Map<String, String>> _countries = [
    {'flag': '🇮🇳', 'name': 'India', 'code': '+91'},
    {'flag': '🇺🇸', 'name': 'United States', 'code': '+1'},
    {'flag': '🇬🇧', 'name': 'United Kingdom', 'code': '+44'},
    {'flag': '🇦🇪', 'name': 'UAE', 'code': '+971'},
    {'flag': '🇸🇬', 'name': 'Singapore', 'code': '+65'},
    {'flag': '🇨🇦', 'name': 'Canada', 'code': '+1'},
    {'flag': '🇦🇺', 'name': 'Australia', 'code': '+61'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();

    _phoneController.addListener(() {
      final val = _phoneController.text.trim();
      final valid = val.length >= 7 && val.length <= 15;
      if (valid != _isValid) setState(() => _isValid = valid);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    _phoneFocusNode.unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CountryPickerSheet(
        countries: _countries,
        selected: _selectedCode,
        onSelect: (flag, code) {
          setState(() {
            _selectedFlag = flag;
            _selectedCode = code;
          });
        },
      ),
    );
  }

  void _sendOtp() {
    if (!_isValid) return;
    final phone = '$_selectedCode ${_phoneController.text.trim()}';
    setState(() => _isLoading = true);

    // Simulate network delay (UI only)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamed(
        context,
        AppRoutes.otp,
        arguments: {'phone': phone},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Curved top header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopHeader(onBack: () => Navigator.pop(context)),
          ),

          // ── Main scrollable content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingL,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Space for header
                      const SizedBox(height: 140),

                      // ── Section title
                      const AuthSectionHeader(
                        title: 'Enter your\nmobile number',
                        subtitle: 'We\'ll send you a one-time verification code',
                      ),

                      const SizedBox(height: 36),

                      // ── Phone input row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CountryCodeSelector(
                            flag: _selectedFlag,
                            code: _selectedCode,
                            onTap: _showCountryPicker,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              keyboardType: TextInputType.phone,
                              maxLength: 15,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: AppTextStyles.headlineMedium.copyWith(
                                letterSpacing: 1.5,
                              ),
                              decoration: InputDecoration(
                                hintText: '00000 00000',
                                counterText: '',
                                suffixIcon: _isValid
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.accent,
                                        size: 22,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ── Send OTP button
                      AayuPrimaryButton(
                        label: 'Send OTP',
                        onPressed: _isValid ? _sendOtp : null,
                        isLoading: _isLoading,
                        icon: Icons.send_rounded,
                      ),

                      const SizedBox(height: 24),

                      // ── Secure badge centered
                      const Center(child: SecureBadge()),

                      const SizedBox(height: 40),

                      // ── Info cards row
                      Row(
                        children: [
                          const Expanded(
                            child: InfoChip(
                              icon: Icons.lock_rounded,
                              text: 'Encrypted & Private',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InfoChip(
                              icon: Icons.verified_user_rounded,
                              text: 'HIPAA Compliant',
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top header with wave curve ───────────────────────────────────────────

class _TopHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _TopHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          // Subtle cross grid
          Positioned.fill(
            child: CustomPaint(painter: _LightGridPainter()),
          ),

          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: onBack,
              ),
            ),
          ),

          // Bottom wave clip
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Container(
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            ),
          ),

          // Mini logo at bottom of header
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.monitor_heart_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LightGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;
    const spacing = 28.0;
    const crossSize = 5.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawLine(Offset(x - crossSize, y), Offset(x + crossSize, y), paint);
        canvas.drawLine(Offset(x, y - crossSize), Offset(x, y + crossSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Country Picker Bottom Sheet ──────────────────────────────────────────

class _CountryPickerSheet extends StatelessWidget {
  final List<Map<String, String>> countries;
  final String selected;
  final Function(String flag, String code) onSelect;

  const _CountryPickerSheet({
    required this.countries,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXL),
          topRight: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 42,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Country',
                style: AppTextStyles.headlineMedium,
              ),
            ),
          ),

          const SizedBox(height: 16),

          ...countries.map((c) {
            final isSelected = c['code'] == selected;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 2,
              ),
              leading: Text(c['flag']!, style: const TextStyle(fontSize: 26)),
              title: Text(c['name']!, style: AppTextStyles.titleLarge),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c['code']!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                ],
              ),
              tileColor: isSelected ? AppColors.surfaceVariant : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              onTap: () {
                onSelect(c['flag']!, c['code']!);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }
}