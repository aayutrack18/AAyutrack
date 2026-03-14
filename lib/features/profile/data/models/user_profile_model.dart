import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aayutrack/core/constants/firestore_fields.dart';

class UserProfileModel {
  final String fullName;
  final int? age;
  final String? gender;
  final String? bloodGroup;
  final double? weight;
  final double? height;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? address;
  final List<String> allergies;
  final List<String> medicalConditions;
  final String? photoUrl;
  final String? preferredLanguage;
  final Timestamp? updatedAt;

  const UserProfileModel({
    required this.fullName,
    this.age,
    this.gender,
    this.bloodGroup,
    this.weight,
    this.height,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.address,
    this.allergies = const [],
    this.medicalConditions = const [],
    this.photoUrl,
    this.preferredLanguage,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      FirestoreFields.fullName: fullName,
      FirestoreFields.age: age,
      FirestoreFields.gender: gender,
      FirestoreFields.bloodGroup: bloodGroup,
      FirestoreFields.weight: weight,
      FirestoreFields.height: height,
      FirestoreFields.emergencyContactName: emergencyContactName,
      FirestoreFields.emergencyContactPhone: emergencyContactPhone,
      FirestoreFields.address: address,
      FirestoreFields.allergies: allergies,
      FirestoreFields.medicalConditions: medicalConditions,
      FirestoreFields.photoUrl: photoUrl,
      FirestoreFields.preferredLanguage: preferredLanguage,
      FirestoreFields.updatedAt: updatedAt,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      fullName: map[FirestoreFields.fullName] as String? ?? '',
      age: map[FirestoreFields.age] as int?,
      gender: map[FirestoreFields.gender] as String?,
      bloodGroup: map[FirestoreFields.bloodGroup] as String?,
      weight: (map[FirestoreFields.weight] as num?)?.toDouble(),
      height: (map[FirestoreFields.height] as num?)?.toDouble(),
      emergencyContactName:
          map[FirestoreFields.emergencyContactName] as String?,
      emergencyContactPhone:
          map[FirestoreFields.emergencyContactPhone] as String?,
      address: map[FirestoreFields.address] as String?,
      allergies: List<String>.from(map[FirestoreFields.allergies] ?? const []),
      medicalConditions:
          List<String>.from(map[FirestoreFields.medicalConditions] ?? const []),
      photoUrl: map[FirestoreFields.photoUrl] as String?,
      preferredLanguage: map[FirestoreFields.preferredLanguage] as String?,
      updatedAt: map[FirestoreFields.updatedAt] as Timestamp?,
    );
  }

  UserProfileModel copyWith({
    String? fullName,
    int? age,
    String? gender,
    String? bloodGroup,
    double? weight,
    double? height,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? address,
    List<String>? allergies,
    List<String>? medicalConditions,
    String? photoUrl,
    String? preferredLanguage,
    Timestamp? updatedAt,
  }) {
    return UserProfileModel(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      emergencyContactName:
          emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      address: address ?? this.address,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      photoUrl: photoUrl ?? this.photoUrl,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}