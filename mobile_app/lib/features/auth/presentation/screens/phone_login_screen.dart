import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

const List<_CountryCode> _countryCodes = [
  _CountryCode(flag: '🇮🇳', code: '+91', name: 'India', digits: 10),
  _CountryCode(flag: '🇺🇸', code: '+1', name: 'USA', digits: 10),
  _CountryCode(flag: '🇬🇧', code: '+44', name: 'UK', digits: 10),
  _CountryCode(flag: '🇦🇺', code: '+61', name: 'Australia', digits: 9),
  _CountryCode(flag: '🇦🇪', code: '+971', name: 'UAE', digits: 9),
  _CountryCode(flag: '🇸🇬', code: '+65', name: 'Singapore', digits: 8),
];

class _CountryCode {
  final String flag;
  final String code;
  final String name;
  final int digits;
  const _CountryCode(
      {required this.flag,
      required this.code,
      required this.name,
      required this.digits});
}

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  _CountryCode _selected = _countryCodes.first;
  String? _localError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _localError = null);
    if (!_formKey.currentState!.validate()) return;

    final raw =
        _phoneController.text.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final fullNumber = '${_selected.code}$raw';

    final success = await ref
        .read(authStateNotifierProvider.notifier)
        .sendPhoneOtp(phoneNumber: fullNumber);

    if (!mounted) return;

    if (success) {
      final state = ref.read(authStateNotifierProvider);
      if (state.isAuthenticated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.profileGate,
          (route) => false,
        );
        return;
      }
      Navigator.pushNamed(
        context,
        AppRoutes.otp,
        arguments: {'phoneNumber': fullNumber},
      );
    } else {
      // Show full error on screen so user can see exactly what went wrong
      final error = ref.read(authStateNotifierProvider).errorMessage;
      setState(() {
        _localError = error ?? 'Failed to send OTP. Please try again.';
      });
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountryPickerSheet(
        selected: _selected,
        onSelect: (c) {
          setState(() => _selected = c);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(authStateNotifierProvider.select((s) => s.isLoading));

    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: isLoading ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: AppSpacing.md),
          const AuthHeader(
            title: 'Sign in with phone',
            subtitle:
                'Enter your mobile number to receive a verification code.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          GlassCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InputLabel(text: 'Phone number'),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country picker
                      GestureDetector(
                        onTap: isLoading ? null : _showCountryPicker,
                        child: Container(
                          height: 56,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                            color: AppColors.surface,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_selected.flag,
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 4),
                              Text(
                                _selected.code,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary),
                              ),
                              const Icon(Icons.arrow_drop_down_rounded,
                                  size: 18, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                                _selected.digits + 1),
                          ],
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            hintText:
                                'Enter ${_selected.digits}-digit number',
                            suffixIcon: _phoneController.text.isNotEmpty
                                ? IconButton(
                                    icon:
                                        const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _phoneController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (value) {
                            final cleaned = value
                                    ?.trim()
                                    .replaceAll(
                                        RegExp(r'[\s\-\(\)]'), '') ??
                                '';
                            if (cleaned.isEmpty) return 'Enter phone number';
                            if (cleaned.length < _selected.digits) {
                              return 'Enter ${_selected.digits}-digit number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  // ── Inline error box ──────────────────────────────────
                  if (_localError != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius:
                            BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.error_outline_rounded,
                              size: 18, color: Colors.red.shade700),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _localError!,
                              style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),
                  PrimaryAuthButton(
                    label: isLoading ? 'Sending OTP…' : 'Send OTP',
                    icon: isLoading
                        ? Icons.hourglass_top_rounded
                        : Icons.sms_rounded,
                    onPressed: isLoading ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const TrustNote(
              text:
                  'We will send a one-time SMS code. Standard rates apply.'),
        ],
      ),
    );
  }
}

class _CountryPickerSheet extends StatelessWidget {
  final _CountryCode selected;
  final ValueChanged<_CountryCode> onSelect;

  const _CountryPickerSheet(
      {required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text('Select country',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        const Divider(height: 1),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _countryCodes.length,
          itemBuilder: (context, index) {
            final c = _countryCodes[index];
            final isSelected =
                c.code == selected.code && c.name == selected.name;
            return ListTile(
              leading:
                  Text(c.flag, style: const TextStyle(fontSize: 24)),
              title: Text(c.name),
              trailing: Text(
                c.code,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textMuted,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedTileColor: AppColors.primary.withOpacity(0.06),
              onTap: () => onSelect(c),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
