import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/patient_profile_model.dart';
import '../../utils/profile_validators.dart';
import '../providers/profile_provider.dart';
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

  String? _selectedGender;
  String? _selectedBloodGroup;
  bool _didPopulate = false;

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

    Future.microtask(() {
      ref.listenManual(profileProvider, (previous, next) {
        if (!mounted) return;

        final wasLoading = previous?.isLoading ?? false;
        final isDoneLoading = wasLoading && !next.isLoading;

        if (next.errorMessage != null &&
            next.errorMessage!.trim().isNotEmpty &&
            previous?.errorMessage != next.errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
            ),
          );
        }

        if (isDoneLoading && next.profile != null && next.isProfileCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didPopulate) return;

    final profile = ref.read(profileProvider).profile;
    if (profile != null) {
      _populateFields(profile);
      _didPopulate = true;
    }
  }

  void _populateFields(dynamic profile) {
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

  String _formatDouble(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  @override
  void dispose() {
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

  String? _validateDropdown(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
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

  Widget _buildPageHeader(BuildContext context) {
    final theme = Theme.of(context);

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
            Icons.edit_note_rounded,
            size: 36,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Edit Patient Profile',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Update patient details and keep health records accurate for monitoring and compliance.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              height: 1.4,
            ),
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
        child: ElevatedButton.icon(
          onPressed: isSaving ? null : _updateProfile,
          icon: isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                )
              : const Icon(Icons.save_outlined),
          label: Text(
            isSaving ? 'Saving...' : 'Save Changes',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;
    final mediaQuery = MediaQuery.of(context);
    final horizontalPadding = mediaQuery.size.width < 420 ? 16.0 : 22.0;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 52,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Profile not found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No patient profile data is available in state.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Go Back',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
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
                                      value, 'height'),
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
                                      value, 'weight'),
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
                              prefixIcon:
                                  const Icon(Icons.monitor_weight_outlined),
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
                              hintText: 'Enter medical conditions if any',
                              controller: _medicalConditionsController,
                              maxLines: 3,
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
                          subtitle: 'Emergency support details',
                          icon: Icons.emergency_outlined,
                          children: [
                            ProfileTextField(
                              label: 'Emergency Contact Name',
                              hintText: 'Enter contact person name',
                              controller: _emergencyContactNameController,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.badge_outlined),
                            ),
                            const SizedBox(height: 16),
                            ProfileTextField(
                              label: 'Emergency Contact Phone',
                              hintText: 'Enter 10-digit phone number',
                              controller: _emergencyContactPhoneController,
                              validator: (value) =>
                                  ProfileValidators.validatePhone(
                                value,
                                required: false,
                              ),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              prefixIcon:
                                  const Icon(Icons.contact_phone_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
