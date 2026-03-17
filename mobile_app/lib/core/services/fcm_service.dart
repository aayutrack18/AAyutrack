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
  debugPrint(
    'FCM background notification: '
    '${message.notification?.title} / ${message.notification?.body}',
  );
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

    try {
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
      debugPrint('FCM service initialized successfully');
    } catch (e, st) {
      debugPrint('FCM initialize error: $e');
      debugPrint('$st');
    }
  }

  Future<void> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      debugPrint(
        'FCM permission status: ${settings.authorizationStatus.name}',
      );
    } catch (e, st) {
      debugPrint('FCM permission request error: $e');
      debugPrint('$st');
    }
  }

  Future<void> _configureForegroundPresentation() async {
    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e, st) {
      debugPrint('FCM foreground presentation error: $e');
      debugPrint('$st');
    }
  }

  Future<void> _checkInitialMessage() async {
    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('FCM initial message: ${initialMessage.messageId}');
        debugPrint('FCM initial data: ${initialMessage.data}');
        _handleNotificationNavigation(initialMessage);
      }
    } catch (e, st) {
      debugPrint('FCM initial message error: $e');
      debugPrint('$st');
    }
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        try {
          debugPrint('FCM foreground message: ${message.messageId}');
          debugPrint('FCM foreground data: ${message.data}');
          debugPrint(
            'FCM foreground notification: '
            '${message.notification?.title} / ${message.notification?.body}',
          );

          // For now we log the message.
          // Your NotificationService currently does not expose a generic
          // showNotification(...) method, so local foreground popup display
          // is not triggered here yet.
          //
          // If later you add:
          // NotificationService.instance.showInstantNotification(...)
          // then call it here.
        } catch (e, st) {
          debugPrint('FCM foreground message handling error: $e');
          debugPrint('$st');
        }
      },
      onError: (error) {
        debugPrint('FCM foreground listener error: $error');
      },
    );
  }

  void _listenOpenedMessages() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint('FCM message opened app: ${message.messageId}');
        debugPrint('FCM open data: ${message.data}');
        _handleNotificationNavigation(message);
      },
      onError: (error) {
        debugPrint('FCM onMessageOpenedApp error: $error');
      },
    );
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

    _authSubscription = _auth.authStateChanges().listen(
      (user) async {
        try {
          if (user != null) {
            await _registerCurrentTokenIfSignedIn();
          } else {
            debugPrint('User signed out, deactivating current FCM token');
            await deactivateCurrentDeviceToken();
          }
        } catch (e, st) {
          debugPrint('FCM auth state listener error: $e');
          debugPrint('$st');
        }
      },
      onError: (error) {
        debugPrint('FCM auth subscription error: $error');
      },
    );
  }

  Future<void> _registerCurrentTokenIfSignedIn() async {
    try {
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
    } catch (e, st) {
      debugPrint('FCM register token error: $e');
      debugPrint('$st');
    }
  }

  Future<void> syncTokenForSignedInUser() async {
    await _registerCurrentTokenIfSignedIn();
  }

  Future<void> _saveTokenIfSignedIn(String token) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('Skipping FCM token save: no signed-in user');
        return;
      }

      final now = DateTime.now();

      final model = DeviceTokenModel.create(
        token: token,
        appVersion: '1.0.0',
      );

      final devicesRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('devices');

      final existingDocs = await devicesRef.get();

      for (final doc in existingDocs.docs) {
        final data = doc.data();
        final existingToken = data['token'] as String?;
        final existingPlatform = data['platform'] as String?;

        if (existingPlatform == model.platform && existingToken != token) {
          await doc.reference.set(
            {
              'isActive': false,
              'updatedAt': Timestamp.fromDate(now),
            },
            SetOptions(merge: true),
          );
        }
      }

      final docRef = devicesRef.doc(model.deviceId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        await docRef.set(
          model.copyWith(
            createdAt: now,
            updatedAt: now,
            lastSeenAt: now,
            isActive: true,
          ).toMap(),
          SetOptions(merge: true),
        );
      } else {
        final oldData = snapshot.data() ?? {};
        final existingModel = DeviceTokenModel.fromMap(oldData);

        await docRef.set(
          existingModel.copyWith(
            token: token,
            appVersion: model.appVersion,
            platform: model.platform,
            updatedAt: now,
            lastSeenAt: now,
            isActive: true,
          ).toMap(),
          SetOptions(merge: true),
        );
      }

      debugPrint(
        'FCM token saved for uid=${user.uid}, deviceId=${model.deviceId}',
      );
    } catch (e, st) {
      debugPrint('FCM save token error: $e');
      debugPrint('$st');
    }
  }

  Future<void> deactivateCurrentDeviceToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) return;

      final devicesRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('devices');

      final query = await devicesRef.where('token', isEqualTo: token).get();

      for (final doc in query.docs) {
        await doc.reference.set(
          {
            'isActive': false,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          },
          SetOptions(merge: true),
        );
      }

      debugPrint('FCM current device token deactivated');
    } catch (e, st) {
      debugPrint('FCM deactivate token error: $e');
      debugPrint('$st');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to FCM topic: $topic');
    } catch (e, st) {
      debugPrint('FCM topic subscribe error: $e');
      debugPrint('$st');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from FCM topic: $topic');
    } catch (e, st) {
      debugPrint('FCM topic unsubscribe error: $e');
      debugPrint('$st');
    }
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];

    debugPrint('Handle notification navigation type=$type data=$data');

    // Add route navigation logic here later using your app navigator.
    // Example:
    // if (type == 'medicine_reminder') {
    //   navigatorKey.currentState?.pushNamed('/reminders');
    // }
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> deleteFcmTokenFromDevice() async {
    try {
      await _messaging.deleteToken();
      debugPrint('FCM token deleted from device');
    } catch (e, st) {
      debugPrint('FCM delete token error: $e');
      debugPrint('$st');
    }
  }

  Future<void> signOutCleanup() async {
    try {
      await deactivateCurrentDeviceToken();
      await deleteFcmTokenFromDevice();
      debugPrint('FCM sign-out cleanup completed');
    } catch (e, st) {
      debugPrint('FCM sign-out cleanup error: $e');
      debugPrint('$st');
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _authSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _authSubscription = null;
    _initialized = false;
  }
}