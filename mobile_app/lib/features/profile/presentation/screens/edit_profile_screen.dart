import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/patient_profile_model.dart';
import '../../domain/entities/patient_profile.dart';
import '../../utils/profile_validators.dart';
import '../providers/profile_provider.dart';
import '../providers/profile_state.dart';
import '../widgets/profile_avatar_picker.dart';
import '../widgets/profile_dropdown_field.dart';
import '../widgets/profile_text_field.dart';
import '../widgets/section_title.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
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

  bool _didPopulate = false;
  bool _hasUnsavedChanges = false;
  bool _isNavigatingBack = false;
  String? _lastHandledErrorMessage;
  Map<String, String>? _initialFormSnapshot;

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
        final didFinishLoading = wasLoading && !next.isLoading;

        final errorMessage = next.errorMessage?.trim();
        if (errorMessage != null &&
            errorMessage.isNotEmpty &&
            errorMessage != _lastHandledErrorMessage) {
          _lastHandledErrorMessage = errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }

        if (didFinishLoading &&
            previous?.profile != null &&
            next.profile != null &&
            next.errorMessage == null &&
            !_isNavigatingBack) {
          _isNavigatingBack = true;
          _captureInitialSnapshot();
          _hasUnsavedChanges = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );

          Navigator.pop(context);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didPopulate) return;

    final profile = ref.read(profileProvider).profile;
    if (profile != null) {
      _populateFields(profile);
      _captureInitialSnapshot();
      _didPopulate = true;
    }
  }

  void _populateFields(PatientProfile profile) {
    _fullNameController.text = profile.fullName;
    _ageController.text = profile.age.toString();
    _phoneNumberController.text = profile.phoneNumber;
    _emailController.text = profile.email;
    _addressController.text = profile.address;
    _heightController.text =
        profile.heightCm != null ? _formatDouble(profile.heightCm!) : '';
    _weightController.text =
        profile.weightKg != null ? _formatDouble(profile.weightKg!) : '';
    _allergiesController.text = profile.allergies;
    _medicalConditionsController.text = profile.medicalConditions;
    _emergencyContactNameController.text = profile.emergencyContactName;
    _emergencyContactPhoneController.text = profile.emergencyContactPhone;
    _selectedGender = profile.gender;
    _selectedBloodGroup = profile.bloodGroup;
  }

  void _captureInitialSnapshot() {
    _initialFormSnapshot = _buildCurrentSnapshot();
  }

  Map<String, String> _buildCurrentSnapshot() {
    return {
      'fullName': _fullNameController.text.trim(),
      'age': _ageController.text.trim(),
      'phoneNumber': _phoneNumberController.text.trim(),
      'email': _emailController.text.trim(),
      'address': _addressController.text.trim(),
      'height': _heightController.text.trim(),
      'weight': _weightController.text.trim(),
      'allergies': _allergiesController.text.trim(),
      'medicalConditions': _medicalConditionsController.text.trim(),
      'emergencyContactName': _emergencyContactNameController.text.trim(),
      'emergencyContactPhone': _emergencyContactPhoneController.text.trim(),
      'gender': (_selectedGender ?? '').trim(),
      'bloodGroup': (_selectedBloodGroup ?? '').trim(),
    };
  }

  bool _calculateHasUnsavedChanges() {
    final baseline = _initialFormSnapshot;
    if (baseline == null) return false;

    final current = _buildCurrentSnapshot();
    for (final entry in current.entries) {
      if (baseline[entry.key] != entry.value) {
        return true;
      }
    }
    return false;
  }

  String _formatDouble(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
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

  Future<void> _updateProfile() async {
    final currentProfile = ref.read(profileProvider).profile;

    if (currentProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No profile data found to update'),
        ),
      );
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (!_hasUnsavedChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes to save'),
        ),
      );
      return;
    }

    final updatedProfile = PatientProfileModel(
      profileId: currentProfile.profileId,
      userId: currentProfile.userId,
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
      createdAt: currentProfile.createdAt,
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await ref.read(profileProvider.notifier).updateProfile(updatedProfile);
  }

  Future<bool> _handleBackNavigation() async {
    if (!_hasUnsavedChanges) return true;

    final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Discard changes?'),
              content: const Text(
                'You have unsaved profile changes. If you go back now, those edits will be lost.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Stay'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard'),
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
            Icons.edit_note_rounded,
            size: 36,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Edit Patient Profile',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Update patient details and keep records accurate for monitoring, reminders, and future sync.',
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
                    ? 'Unsaved changes'
                    : 'All changes saved',
                color: _hasUnsavedChanges ? Colors.orange : AppColors.success,
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
              'Profile updates are saved locally for now and remain ready for future SQLite / Firestore sync integration.',
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

  Widget _buildActionBar(bool isLoading) {
    final canSave = !isLoading && _hasUnsavedChanges;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasUnsavedChanges && !isLoading)
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
                      'You have unsaved profile updates.',
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
                  onPressed: isLoading
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
                    onPressed: canSave ? _updateProfile : null,
                    icon: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.3,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      isLoading
                          ? 'Saving...'
                          : (_hasUnsavedChanges
                              ? 'Save Changes'
                              : 'No Changes'),
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

  Future<void> _handleGenderChanged(String? value) async {
    setState(() {
      _selectedGender = value;
      _hasUnsavedChanges = _calculateHasUnsavedChanges();
    });
  }

  Future<void> _handleBloodGroupChanged(String? value) async {
    setState(() {
      _selectedBloodGroup = value;
      _hasUnsavedChanges = _calculateHasUnsavedChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;
    final horizontalPadding =
        MediaQuery.of(context).size.width < AppSizes.maxContentWidth
            ? 16.0
            : 22.0;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_off_outlined,
                      size: 46,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Profile not available',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No patient profile data is available in state right now.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Go Back'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

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
          title: const Text('Edit Profile'),
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
                            subtitle: 'Patient communication details',
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
                            subtitle: 'Useful health details for monitoring',
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
                            subtitle: 'Important contact during emergencies',
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
