import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/medicine_model.dart';

class MedicineFirestoreDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const MedicineFirestoreDataSource({
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

  CollectionReference<Map<String, dynamic>> get _medicinesCollection =>
      firestore.collection('users').doc(_uid).collection('medicines');

  Future<List<MedicineModel>> getMedicines() async {
    final snapshot =
        await _medicinesCollection.orderBy('updatedAt', descending: true).get();

    return snapshot.docs
        .map((doc) => MedicineModel.fromJson(doc.data()))
        .toList();
  }

  Future<MedicineModel?> getMedicineById(String id) async {
    final snapshot = await _medicinesCollection.doc(id).get();

    if (!snapshot.exists) return null;

    final data = snapshot.data();
    if (data == null) return null;

    return MedicineModel.fromJson(data);
  }

  Future<void> saveMedicine(MedicineModel model) async {
    final now = DateTime.now();

    await _medicinesCollection.doc(model.id).set({
      ...model.toJson(),
      'id': model.id,
      'patientId': _uid,
      'isSynced': true,
      'createdAt': model.createdAt.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> updateMedicine(MedicineModel model) async {
    final now = DateTime.now();

    await _medicinesCollection.doc(model.id).set({
      ...model.toJson(),
      'id': model.id,
      'patientId': _uid,
      'isSynced': true,
      'createdAt': model.createdAt.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteMedicine(String id) async {
    await _medicinesCollection.doc(id).delete();
  }
}