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
      age: _parseInt(json['age']),
      gender: json['gender'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      bloodGroup: json['bloodGroup'] as String? ?? '',
      heightCm: _parseDouble(json['heightCm']),
      weightKg: _parseDouble(json['weightKg']),
      address: json['address'] as String? ?? '',
      allergies: _parseStringListOrString(json['allergies']),
      medicalConditions:
          _parseStringListOrString(json['medicalConditions']),
      emergencyContactName: json['emergencyContactName'] as String? ?? '',
      emergencyContactPhone: json['emergencyContactPhone'] as String? ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  factory PatientProfileModel.fromMap(Map<String, dynamic> map) {
    return PatientProfileModel(
      profileId: map['profile_id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      age: _parseInt(map['age']),
      gender: map['gender'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      email: map['email'] as String? ?? '',
      bloodGroup: map['blood_group'] as String? ?? '',
      heightCm: _parseDouble(map['height_cm']),
      weightKg: _parseDouble(map['weight_kg']),
      address: map['address'] as String? ?? '',
      allergies: _parseStringListOrString(map['allergies']),
      medicalConditions:
          _parseStringListOrString(map['medical_conditions']),
      emergencyContactName:
          map['emergency_contact_name'] as String? ?? '',
      emergencyContactPhone:
          map['emergency_contact_phone'] as String? ?? '',
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
      isSynced: _parseBoolFromSqlite(map['is_synced']),
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

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static bool _parseBoolFromSqlite(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    return false;
  }

  static String _parseStringListOrString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) {
      return value.map((e) => e.toString()).join(', ');
    }
    return value.toString();
  }
}