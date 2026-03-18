import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/patient_profile_model.dart';

class ProfileFirestoreDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const ProfileFirestoreDataSource({
    required this.firestore,
    required this.auth,
  });

  String get _uid {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception('User not authenticated');
    }
    return uid;
  }

  DocumentReference<Map<String, dynamic>> get _profileDoc =>
      firestore.collection('users').doc(_uid).collection('profile').doc('main');

  Future<PatientProfileModel?> getProfile() async {
    final snapshot = await _profileDoc.get();

    if (!snapshot.exists) return null;

    final data = snapshot.data();
    if (data == null) return null;

    return PatientProfileModel.fromJson(data);
  }

  Future<void> saveProfile(PatientProfileModel model) async {
    final now = DateTime.now();

    await _profileDoc.set({
      ...model.toJson(),
      'profileId': model.profileId,
      'userId': _uid,
      'isSynced': true,
      'createdAt': model.createdAt.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> updateProfile(PatientProfileModel model) async {
    final now = DateTime.now();

    await _profileDoc.set({
      ...model.toJson(),
      'profileId': model.profileId,
      'userId': _uid,
      'isSynced': true,
      'createdAt': model.createdAt.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteProfile() async {
    await _profileDoc.delete();
  }
}