import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? helperText;
  final String? initialValue;
  final FocusNode? focusNode;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.helperText,
    this.initialValue,
    this.focusNode,
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  FocusNode? _internalFocusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  bool get _hasExternalFocusNode => widget.focusNode != null;

  @override
  void initState() {
    super.initState();

    if (!_hasExternalFocusNode) {
      _internalFocusNode = FocusNode();
    }

    _effectiveFocusNode.addListener(_handleFocusChanged);

    if (widget.initialValue != null && widget.controller.text.trim().isEmpty) {
      widget.controller.text = widget.initialValue!;
    }
  }

  @override
  void didUpdateWidget(covariant ProfileTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);

      if (!_hasExternalFocusNode && _internalFocusNode == null) {
        _internalFocusNode = FocusNode();
      }

      _effectiveFocusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChanged);

    if (!_hasExternalFocusNode) {
      _internalFocusNode?.dispose();
    }

    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Color _borderColor({
    required bool isFocused,
    required bool isEnabled,
  }) {
    if (!isEnabled) {
      return Colors.black.withValues(alpha: 0.04);
    }
    if (isFocused) {
      return AppColors.primary;
    }
    return Colors.black.withValues(alpha: 0.08);
  }

  Color _backgroundColor({
    required bool isFocused,
    required bool isEnabled,
    required bool isReadOnly,
  }) {
    if (!isEnabled) {
      return Colors.black.withValues(alpha: 0.03);
    }
    if (isReadOnly) {
      return Colors.black.withValues(alpha: 0.025);
    }
    if (isFocused) {
      return AppColors.primary.withValues(alpha: 0.03);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _effectiveFocusNode.hasFocus;
    final isEnabled = widget.enabled;
    final isMultiline = widget.maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _backgroundColor(
              isFocused: isFocused,
              isEnabled: isEnabled,
              isReadOnly: widget.readOnly,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: _borderColor(
                isFocused: isFocused,
                isEnabled: isEnabled,
              ),
              width: isFocused ? 1.4 : 1,
            ),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            focusNode: _effectiveFocusNode,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: widget.enabled
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                  height: isMultiline ? 1.4 : 1.2,
                  fontWeight: FontWeight.w500,
                ),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: widget.hintText,
              helperText: widget.helperText,
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(
                        left: 14,
                        right: isMultiline ? 10 : 8,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          color: isFocused
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 20,
                        ),
                        child: widget.prefixIcon!,
                      ),
                    ),
              suffixIcon: widget.suffixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: widget.suffixIcon,
                    ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 46,
                minHeight: 46,
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 42,
                minHeight: 42,
              ),
              isDense: true,
              filled: false,
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.prefixIcon == null ? 14 : 10,
                vertical: isMultiline ? 14 : 15,
              ),
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w400,
                  ),
              helperStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    height: 1.35,
                  ),
              errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
