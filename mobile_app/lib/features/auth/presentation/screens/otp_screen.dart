import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  int _secondsLeft = AppStrings.resendSeconds;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(AppStrings.otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(AppStrings.otpLength, (_) => FocusNode());
    _startTimer();

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = AppStrings.resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _otp => _controllers.map((e) => e.text).join();

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();
    if (_otp.length != AppStrings.otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete OTP.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Login successful'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _resendCode() {
    _startTimer();
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: _isVerifying ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: AppSpacing.md),
          AuthHeader(
            title: 'Verify your number',
            subtitle: 'We sent a 6-digit code to ${widget.phoneNumber}',
          ),
          const SizedBox(height: AppSpacing.xxl),
          GlassCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    AppStrings.otpLength,
                    (index) => OtpDigitBox(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      previousFocus: index > 0 ? _focusNodes[index - 1] : null,
                      nextFocus: index < AppStrings.otpLength - 1
                          ? _focusNodes[index + 1]
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryAuthButton(
                  label: _isVerifying ? 'Verifying...' : 'Verify & Continue',
                  icon: _isVerifying
                      ? Icons.hourglass_top_rounded
                      : Icons.verified_rounded,
                  onPressed: _isVerifying ? null : _verifyOtp,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              _secondsLeft > 0
                  ? 'Resend code in ${_secondsLeft}s'
                  : 'You can resend the code now',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed:
                  (_secondsLeft == 0 && !_isVerifying) ? _resendCode : null,
              child: const Text('Resend code'),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: _isVerifying ? null : () => Navigator.pop(context),
              child: const Text('Change phone number'),
            ),
          ),
        ],
      ),
    );
  }
}
