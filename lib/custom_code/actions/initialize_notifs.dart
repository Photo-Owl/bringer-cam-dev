// Automatic FlutterFlow imports
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initializeNotifs() async {
  try {
    final NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      carPlay: true,
      criticalAlert: true,
      sound: true,
      announcement: true,
      provisional: true,
      badge: true,
    );

    if (FirebaseAuth.instance.currentUser != null &&
        notificationSettings.authorizationStatus ==
            AuthorizationStatus.authorized) {
      final String? uid = FirebaseAuth.instance.currentUser!.uid;
      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (uid != null && fcmToken != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'fcmToken': fcmToken});
      }
    }
  } catch (e) {
    print('Error initializing notifications: $e');
  }

  final notifPlugin = FlutterLocalNotificationsPlugin();
  await notifPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('ic_mono'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null && notification.android != null) {
      await notifPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'com.smoose.photoowldev.info',
            'Bringer notifs',
            channelDescription: 'Any notification from bringer',
          ),
        ),
      );
    }
  });

  // Background message handler (optional)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    await const AndroidIntent(
      action: 'com.smoose.photoowldev.action.RESTART_SERVICE',
      package: 'com.smoose.photoowldev',
      componentName: 'com.smoose.photoowldev.receiver.RestartReceiver',
    ).sendBroadcast();
  }
}
