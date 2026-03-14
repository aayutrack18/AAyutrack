import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aayutrack/core/constants/firestore_fields.dart';

class AppUserModel {
  final String uid;
  final String? email;
  final String? phone;
  final String role;
  final String authProvider;
  final bool isProfileComplete;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const AppUserModel({
    required this.uid,
    this.email,
    this.phone,
    required this.role,
    required this.authProvider,
    required this.isProfileComplete,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      FirestoreFields.uid: uid,
      FirestoreFields.email: email,
      FirestoreFields.phone: phone,
      FirestoreFields.role: role,
      FirestoreFields.authProvider: authProvider,
      FirestoreFields.isProfileComplete: isProfileComplete,
      FirestoreFields.createdAt: createdAt,
      FirestoreFields.updatedAt: updatedAt,
    };
  }

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      uid: map[FirestoreFields.uid] as String? ?? '',
      email: map[FirestoreFields.email] as String?,
      phone: map[FirestoreFields.phone] as String?,
      role: map[FirestoreFields.role] as String? ?? 'patient',
      authProvider: map[FirestoreFields.authProvider] as String? ?? 'unknown',
      isProfileComplete:
          map[FirestoreFields.isProfileComplete] as bool? ?? false,
      createdAt: map[FirestoreFields.createdAt] as Timestamp?,
      updatedAt: map[FirestoreFields.updatedAt] as Timestamp?,
    );
  }

  AppUserModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? role,
    String? authProvider,
    bool? isProfileComplete,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return AppUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      authProvider: authProvider ?? this.authProvider,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}