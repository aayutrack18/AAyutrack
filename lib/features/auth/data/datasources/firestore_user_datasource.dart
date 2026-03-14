import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user_model.dart';

class FirestoreUserDataSource {
  final FirebaseFirestore firestore;

  FirestoreUserDataSource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      firestore.collection('users');

  /// Saves (creates or merges) a user document in Firestore.
  Future<void> saveUserProfile(AppUserModel user) async {
    await _usersCollection.doc(user.uid).set(
          user.toMap(),
          SetOptions(merge: true),
        );
  }

  /// Returns the AppUserModel for [uid], or null if the document doesn't exist.
  Future<AppUserModel?> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return AppUserModel.fromMap(doc.data()!, doc.id);
  }
}
