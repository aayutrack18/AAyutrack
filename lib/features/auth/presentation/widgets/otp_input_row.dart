import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';

/// A single OTP digit box with full keyboard + paste support.
class OtpInputRow extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final bool enabled;

  const OtpInputRow({
    super.key,
    required this.onCompleted,
    this.length = AppStrings.otpLength,
    this.enabled = true,
  });

  @override
  State<OtpInputRow> createState() => OtpInputRowState();
}

class OtpInputRowState extends State<OtpInputRow> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  String get value => _controllers.map((c) => c.text).join();

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    setState(() {});
    if (mounted) _focusNodes[0].requestFocus();
  }

  /// Pastes a numeric string across the digit boxes.
  void pasteOtp(String text) => _pasteOtp(text);

  void _pasteOtp(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    HapticFeedback.lightImpact();

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].text = i < digits.length ? digits[i] : '';
    }

    final focusIndex =
        (digits.length >= widget.length ? widget.length - 1 : digits.length)
            .clamp(0, widget.length - 1);
    _focusNodes[focusIndex].requestFocus();

    if (digits.length >= widget.length) {
      widget.onCompleted(value);
    }
    setState(() {});
  }

  void _onChanged(int index, String val) {
    if (val.length > 1) {
      // Paste detected in a single box
      _pasteOtp(val);
      return;
    }

    if (val.isNotEmpty) {
      HapticFeedback.selectionClick();
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (value.length == widget.length) {
          widget.onCompleted(value);
        }
      }
    }
    setState(() {});
  }

  void _onKey(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  @override
  void dispose() {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
        (index) => _OtpBox(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          enabled: widget.enabled,
          hasValue: _controllers[index].text.isNotEmpty,
          onChanged: (v) => _onChanged(index, v),
          onKey: (e) => _onKey(index, e),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool hasValue;
  final ValueChanged<String> onChanged;
  final ValueChanged<RawKeyEvent> onKey;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hasValue,
    required this.onChanged,
    required this.onKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.otpBox,
      height: AppSizes.otpBox + 8,
      child: RawKeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKey: onKey,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: hasValue ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: hasValue ? AppColors.primary : AppColors.border,
              width: hasValue ? 2 : 1.5,
            ),
            boxShadow: hasValue
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: 0,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
