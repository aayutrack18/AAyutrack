import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:aayutrack/core/models/device_token_model.dart';
import 'package:aayutrack/core/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background message: ${message.messageId}');
  debugPrint('FCM background data: ${message.data}');
}

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<User?>? _authSubscription;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await NotificationService.instance.ensureInitialized();
    await NotificationService.instance.requestPermissions();

    await _requestPermission();
    await _configureForegroundPresentation();
    await _registerCurrentTokenIfSignedIn();
    await _checkInitialMessage();

    _listenTokenRefresh();
    _listenAuthChanges();
    _listenForegroundMessages();
    _listenOpenedMessages();

    _initialized = true;
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    debugPrint('FCM permission status: ${settings.authorizationStatus.name}');
  }

  Future<void> _configureForegroundPresentation() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('FCM initial message: ${initialMessage.messageId}');
      debugPrint('FCM initial data: ${initialMessage.data}');
    }
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM foreground message: ${message.messageId}');
      debugPrint('FCM foreground data: ${message.data}');
      if (message.notification != null) {
        debugPrint(
          'FCM foreground notification: '
          '${message.notification?.title} / ${message.notification?.body}',
        );
      }
    });
  }

  void _listenOpenedMessages() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM message opened app: ${message.messageId}');
      debugPrint('FCM open data: ${message.data}');
    });
  }

  void _listenTokenRefresh() {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (token) async {
        debugPrint('FCM token refreshed');
        await _saveTokenIfSignedIn(token);
      },
      onError: (error) {
        debugPrint('FCM token refresh error: $error');
      },
    );
  }

  void _listenAuthChanges() {
    _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await _registerCurrentTokenIfSignedIn();
      }
    });
  }

  Future<void> _registerCurrentTokenIfSignedIn() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('FCM token not saved: no signed-in user');
      return;
    }

    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) {
      debugPrint('FCM token unavailable');
      return;
    }

    debugPrint('FCM TOKEN: $token');
    await _saveTokenIfSignedIn(token);
  }

  Future<void> syncTokenForSignedInUser() async {
    await _registerCurrentTokenIfSignedIn();
  }

  Future<void> _saveTokenIfSignedIn(String token) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('Skipping FCM token save: no signed-in user');
      return;
    }

    final model = DeviceTokenModel.create(
      token: token,
      appVersion: '1.0.0',
    );

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('devices')
        .doc(model.deviceId);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set(model.toMap(), SetOptions(merge: true));
    } else {
      await docRef.set(
        model.copyWith(
          updatedAt: DateTime.now(),
          lastSeenAt: DateTime.now(),
          isActive: true,
        ).toMap(),
        SetOptions(merge: true),
      );
    }

    debugPrint(
      'FCM token saved for uid=${user.uid}, deviceId=${model.deviceId}',
    );
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _authSubscription?.cancel();
  }
}