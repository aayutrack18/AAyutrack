import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/profile/data/models/patient_profile_model.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:aayutrack/features/profile/presentation/widgets/profile_dropdown_field.dart';
import 'package:aayutrack/features/profile/presentation/widgets/section_title.dart';

class PatientOnboardingScreen extends ConsumerStatefulWidget {
  const PatientOnboardingScreen({super.key});

  @override
  ConsumerState<PatientOnboardingScreen> createState() =>
      _PatientOnboardingScreenState();
}

class _PatientOnboardingScreenState
    extends ConsumerState<PatientOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _allergiesCtrl = TextEditingController();
  final _conditionsCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();

  String _gender = 'Male';
  String _bloodGroup = 'B+';

  final _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Unknown'];

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _ageCtrl, _phoneCtrl, _emailCtrl,
      _heightCtrl, _weightCtrl, _addressCtrl, _allergiesCtrl,
      _conditionsCtrl, _emergencyNameCtrl, _emergencyPhoneCtrl
    ]) { c.dispose(); }
    super.dispose();
  }

  List<Step> get _steps => [
    Step(
      title: const Text('Personal Info'),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: _buildPersonalStep(),
    ),
    Step(
      title: const Text('Medical Info'),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: _buildMedicalStep(),
    ),
    Step(
      title: const Text('Emergency'),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      content: _buildEmergencyStep(),
    ),
  ];

  Widget _buildPersonalStep() {
    return Column(children: [
      ProfileTextField(
        label: 'Full Name',
        hintText: 'e.g. Rahul Sharma',
        controller: _nameCtrl,
        validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
        textInputAction: TextInputAction.next,
        prefixIcon: const Icon(Icons.person_outline_rounded, size: 18),
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(
          child: ProfileTextField(
            label: 'Age',
            hintText: '45',
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            prefixIcon: const Icon(Icons.cake_outlined, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ProfileDropdownField<String>(
            label: 'Gender',
            hintText: 'Select',
            value: _gender,
            items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (v) => setState(() => _gender = v ?? _gender),
          ),
        ),
      ]),
      const SizedBox(height: 12),
      ProfileTextField(
        label: 'Phone Number',
        hintText: '+91 98765 43210',
        controller: _phoneCtrl,
        keyboardType: TextInputType.phone,
        validator: (v) => v == null || v.isEmpty ? 'Phone is required' : null,
        prefixIcon: const Icon(Icons.phone_outlined, size: 18),
      ),
      const SizedBox(height: 12),
      ProfileTextField(
        label: 'Email (optional)',
        hintText: 'name@email.com',
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: const Icon(Icons.email_outlined, size: 18),
      ),
      const SizedBox(height: 12),
      ProfileTextField(
        label: 'Address (optional)',
        hintText: 'City, State',
        controller: _addressCtrl,
        maxLines: 2,
        prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
      ),
    ]);
  }

  Widget _buildMedicalStep() {
    return Column(children: [
      Row(children: [
        Expanded(
          child: ProfileDropdownField<String>(
            label: 'Blood Group',
            hintText: 'Select',
            value: _bloodGroup,
            items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
            onChanged: (v) => setState(() => _bloodGroup = v ?? _bloodGroup),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ProfileTextField(
            label: 'Height (cm)',
            hintText: '172',
            controller: _heightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Icon(Icons.height_rounded, size: 18),
          ),
        ),
      ]),
      const SizedBox(height: 12),
      ProfileTextField(
        label: 'Weight (kg)',
        hintText: '72',
        controller: _weightCtrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        prefixIcon: const Icon(Icons.monitor_weight_outlined, size: 18),
      ),
      const SizedBox(height: 12),
      ProfileTextField(
        label: 'Medical Conditions',
        hintText: 'e.g. Type 2 Diabetes, Hypertension',
        controller: _conditionsCtrl,
        maxLines: 3,
        helperText: 'List all current diagnosed conditions',
        prefixIcon: const Icon(Icons.medical_information_outlined, size: 18),
      ),
      const SizedBox(height: 12),
      ProfileTextField(
        label: 'Allergies',
        hintText: 'e.g. Penicillin, Sulfa drugs',
        controller: _allergiesCtrl,
        maxLines: 2,
        helperText: 'Include medicine and food allergies',
        prefixIcon: const Icon(Icons.warning_amber_outlined, size: 18),
      ),
    ]);
  }

  Widget _buildEmergencyStep() {
    return Column(children: [
      const SectionTitle(
        title: 'Emergency Contact',
        subtitle: 'This person will be contacted in case of emergency',
        icon: Icons.emergency_rounded,
        iconColor: AppColors.danger,
      ),
      const SizedBox(height: 4),
      ProfileTextField(
        label: 'Contact Name',
        hintText: 'e.g. Priya Sharma',
        controller: _emergencyNameCtrl,
        prefixIcon: const Icon(Icons.person_outline_rounded, size: 18),
      ),
      const SizedBox(height: 12),
      ProfileTextField(
        label: 'Contact Phone',
        hintText: '+91 98765 11111',
        controller: _emergencyPhoneCtrl,
        keyboardType: TextInputType.phone,
        prefixIcon: const Icon(Icons.phone_outlined, size: 18),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: const Row(children: [
          Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your data is stored securely on your device and only shared with your doctor when you choose.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
            ),
          ),
        ]),
      ),
    ]);
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    final profile = PatientProfileModel(
      profileId: 'profile_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_demo',
      fullName: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      gender: _gender,
      phoneNumber: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      bloodGroup: _bloodGroup,
      heightCm: double.tryParse(_heightCtrl.text.trim()),
      weightKg: double.tryParse(_weightCtrl.text.trim()),
      address: _addressCtrl.text.trim(),
      allergies: _allergiesCtrl.text.trim(),
      medicalConditions: _conditionsCtrl.text.trim(),
      emergencyContactName: _emergencyNameCtrl.text.trim(),
      emergencyContactPhone: _emergencyPhoneCtrl.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await ref.read(profileProvider.notifier).createProfile(profile);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => setState(() => _currentStep--),
              )
            : null,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          steps: _steps,
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            final isLast = _currentStep == _steps.length - 1;
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(children: [
                Expanded(
                  child: AppButton(
                    label: isLast ? 'Complete Profile' : 'Continue',
                    isLoading: _isLoading && isLast,
                    icon: isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (isLast) {
                        _submit();
                      } else {
                        setState(() => _currentStep++);
                      }
                    },
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
