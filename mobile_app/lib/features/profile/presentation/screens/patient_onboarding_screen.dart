import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/patient_profile_model.dart';
import '../../utils/profile_validators.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_avatar_picker.dart';
import '../widgets/profile_dropdown_field.dart';
import '../widgets/profile_text_field.dart';
import '../widgets/section_title.dart';

class PatientOnboardingScreen extends ConsumerStatefulWidget {
  const PatientOnboardingScreen({super.key});

  @override
  ConsumerState<PatientOnboardingScreen> createState() =>
      _PatientOnboardingScreenState();
}

class _PatientOnboardingScreenState
    extends ConsumerState<PatientOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicalConditionsController =
      TextEditingController();
  final TextEditingController _emergencyContactNameController =
      TextEditingController();
  final TextEditingController _emergencyContactPhoneController =
      TextEditingController();

  String? _selectedGender;
  String? _selectedBloodGroup;
  String _selectedAvatarId = ProfileAvatarPicker.avatarOptions.first.id;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroupOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();

    _fullNameController.addListener(_refreshAvatarPreview);

    Future.microtask(() {
      ref.listenManual(profileProvider, (previous, next) {
        if (!mounted) return;

        final wasLoading = previous?.isLoading ?? false;
        final isDoneLoading = wasLoading && !next.isLoading;

        if (next.errorMessage != null &&
            next.errorMessage!.trim().isNotEmpty &&
            previous?.errorMessage != next.errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage!)),
          );
        }

        if (isDoneLoading && next.profile != null && next.isProfileCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile completed successfully'),
            ),
          );

          Navigator.pushReplacementNamed(
            context,
            AppRoutes.patientProfile,
          );
        }
      });
    });
  }

  void _refreshAvatarPreview() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_refreshAvatarPreview);
    _fullNameController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _medicalConditionsController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final now = DateTime.now();

    final profile = PatientProfileModel(
      profileId: 'profile_${now.millisecondsSinceEpoch}',
      userId: 'temp_user_id',
      fullName: _fullNameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      gender: _selectedGender ?? '',
      phoneNumber: _phoneNumberController.text.trim(),
      email: _emailController.text.trim(),
      bloodGroup: _selectedBloodGroup ?? '',
      heightCm: _heightController.text.trim().isEmpty
          ? null
          : double.tryParse(_heightController.text.trim()),
      weightKg: _weightController.text.trim().isEmpty
          ? null
          : double.tryParse(_weightController.text.trim()),
      address: _addressController.text.trim(),
      allergies: _allergiesController.text.trim(),
      medicalConditions: _medicalConditionsController.text.trim(),
      emergencyContactName: _emergencyContactNameController.text.trim(),
      emergencyContactPhone: _emergencyContactPhoneController.text.trim(),
      createdAt: now,
      updatedAt: now,
      isSynced: false,
    );

    await ref.read(profileProvider.notifier).createProfile(profile);
  }

  String? _validateDropdown(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  int _calculateCompletionPercent() {
    final checks = <bool>[
      _fullNameController.text.trim().isNotEmpty,
      _ageController.text.trim().isNotEmpty,
      (_selectedGender ?? '').trim().isNotEmpty,
      _phoneNumberController.text.trim().isNotEmpty,
      _emailController.text.trim().isNotEmpty,
      (_selectedBloodGroup ?? '').trim().isNotEmpty,
      _heightController.text.trim().isNotEmpty,
      _weightController.text.trim().isNotEmpty,
      _addressController.text.trim().isNotEmpty,
      _allergiesController.text.trim().isNotEmpty,
      _medicalConditionsController.text.trim().isNotEmpty,
      _emergencyContactNameController.text.trim().isNotEmpty,
      _emergencyContactPhoneController.text.trim().isNotEmpty,
    ];

    final completed = checks.where((item) => item).length;
    return ((completed / checks.length) * 100).round();
  }

  Widget _buildPageHeader(BuildContext context) {
    final theme = Theme.of(context);
    final completion = _calculateCompletionPercent();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.health_and_safety_rounded,
            size: 36,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Complete Patient Profile',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in patient details to continue using AAYUTRACK. This frontend stays ready for future SQLite and Firestore integration.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: completion / 100,
                    minHeight: 10,
                    backgroundColor: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$completion%',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: title,
            subtitle: subtitle,
            icon: icon,
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isSaving) {
    return SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: isSaving ? null : _saveProfile,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isSaving
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Complete Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final mediaQuery = MediaQuery.of(context);
    final horizontalPadding = mediaQuery.size.width < 420 ? 16.0 : 22.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Onboarding'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPageHeader(context),
                        const SizedBox(height: 20),
                        ProfileAvatarPicker(
                          displayName: _fullNameController.text,
                          selectedAvatarId: _selectedAvatarId,
                          onAvatarSelected: (value) {
                            setState(() {
                              _selectedAvatarId = value;
                            });
                          },
                          enabled: !profileState.isLoading,
                        ),
                        const SizedBox(height: 20),
                        _buildSectionCard(
                          context: context,
                          title: 'Personal Information',
                          subtitle: 'Basic patient details',
                          icon: Icons.person_outline_rounded,
                          children: [
                            ProfileTextField(
                              label: 'Full Name',
                              hintText: 'Enter full name',
                              controller: _fullNameController,
                              validator: ProfileValidators.validateName,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Age',
                              hintText: 'Enter age',
                              controller: _ageController,
                              validator: ProfileValidators.validateAge,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              prefixIcon:
                                  const Icon(Icons.calendar_today_outlined),
                            ),
                            const SizedBox(height: 16),
                            ProfileDropdownField<String>(
                              label: 'Gender',
                              hintText: 'Select gender',
                              value: _selectedGender,
                              items: _genderOptions
                                  .map(
                                    (gender) => DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              validator: (value) =>
                                  _validateDropdown(value, 'Gender'),
                            ),
                            const SizedBox(height: 16),
                            ProfileDropdownField<String>(
                              label: 'Blood Group',
                              hintText: 'Select blood group',
                              value: _selectedBloodGroup,
                              items: _bloodGroupOptions
                                  .map(
                                    (bloodGroup) => DropdownMenuItem<String>(
                                      value: bloodGroup,
                                      child: Text(bloodGroup),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBloodGroup = value;
                                });
                              },
                              validator: (value) =>
                                  _validateDropdown(value, 'Blood group'),
                            ),
                          ],
                        ),
                        _buildSectionCard(
                          context: context,
                          title: 'Contact Information',
                          subtitle: 'How we can reach the patient',
                          icon: Icons.call_outlined,
                          children: [
                            ProfileTextField(
                              label: 'Phone Number',
                              hintText: 'Enter 10-digit phone number',
                              controller: _phoneNumberController,
                              validator: (value) =>
                                  ProfileValidators.validatePhone(value),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              prefixIcon: const Icon(Icons.phone_outlined),
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Email',
                              hintText: 'Enter email address',
                              controller: _emailController,
                              validator: (value) =>
                                  ProfileValidators.validateEmail(value),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Address',
                              hintText: 'Enter current address',
                              controller: _addressController,
                              maxLines: 3,
                              textInputAction: TextInputAction.newline,
                              prefixIcon: const Icon(Icons.home_outlined),
                            ),
                          ],
                        ),
                        _buildSectionCard(
                          context: context,
                          title: 'Health Basics',
                          subtitle: 'Useful details for monitoring and care',
                          icon: Icons.monitor_heart_outlined,
                          children: [
                            ProfileTextField(
                              label: 'Height (cm)',
                              hintText: 'Enter height in cm',
                              controller: _heightController,
                              validator: (value) =>
                                  ProfileValidators.validateNumber(
                                value,
                                'height',
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                              prefixIcon: const Icon(Icons.height),
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Weight (kg)',
                              hintText: 'Enter weight in kg',
                              controller: _weightController,
                              validator: (value) =>
                                  ProfileValidators.validateNumber(
                                value,
                                'weight',
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                              prefixIcon: const Icon(Icons.monitor_weight),
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Allergies',
                              hintText: 'Enter allergies if any',
                              controller: _allergiesController,
                              maxLines: 2,
                              textInputAction: TextInputAction.newline,
                              prefixIcon:
                                  const Icon(Icons.warning_amber_rounded),
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Medical Conditions',
                              hintText: 'Enter known medical conditions',
                              controller: _medicalConditionsController,
                              maxLines: 2,
                              textInputAction: TextInputAction.newline,
                              prefixIcon: const Icon(
                                  Icons.medical_information_outlined),
                            ),
                          ],
                        ),
                        _buildSectionCard(
                          context: context,
                          title: 'Emergency Contact',
                          subtitle: 'Person to contact in urgent situations',
                          icon: Icons.emergency_outlined,
                          children: [
                            ProfileTextField(
                              label: 'Contact Name',
                              hintText: 'Enter emergency contact name',
                              controller: _emergencyContactNameController,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.person_2_outlined),
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Contact Phone',
                              hintText: 'Enter emergency phone number',
                              controller: _emergencyContactPhoneController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                }
                                return ProfileValidators.validatePhone(value);
                              },
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              prefixIcon:
                                  const Icon(Icons.local_phone_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    16,
                  ),
                  child: _buildSaveButton(context, profileState.isLoading),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
