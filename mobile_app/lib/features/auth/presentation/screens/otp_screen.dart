import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:aayutrack/features/auth/presentation/widgets/otp_input_row.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<OtpInputRowState> _otpKey = GlobalKey();

  int _secondsLeft = AppStrings.resendSeconds;
  int _resendCount = 0;
  Timer? _timer;
  bool _submitting = false;
  String? _localError;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    _startTimer();
    _tryClipboardAutofill();
  }

  void _tryClipboardAutofill() {
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final text = data?.text ?? '';
      final match = RegExp(r'\b(\d{6})\b').firstMatch(text);
      if (match != null) {
        _otpKey.currentState?.pasteOtp(match.group(1)!);
      }
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

  Future<void> _verifyOtp(String otp) async {
    if (otp.length != AppStrings.otpLength || _submitting) return;

    setState(() {
      _submitting = true;
      _localError = null;
    });

    FocusScope.of(context).unfocus();

    final success = await ref
        .read(authStateNotifierProvider.notifier)
        .verifyPhoneOtp(smsCode: otp);

    if (!mounted) return;

    setState(() => _submitting = false);

    if (success) {
      HapticFeedback.mediumImpact();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.profileGate,
        (route) => false,
      );
    } else {
      HapticFeedback.vibrate();
      _shakeController.forward(from: 0);
      _otpKey.currentState?.clear();

      final error = ref.read(authStateNotifierProvider).errorMessage;
      setState(() {
        _localError = error ?? 'OTP verification failed. Please try again.';
      });
    }
  }

  Future<void> _resendCode() async {
    if (_secondsLeft > 0 || _submitting) return;

    setState(() => _localError = null);

    final success = await ref
        .read(authStateNotifierProvider.notifier)
        .sendPhoneOtp(phoneNumber: widget.phoneNumber);

    if (!mounted) return;

    if (success) {
      setState(() => _resendCount++);
      _startTimer();
      _otpKey.currentState?.clear();
      _showSnack('OTP resent to ${widget.phoneNumber}');
    } else {
      final error = ref.read(authStateNotifierProvider).errorMessage;
      setState(() {
        _localError = error ?? 'Failed to resend OTP. Please try again.';
      });
    }
  }

  void _showSnack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(authStateNotifierProvider.select((s) => s.isLoading));
    final busy = isLoading || _submitting;

    return PopScope(
      canPop: !busy,
      child: AuthScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: busy
                  ? null
                  : () {
                      ref
                          .read(authStateNotifierProvider.notifier)
                          .clearPhoneAuthSession();
                      Navigator.pop(context);
                    },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
              ),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthHeader(
              title: 'Verify your number',
              subtitle:
                  'We sent a ${AppStrings.otpLength}-digit code to\n${widget.phoneNumber}',
            ),
            const SizedBox(height: AppSpacing.xxl),
            GlassCard(
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    ),
                    child: OtpInputRow(
                      key: _otpKey,
                      enabled: !busy,
                      onCompleted: _verifyOtp,
                    ),
                  ),
                  if (_localError != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 18,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _localError!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryAuthButton(
                    label: busy ? 'Verifying…' : 'Verify & Continue',
                    icon: busy
                        ? Icons.hourglass_top_rounded
                        : Icons.verified_rounded,
                    onPressed: busy
                        ? null
                        : () {
                            final otp = _otpKey.currentState?.value ?? '';
                            if (otp.length < AppStrings.otpLength) {
                              setState(() {
                                _localError =
                                    'Please enter all ${AppStrings.otpLength} digits.';
                              });
                              return;
                            }
                            _verifyOtp(otp);
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: _secondsLeft > 0
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Resend in ${_secondsLeft}s',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    )
                  : TextButton.icon(
                      onPressed: busy ? null : _resendCode,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Resend code'),
                    ),
            ),
            Center(
              child: TextButton(
                onPressed: busy
                    ? null
                    : () {
                        ref
                            .read(authStateNotifierProvider.notifier)
                            .clearPhoneAuthSession();
                        Navigator.pop(context);
                      },
                child: const Text('Change phone number'),
              ),
            ),
            if (_resendCount > 0)
              Center(
                child: Text(
                  'Code resent $_resendCount time${_resendCount > 1 ? 's' : ''}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            const TrustNote(
              text:
                  'Standard SMS charges may apply. Code expires in 60 seconds.',
            ),
          ],
        ),
      ),
    );
  }
}