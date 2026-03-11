import 'package:flutter/material.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Reset link UI ready. Firebase reset email will be added next.'),
      ),
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
          const SizedBox(height: 16),
          const AuthHeader(
            title: 'Reset password',
            subtitle: 'Enter your email address and we will send a reset link.',
          ),
          const SizedBox(height: 32),
          GlassCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || !value.contains('@')
                        ? 'Enter a valid email address'
                        : null,
                    decoration: const InputDecoration(
                      hintText: 'Email address',
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryAuthButton(
                    label: 'Send Reset Link',
                    icon: Icons.mark_email_read_outlined,
                    onPressed: _sendResetLink,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
