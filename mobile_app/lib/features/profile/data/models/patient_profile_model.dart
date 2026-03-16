import 'package:aayutrack/features/profile/domain/entities/patient_profile.dart';

class PatientProfileModel extends PatientProfile {
  const PatientProfileModel({
    required super.profileId,
    required super.userId,
    required super.fullName,
    required super.age,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    required super.bloodGroup,
    super.heightCm,
    super.weightKg,
    required super.address,
    required super.allergies,
    required super.medicalConditions,
    required super.emergencyContactName,
    required super.emergencyContactPhone,
    required super.createdAt,
    required super.updatedAt,
    required super.isSynced,
  });

  factory PatientProfileModel.fromEntity(PatientProfile entity) {
    return PatientProfileModel(
      profileId: entity.profileId,
      userId: entity.userId,
      fullName: entity.fullName,
      age: entity.age,
      gender: entity.gender,
      phoneNumber: entity.phoneNumber,
      email: entity.email,
      bloodGroup: entity.bloodGroup,
      heightCm: entity.heightCm,
      weightKg: entity.weightKg,
      address: entity.address,
      allergies: entity.allergies,
      medicalConditions: entity.medicalConditions,
      emergencyContactName: entity.emergencyContactName,
      emergencyContactPhone: entity.emergencyContactPhone,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      profileId: json['profileId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      bloodGroup: json['bloodGroup'] as String? ?? '',
      heightCm: json['heightCm'] != null
          ? (json['heightCm'] as num).toDouble()
          : null,
      weightKg: json['weightKg'] != null
          ? (json['weightKg'] as num).toDouble()
          : null,
      address: json['address'] as String? ?? '',
      allergies: json['allergies'] as String? ?? '',
      medicalConditions: json['medicalConditions'] as String? ?? '',
      emergencyContactName: json['emergencyContactName'] as String? ?? '',
      emergencyContactPhone: json['emergencyContactPhone'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  factory PatientProfileModel.fromMap(Map<String, dynamic> map) {
    return PatientProfileModel(
      profileId: map['profile_id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      age: map['age'] as int? ?? 0,
      gender: map['gender'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      email: map['email'] as String? ?? '',
      bloodGroup: map['blood_group'] as String? ?? '',
      heightCm: map['height_cm'] != null
          ? (map['height_cm'] as num).toDouble()
          : null,
      weightKg: map['weight_kg'] != null
          ? (map['weight_kg'] as num).toDouble()
          : null,
      address: map['address'] as String? ?? '',
      allergies: map['allergies'] as String? ?? '',
      medicalConditions: map['medical_conditions'] as String? ?? '',
      emergencyContactName: map['emergency_contact_name'] as String? ?? '',
      emergencyContactPhone: map['emergency_contact_phone'] as String? ?? '',
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.now(),
      isSynced: (map['is_synced'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'userId': userId,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
      'bloodGroup': bloodGroup,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'address': address,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'profile_id': profileId,
      'user_id': userId,
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'phone_number': phoneNumber,
      'email': email,
      'blood_group': bloodGroup,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'address': address,
      'allergies': allergies,
      'medical_conditions': medicalConditions,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }
}
