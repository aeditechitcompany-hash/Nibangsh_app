import 'dart:io';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../firebase_options.dart';
import '../api_services/api_constants.dart';
import '../api_services/api_service.dart';
import '../util/app_route.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseNotificationService instance =
  FirebaseNotificationService._();

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final ApiService _api = const ApiService();

  bool _initialized = false;
  final StreamController<RemoteMessage> _notificationController =
  StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get onNotificationReceived =>
      _notificationController.stream;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    try {
      await _requestPermission();
      await _setupBackgroundHandler();
      await _setupForegroundListener();
      await _setupTokenRefresh();
      await _setupNotificationOpen();
      await _handleInitialMessage();

      debugPrint(
        'Firebase Notification Service initialized.',
      );
    } catch (e) {
      debugPrint(
        'Firebase Notification initialization error: $e',
      );
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    debugPrint(
      'FCM permission: ${settings.authorizationStatus}',
    );
  }

  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();

      debugPrint('================================');
      debugPrint('FCM TOKEN');
      debugPrint('$token');
      debugPrint('================================');

      return token;
    } catch (e) {
      debugPrint('FCM getToken error: $e');
      return null;
    }
  }

  Future<void> registerCurrentDeviceToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken =
        await _messaging.getAPNSToken();

        debugPrint('APNs token: $apnsToken');

        if (apnsToken == null) {
          debugPrint(
            'APNs token is not available yet.',
          );
          return;
        }
      }

      final token = await getToken();

      if (token == null || token.trim().isEmpty) {
        debugPrint(
          'Cannot register FCM token because token is empty.',
        );
        return;
      }

      await _sendTokenToBackend(token);
    } catch (e) {
      debugPrint(
        'Register device token error: $e',
      );
    }
  }

  Future<void> _sendTokenToBackend(
      String token,
      ) async {
    try {
      final platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : 'unknown';

      final response = await _api.post(
        url: ApiConstants.deviceToken,
        body: {
          'token': token,
          'platform': platform,
        },
        authenticated: true,
      );

      debugPrint(
        'FCM token registered with backend.',
      );

      debugPrint('Response: $response');
    } catch (e) {
      debugPrint(
        'Failed to register FCM token: $e',
      );
    }
  }

  Future<void> _setupTokenRefresh() async {
    FirebaseMessaging.instance.onTokenRefresh.listen(
          (newToken) async {
        debugPrint('================================');
        debugPrint('FCM TOKEN REFRESHED');
        debugPrint(newToken);
        debugPrint('================================');

        await _sendTokenToBackend(newToken);
      },
      onError: (error) {
        debugPrint(
          'FCM token refresh error: $error',
        );
      },
    );
  }

  Future<void> _setupForegroundListener() async {
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {

        debugPrint('================================');
        debugPrint(
          'Title: ${message.notification?.title}',
        );
        debugPrint(
          'Body: ${message.notification?.body}',
        );
        debugPrint(
          'Data: ${message.data}',
        );
        debugPrint('================================');

        // Update unread notification count.
        _notificationController.add(message);

        // IMPORTANT:
        // Do not automatically navigate when the app
        // is already open.
      },
    );
  }

  Future<void> _setupBackgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  }

  Future<void> _setupNotificationOpen() async {
    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        debugPrint(
          'Notification opened from background.',
        );

        _handleMessage(message);
      },
    );
  }

  Future<void> _handleInitialMessage() async {
    final RemoteMessage? message =
    await _messaging.getInitialMessage();

    if (message == null) {
      return;
    }

    debugPrint(
      'App opened from notification.',
    );

    _handleMessage(message);
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];

    debugPrint(
      'Notification type: $type',
    );

    if (type == 'document_uploaded') {
      Get.toNamed(AppRoute.docs);
      return;
    }

    if (type == 'process_stage') {
      Get.toNamed(AppRoute.home);
      return;
    }

    if (type == 'general') {
      Get.toNamed(
        AppRoute.studentNotifications,
      );
      return;
    }

    Get.toNamed(
      AppRoute.studentNotifications,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint(
    'Background FCM message: ${message.messageId}',
  );

  debugPrint(
    'Background FCM data: ${message.data}',
  );
}