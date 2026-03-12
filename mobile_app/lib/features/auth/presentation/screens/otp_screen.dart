import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  int _secondsLeft = AppStrings.resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      AppStrings.otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      AppStrings.otpLength,
      (_) => FocusNode(),
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = AppStrings.resendSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  String get _otp => _controllers.map((e) => e.text).join();

  void _verifyOtp() {
    if (_otp.length != AppStrings.otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete OTP.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: const Text(
          'OTP UI flow is complete. Firebase verification will be connected next.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, AppRoutes.welcome);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
                  label: 'Verify & Continue',
                  icon: Icons.verified_rounded,
                  onPressed: _verifyOtp,
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: _secondsLeft == 0 ? _startTimer : null,
              child: const Text('Resend code'),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Change phone number'),
            ),
          ),
        ],
      ),
    );
  }
}