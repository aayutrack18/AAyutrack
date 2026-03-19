import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/services/demo_data_seed_service.dart';
import 'core/services/fcm_service.dart';
import 'core/sync/sync_providers.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  } catch (e, st) {
    debugPrint('Firebase startup failed: $e');
    debugPrintStack(stackTrace: st);
  }

  try {
    await FcmService.instance.initialize();
  } catch (e, st) {
    debugPrint('FCM initialization failed: $e');
    debugPrintStack(stackTrace: st);
  }

  try {
    await container.read(demoDataSeedServiceProvider).seedIfNeeded();
  } catch (e, st) {
    debugPrint('Demo data seed failed: $e');
    debugPrintStack(stackTrace: st);
  }

  try {
    await container.read(appStartupSyncProvider);
  } catch (e, st) {
    debugPrint('Startup sync failed: $e');
    debugPrintStack(stackTrace: st);
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        await FcmService.instance.syncTokenForSignedInUser();
      } catch (e, st) {
        debugPrint('FCM token sync failed: $e');
        debugPrintStack(stackTrace: st);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}