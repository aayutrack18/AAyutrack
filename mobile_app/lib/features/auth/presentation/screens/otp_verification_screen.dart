import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/auth_widgets.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  // OTP controllers + focus nodes
  final List<TextEditingController> _controllers = List.generate(
    AppConstants.otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    AppConstants.otpLength,
    (_) => FocusNode(),
  );

  bool _isLoading = false;
  bool _isVerified = false;
  int _resendTimer = AppConstants.resendTimeoutSeconds;
  Timer? _timer;

  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  late final AnimationController _successController;
  late final Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _successScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    // Listen for OTP field changes
    for (int i = 0; i < AppConstants.otpLength; i++) {
      _controllers[i].addListener(() => setState(() {}));
    }

    // Auto-focus first field after render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _animController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = AppConstants.resendTimeoutSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          t.cancel();
        }
      });
    });
  }

  String get _currentOtp =>
      _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _currentOtp.length == AppConstants.otpLength;

  void _onOtpChanged(int index, String value) {
    if (value.isEmpty) {
      // Move back
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    } else {
      // Move forward
      if (index < AppConstants.otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() {});
  }

  void _verifyOtp() {
    if (!_isOtpComplete) return;
    setState(() => _isLoading = true);

    // Simulate verification (UI only)
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
      _successController.forward();

      // Navigate after success animation
      Future.delayed(const Duration(milliseconds: 1600), () {
        if (!mounted) return;
        // TODO: Navigate to dashboard when available
        // Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        _showSuccessDialog();
      });
    });
  }

  void _resendOtp() {
    if (_resendTimer > 0) return;
    // Clear fields
    for (final c in _controllers) {
      c.clear();
    }
    setState(() => _isVerified = false);
    _startResendTimer();
    _focusNodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              'OTP sent to ${widget.phoneNumber}',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 38,
                ),
              ),
              const SizedBox(height: 20),
              Text('Verified!', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Your phone number has been verified successfully.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 24),
              AayuPrimaryButton(
                label: 'Continue to App',
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to dashboard
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _OtpTopHeader(
              phoneNumber: widget.phoneNumber,
              onBack: () => Navigator.pop(context),
            ),
          ),

          // ── Content
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
                      const SizedBox(height: 150),

                      // ── Heading
                      const AuthSectionHeader(
                        title: 'Verify your\nnumber',
                        subtitle: 'Enter the 6-digit code sent to',
                      ),

                      const SizedBox(height: 8),

                      // ── Phone display
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusFull,
                              ),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.phone_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.phoneNumber,
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Change',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryLight,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // ── OTP boxes
                      _isVerified
                          ? Center(
                              child: ScaleTransition(
                                scale: _successScale,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.success,
                                    size: 48,
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                AppConstants.otpLength,
                                (i) => _OtpField(
                                  controller: _controllers[i],
                                  focusNode: _focusNodes[i],
                                  onChanged: (val) => _onOtpChanged(i, val),
                                  isFilled: _controllers[i].text.isNotEmpty,
                                ),
                              ),
                            ),

                      const SizedBox(height: 36),

                      // ── Verify button
                      if (!_isVerified)
                        AayuPrimaryButton(
                          label: 'Verify OTP',
                          onPressed: _isOtpComplete ? _verifyOtp : null,
                          isLoading: _isLoading,
                          icon: Icons.verified_rounded,
                        ),

                      const SizedBox(height: 28),

                      // ── Resend row
                      if (!_isVerified) _ResendRow(
                        timerSeconds: _resendTimer,
                        onResend: _resendOtp,
                      ),

                      const SizedBox(height: 36),

                      // ── Hint card
                      if (!_isVerified)
                        _OtpHintCard(phone: widget.phoneNumber),

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

// ─── OTP Field (single digit) ─────────────────────────────────────────────

class _OtpField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final bool isFilled;

  const _OtpField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isFilled,
  });

  @override
  State<_OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<_OtpField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = widget.focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: widget.isFilled
            ? AppColors.primary.withOpacity(0.07)
            : isFocused
                ? AppColors.surfaceVariant
                : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.isFilled
              ? AppColors.primary
              : isFocused
                  ? AppColors.primaryLight
                  : AppColors.divider,
          width: widget.isFilled || isFocused ? 2.0 : 1.5,
        ),
        boxShadow: widget.isFilled
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
          onChanged: widget.onChanged,
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

// ─── Resend Row ───────────────────────────────────────────────────────────

class _ResendRow extends StatelessWidget {
  final int timerSeconds;
  final VoidCallback onResend;

  const _ResendRow({required this.timerSeconds, required this.onResend});

  @override
  Widget build(BuildContext context) {
    final canResend = timerSeconds == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: AppTextStyles.bodyMedium,
        ),
        canResend
            ? GestureDetector(
                onTap: onResend,
                child: Text(
                  'Resend',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            : Text(
                'Resend in ${timerSeconds}s',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ],
    );
  }
}

// ─── OTP Hint Card ────────────────────────────────────────────────────────

class _OtpHintCard extends StatelessWidget {
  final String phone;

  const _OtpHintCard({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.info_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'OTP has been sent to $phone. Please check your messages.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── OTP Top Header ───────────────────────────────────────────────────────

class _OtpTopHeader extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onBack;

  const _OtpTopHeader({required this.phoneNumber, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF083E82), Color(0xFF0A5FBF)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative dot grid
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
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

          // Progress indicator
          Positioned(
            top: 54,
            right: 24,
            child: SafeArea(
              child: _StepIndicator(step: 2, total: 3),
            ),
          ),

          // Bottom wave
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

          // Bottom mini brand
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sms_rounded,
                  color: Colors.white70,
                  size: 15,
                ),
                const SizedBox(width: 7),
                Text(
                  'OTP Verification',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white70,
                    letterSpacing: 0.5,
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

// ─── Step indicator ───────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int step;
  final int total;

  const _StepIndicator({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i < step;
        return Container(
          width: isActive ? 22 : 8,
          height: 8,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          ),
        );
      }),
    );
  }
}

// ─── Dot Grid Painter ─────────────────────────────────────────────────────

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.06);
    const spacing = 24.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}