import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/profile/data/models/patient_profile_model.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_state.dart';
import 'package:aayutrack/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:aayutrack/features/profile/presentation/widgets/profile_dropdown_field.dart';
import 'package:aayutrack/features/profile/presentation/widgets/section_title.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _initialized = false;

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

  void _initFromState(ProfileState state) {
    if (_initialized || state.profile == null) return;
    _initialized = true;
    final p = state.profile!;
    _nameCtrl.text = p.fullName;
    _ageCtrl.text = p.age.toString();
    _phoneCtrl.text = p.phoneNumber;
    _emailCtrl.text = p.email;
    _heightCtrl.text = p.heightCm?.toString() ?? '';
    _weightCtrl.text = p.weightKg?.toString() ?? '';
    _addressCtrl.text = p.address;
    _allergiesCtrl.text = p.allergies;
    _conditionsCtrl.text = p.medicalConditions;
    _emergencyNameCtrl.text = p.emergencyContactName;
    _emergencyPhoneCtrl.text = p.emergencyContactPhone;
    _gender = p.gender;
    _bloodGroup = p.bloodGroup;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final existing = ref.read(profileProvider).profile!;
    final updated = PatientProfileModel(
      profileId: existing.profileId,
      userId: existing.userId,
      fullName: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()) ?? existing.age,
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
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await ref.read(profileProvider.notifier).updateProfile(updated);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Profile updated!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    _initFromState(profileState);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: const Text('Save',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Personal info section
            SectionTitle(
              title: 'Personal Information',
              icon: Icons.person_rounded,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            ProfileTextField(
              label: 'Full Name',
              hintText: 'Full name',
              controller: _nameCtrl,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 18),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: ProfileTextField(
                label: 'Age',
                hintText: '45',
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                prefixIcon: const Icon(Icons.cake_outlined, size: 18),
              )),
              const SizedBox(width: 12),
              Expanded(child: ProfileDropdownField<String>(
                label: 'Gender',
                hintText: 'Select',
                value: _gender,
                items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g, overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (v) => setState(() => _gender = v ?? _gender),
              )),
            ]),
            const SizedBox(height: 12),
            ProfileTextField(
              label: 'Phone',
              hintText: '+91 98765 43210',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              prefixIcon: const Icon(Icons.phone_outlined, size: 18),
            ),
            const SizedBox(height: 12),
            ProfileTextField(
              label: 'Email',
              hintText: 'name@email.com',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, size: 18),
            ),
            const SizedBox(height: 12),
            ProfileTextField(
              label: 'Address',
              hintText: 'City, State',
              controller: _addressCtrl,
              maxLines: 2,
              prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
            ),
            const SizedBox(height: 20),

            // Medical info
            SectionTitle(
              title: 'Medical Information',
              icon: Icons.medical_information_rounded,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            Row(children: [
              Expanded(child: ProfileDropdownField<String>(
                label: 'Blood Group',
                hintText: 'Select',
                value: _bloodGroup,
                items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (v) => setState(() => _bloodGroup = v ?? _bloodGroup),
              )),
              const SizedBox(width: 12),
              Expanded(child: ProfileTextField(
                label: 'Height (cm)',
                hintText: '172',
                controller: _heightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              )),
            ]),
            const SizedBox(height: 12),
            ProfileTextField(
              label: 'Weight (kg)',
              hintText: '72',
              controller: _weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            ProfileTextField(
              label: 'Medical Conditions',
              hintText: 'e.g. Type 2 Diabetes, Hypertension',
              controller: _conditionsCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ProfileTextField(
              label: 'Allergies',
              hintText: 'e.g. Penicillin',
              controller: _allergiesCtrl,
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Emergency contact
            SectionTitle(
              title: 'Emergency Contact',
              icon: Icons.emergency_rounded,
              iconColor: AppColors.danger,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            ProfileTextField(
              label: 'Contact Name',
              hintText: 'Name',
              controller: _emergencyNameCtrl,
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 18),
            ),
            const SizedBox(height: 12),
            ProfileTextField(
              label: 'Contact Phone',
              hintText: '+91 ...',
              controller: _emergencyPhoneCtrl,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined, size: 18),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: 'Save Changes',
              icon: Icons.save_rounded,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _save,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
