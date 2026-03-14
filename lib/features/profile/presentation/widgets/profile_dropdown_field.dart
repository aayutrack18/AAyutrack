import 'package:flutter/material.dart';

import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';

class ProfileDropdownField<T> extends StatefulWidget {
  final String label;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final Widget? prefixIcon;
  final String? helperText;

  const ProfileDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.helperText,
  });

  @override
  State<ProfileDropdownField<T>> createState() =>
      _ProfileDropdownFieldState<T>();
}

class _ProfileDropdownFieldState<T> extends State<ProfileDropdownField<T>> {
  bool _isFocused = false;

  Color _borderColor({
    required bool isFocused,
    required bool isEnabled,
  }) {
    if (!isEnabled) {
      return Colors.black.withOpacity(0.04);
    }
    if (isFocused) {
      return AppColors.primary;
    }
    return Colors.black.withOpacity(0.08);
  }

  Color _backgroundColor({
    required bool isFocused,
    required bool isEnabled,
  }) {
    if (!isEnabled) {
      return Colors.black.withOpacity(0.03);
    }
    if (isFocused) {
      return AppColors.primary.withOpacity(0.03);
    }
    return Colors.white;
  }

  List<DropdownMenuItem<T>> _buildSafeItems() {
    return widget.items.map((item) {
      final child = item.child;

      return DropdownMenuItem<T>(
        value: item.value,
        enabled: item.enabled,
        alignment: item.alignment,
        onTap: item.onTap,
        child: child is Text
            ? Text(
                child.data ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: child.style,
              )
            : child,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled;

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
        Focus(
          onFocusChange: (hasFocus) {
            if (_isFocused != hasFocus) {
              setState(() {
                _isFocused = hasFocus;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: _backgroundColor(
                isFocused: _isFocused,
                isEnabled: isEnabled,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: _borderColor(
                  isFocused: _isFocused,
                  isEnabled: isEnabled,
                ),
                width: _isFocused ? 1.4 : 1,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: DropdownButtonFormField<T>(
              initialValue: widget.value,
              items: _buildSafeItems(),
              onChanged: isEnabled ? widget.onChanged : null,
              validator: widget.validator,
              isExpanded: true,
              menuMaxHeight: 300,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color:
                    isEnabled ? AppColors.textSecondary : AppColors.textMuted,
                size: 24,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                helperText: widget.helperText,
                prefixIcon: widget.prefixIcon == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(left: 14, right: 8),
                        child: IconTheme(
                          data: IconThemeData(
                            color: _isFocused
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 20,
                          ),
                          child: widget.prefixIcon!,
                        ),
                      ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 46,
                  minHeight: 46,
                ),
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.prefixIcon == null ? 14 : 10,
                  vertical: 15,
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        isEnabled ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
      ],
    );
  }
}