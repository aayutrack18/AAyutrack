class PatientProfile {
  final String profileId;
  final String userId;
  final String fullName;
  final int age;
  final String gender;
  final String phoneNumber;
  final String email;
  final String bloodGroup;
  final double? heightCm;
  final double? weightKg;
  final String address;
  final String allergies;
  final String medicalConditions;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const PatientProfile({
    required this.profileId,
    required this.userId,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.bloodGroup,
    this.heightCm,
    this.weightKg,
    required this.address,
    required this.allergies,
    required this.medicalConditions,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  PatientProfile copyWith({
    String? profileId,
    String? userId,
    String? fullName,
    int? age,
    String? gender,
    String? phoneNumber,
    String? email,
    String? bloodGroup,
    double? heightCm,
    double? weightKg,
    String? address,
    String? allergies,
    String? medicalConditions,
    String? emergencyContactName,
    String? emergencyContactPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return PatientProfile(
      profileId: profileId ?? this.profileId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      address: address ?? this.address,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
