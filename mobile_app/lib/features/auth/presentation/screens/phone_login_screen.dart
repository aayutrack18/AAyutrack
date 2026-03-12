import 'package:flutter/material.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _countryCode = '+91';
  bool _isLoading = false;

  final List<String> _countryCodes = ['+91', '+1', '+44', '+61', '+971'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushNamed(
      context,
      AppRoutes.otp,
      arguments: {'phoneNumber': '$_countryCode ${_phoneController.text.trim()}'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: AppSpacing.md),
          const AuthHeader(
            title: 'Sign in with phone',
            subtitle: 'Enter your mobile number to receive a verification code.',
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
                    children: [
                      SizedBox(
                        width: 100,
                        child: DropdownButtonFormField<String>(
                          value: _countryCode,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 18),
                          ),
                          items: _countryCodes
                              .map((code) => DropdownMenuItem(
                                    value: code,
                                    child: Text(code,
                                        style: const TextStyle(fontSize: 14)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _countryCode = value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            hintText: 'Enter mobile number',
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter phone number';
                            }
                            if (value.trim().length < 10) {
                              return 'Enter valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryAuthButton(
                    label: _isLoading ? 'Sending OTP...' : 'Send OTP',
                    icon: _isLoading
                        ? Icons.hourglass_top_rounded
                        : Icons.arrow_forward_rounded,
                    onPressed: _isLoading ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const TrustNote(text: 'Standard SMS charges may apply.'),
        ],
      ),
    );
  }
}
