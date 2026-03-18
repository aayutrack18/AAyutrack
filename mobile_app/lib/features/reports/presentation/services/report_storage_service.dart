import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class UploadedReportResult {
  final String reportId;
  final String downloadUrl;
  final String storagePath;

  const UploadedReportResult({
    required this.reportId,
    required this.downloadUrl,
    required this.storagePath,
  });
}

class ReportStorageService {
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const ReportStorageService({
    required this.storage,
    required this.firestore,
    required this.auth,
  });

  String get _uid {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception('User not logged in');
    }
    return uid;
  }

  Future<UploadedReportResult> uploadReport({
    required File file,
    required String title,
    required String dateRange,
    required String templateId,
    required int pageCount,
  }) async {
    if (!await file.exists()) {
      throw Exception('Report file not found');
    }

    final now = DateTime.now();
    final reportId = now.microsecondsSinceEpoch.toString();
    final fileName = p.basename(file.path);
    final storagePath = 'users/$_uid/reports/$reportId/$fileName';

    final ref = storage.ref().child(storagePath);

    final metadata = SettableMetadata(
      contentType: 'application/pdf',
      customMetadata: {
        'userId': _uid,
        'reportId': reportId,
        'templateId': templateId,
      },
    );

    await ref.putFile(file, metadata);
    final downloadUrl = await ref.getDownloadURL();

    await firestore
        .collection('users')
        .doc(_uid)
        .collection('reports')
        .doc(reportId)
        .set({
      'reportId': reportId,
      'userId': _uid,
      'title': title,
      'dateRange': dateRange,
      'templateId': templateId,
      'pageCount': pageCount,
      'fileName': fileName,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    });

    return UploadedReportResult(
      reportId: reportId,
      downloadUrl: downloadUrl,
      storagePath: storagePath,
    );
  }

  Future<void> deleteReport({
    required String reportId,
    required String storagePath,
  }) async {
    await storage.ref().child(storagePath).delete();

    await firestore
        .collection('users')
        .doc(_uid)
        .collection('reports')
        .doc(reportId)
        .delete();
  }
}