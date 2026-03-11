import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/patient_profile_model.dart';
import '../../utils/profile_validators.dart';
import '../providers/profile_provider.dart';
import '../providers/profile_state.dart';
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

  late final TextEditingController _fullNameController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _medicalConditionsController;
  late final TextEditingController _emergencyContactNameController;
  late final TextEditingController _emergencyContactPhoneController;

  ProviderSubscription<ProfileState>? _profileSubscription;

  String? _selectedGender;
  String? _selectedBloodGroup;
  String _selectedAvatarId = ProfileAvatarPicker.avatarOptions.first.id;

  bool _hasUnsavedChanges = false;
  bool _isNavigatingForward = false;
  String? _lastHandledErrorMessage;

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

    _fullNameController = TextEditingController();
    _ageController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _allergiesController = TextEditingController();
    _medicalConditionsController = TextEditingController();
    _emergencyContactNameController = TextEditingController();
    _emergencyContactPhoneController = TextEditingController();

    _addFieldListeners();

    _profileSubscription = ref.listenManual<ProfileState>(
      profileProvider,
      (previous, next) {
        if (!mounted) return;

        final wasLoading = previous?.isLoading ?? false;
        final isDoneLoading = wasLoading && !next.isLoading;

        final errorMessage = next.errorMessage?.trim();
        if (errorMessage != null &&
            errorMessage.isNotEmpty &&
            errorMessage != _lastHandledErrorMessage) {
          _lastHandledErrorMessage = errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }

        if (isDoneLoading &&
            next.profile != null &&
            next.isProfileCompleted &&
            next.errorMessage == null &&
            !_isNavigatingForward) {
          _isNavigatingForward = true;
          _hasUnsavedChanges = false;

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
      },
    );
  }

  void _addFieldListeners() {
    final controllers = [
      _fullNameController,
      _ageController,
      _phoneNumberController,
      _emailController,
      _addressController,
      _heightController,
      _weightController,
      _allergiesController,
      _medicalConditionsController,
      _emergencyContactNameController,
      _emergencyContactPhoneController,
    ];

    for (final controller in controllers) {
      controller.addListener(_handleFormChanged);
    }
  }

  void _handleFormChanged() {
    if (!mounted) return;

    setState(() {
      _hasUnsavedChanges = _calculateHasUnsavedChanges();
    });
  }

  bool _calculateHasUnsavedChanges() {
    return _fullNameController.text.trim().isNotEmpty ||
        _ageController.text.trim().isNotEmpty ||
        _phoneNumberController.text.trim().isNotEmpty ||
        _emailController.text.trim().isNotEmpty ||
        _addressController.text.trim().isNotEmpty ||
        _heightController.text.trim().isNotEmpty ||
        _weightController.text.trim().isNotEmpty ||
        _allergiesController.text.trim().isNotEmpty ||
        _medicalConditionsController.text.trim().isNotEmpty ||
        _emergencyContactNameController.text.trim().isNotEmpty ||
        _emergencyContactPhoneController.text.trim().isNotEmpty ||
        (_selectedGender ?? '').trim().isNotEmpty ||
        (_selectedBloodGroup ?? '').trim().isNotEmpty ||
        _selectedAvatarId != ProfileAvatarPicker.avatarOptions.first.id;
  }

  @override
  void dispose() {
    _profileSubscription?.close();

    final controllers = [
      _fullNameController,
      _ageController,
      _phoneNumberController,
      _emailController,
      _addressController,
      _heightController,
      _weightController,
      _allergiesController,
      _medicalConditionsController,
      _emergencyContactNameController,
      _emergencyContactPhoneController,
    ];

    for (final controller in controllers) {
      controller.removeListener(_handleFormChanged);
      controller.dispose();
    }

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

  Future<bool> _handleBackNavigation() async {
    if (!_hasUnsavedChanges) return true;

    final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Leave onboarding?'),
              content: const Text(
                'You have entered profile information that is not saved yet. If you go back now, those details will be lost.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Stay'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Leave'),
                ),
              ],
            );
          },
        ) ??
        false;

    return shouldLeave;
  }

  Widget _buildPageHeader(BuildContext context) {
    final theme = Theme.of(context);
    final completion = _calculateCompletionPercent();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
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
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in patient details to continue using AAYUTRACK. This frontend remains ready for future SQLite and Firestore integration.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
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
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.edit_outlined,
                label: _hasUnsavedChanges
                    ? 'Form in progress'
                    : 'Start profile setup',
                color: _hasUnsavedChanges ? Colors.orange : AppColors.primary,
              ),
              const _InfoChip(
                icon: Icons.image_outlined,
                label: 'Avatar preview only',
                color: AppColors.primary,
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
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

  Widget _buildSyncBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.18),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.sync_problem_outlined,
            size: 18,
            color: Colors.orange,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Profile creation is currently frontend and local-data ready. SQLite, Firestore, and backend sync will be integrated later by the relevant teams.',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(bool isSaving) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasUnsavedChanges && !isSaving)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.14),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Complete the form and save to create the patient profile.',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final navigator = Navigator.of(context);
                          final canLeave = await _handleBackNavigation();
                          if (!mounted || !canLeave) return;
                          navigator.pop();
                        },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : _saveProfile,
                    icon: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.3,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      isSaving ? 'Saving...' : 'Complete Profile',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleGenderChanged(String? value) {
    setState(() {
      _selectedGender = value;
      _hasUnsavedChanges = _calculateHasUnsavedChanges();
    });
  }

  void _handleBloodGroupChanged(String? value) {
    setState(() {
      _selectedBloodGroup = value;
      _hasUnsavedChanges = _calculateHasUnsavedChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final mediaQuery = MediaQuery.of(context);
    final horizontalPadding =
        mediaQuery.size.width < AppSizes.maxContentWidth ? 16.0 : 22.0;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final navigator = Navigator.of(context);
        final canLeave = await _handleBackNavigation();
        if (!mounted || !canLeave) return;
        navigator.pop();
      },
      child: Scaffold(
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
                          const SizedBox(height: 18),
                          _buildSyncBanner(),
                          ProfileAvatarPicker(
                            displayName: _fullNameController.text,
                            selectedAvatarId: _selectedAvatarId,
                            onAvatarSelected: (value) {
                              setState(() {
                                _selectedAvatarId = value;
                                _hasUnsavedChanges =
                                    _calculateHasUnsavedChanges();
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
                                onChanged: _handleGenderChanged,
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
                                onChanged: _handleBloodGroupChanged,
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
                                  Icons.medical_information_outlined,
                                ),
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
                    child: _buildActionBar(profileState.isLoading),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
