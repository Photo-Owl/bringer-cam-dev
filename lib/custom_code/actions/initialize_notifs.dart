// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> initializeNotifs() async {
  await Firebase.initializeApp();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  try {
    final NotificationSettings notificationSettings =
        await _firebaseMessaging.requestPermission(
      alert: true,
      carPlay: true,
      criticalAlert: true,
      sound: true,
      announcement: true,
      provisional: true,
      badge: true,
    );

    if (_auth.currentUser != null &&
        notificationSettings.authorizationStatus ==
            AuthorizationStatus.authorized) {
      final String? uid = _auth.currentUser!.uid;
      final String? fcmToken = await _firebaseMessaging.getToken();

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

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      final FlutterLocalNotificationsPlugin notifPlugin =
          FlutterLocalNotificationsPlugin();
      final AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');

      notifPlugin.initialize(
        InitializationSettings(android: initializationSettingsAndroid),
      );

      notifPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'com.smoose.photoowldev.uploads',
            'Upload notification',
            icon: android.smallIcon,
            importance: Importance.min,
            playSound: true,
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
