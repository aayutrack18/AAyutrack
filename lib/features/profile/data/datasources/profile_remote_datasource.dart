import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aayutrack/features/profile/data/models/patient_profile_model.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');

  Future<void> uploadProfile(PatientProfileModel profile) async {
    if (profile.userId.trim().isEmpty) {
      throw Exception('Cannot upload profile: userId is empty.');
    }

    await _users
        .doc(profile.userId)
        .collection('profile')
        .doc('main')
        .set(profile.toJson(), SetOptions(merge: true));
  }

  Future<PatientProfileModel?> fetchProfile(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('Cannot fetch profile: userId is empty.');
    }

    final doc =
        await _users.doc(userId).collection('profile').doc('main').get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return PatientProfileModel.fromJson(doc.data()!);
  }

  Future<void> deleteProfile(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('Cannot delete profile: userId is empty.');
    }

    await _users.doc(userId).collection('profile').doc('main').delete();
  }
}