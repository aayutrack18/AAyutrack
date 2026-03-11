import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.inputFormatters,
    this.suffixIcon,
    this.prefixIcon,
  });

  bool get _isMultiline => maxLines > 1;

  TextInputType get _effectiveKeyboardType {
    if (_isMultiline) {
      return TextInputType.multiline;
    }
    return keyboardType ?? TextInputType.text;
  }

  TextInputAction get _effectiveTextInputAction {
    if (_isMultiline) {
      return TextInputAction.newline;
    }
    return textInputAction ?? TextInputAction.next;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: _effectiveKeyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          textInputAction: _effectiveTextInputAction,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            alignLabelWithHint: _isMultiline,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: _isMultiline ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }
}