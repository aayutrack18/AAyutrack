import 'package:flutter/material.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+91';

  final List<String> _countryCodes = ['+91', '+1', '+44', '+61'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.otp,
      arguments: {
        'phoneNumber': '$_countryCode $phone',
      },
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InputLabel(text: 'Phone number'),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    SizedBox(
                      width: 96,
                      child: DropdownButtonFormField<String>(
                        value: _countryCode,
                        decoration: const InputDecoration(),
                        items: _countryCodes
                            .map(
                              (code) => DropdownMenuItem(
                                value: code,
                                child: Text(code),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _countryCode = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          hintText: 'Enter mobile number',
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryAuthButton(
                  label: 'Send OTP',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const TrustNote(text: 'Standard SMS charges may apply.'),
        ],
      ),
    );
  }
}