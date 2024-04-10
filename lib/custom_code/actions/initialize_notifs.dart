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

// Import libraries
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Function to create notification with Awesome Notifications
void createAwesomeNotification(String title, String body) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: UniqueKey().hashCode,
      channelKey:
          'com.smoose.photoowldev.uploads', // You can customize this channel key
      title: title,
      body: body,
    ),
  );
}

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

  // Configure Awesome Notifications channels (optional)
  AwesomeNotifications().setNotificationChannel(
    channelKey:
        'com.smoose.photoowldev.uploads', // Same as used in createNotification
    channelName: 'Upload notification',
    channelDescription: 'Notifications for general information',
    defaultColor: Color(0xFF0000FF), // Customize notification color
    playSound: true, // Enable sound
    importance: Importance.Low, // Set notification importance
  );

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      createAwesomeNotification(notification.title!, notification.body!);
    }
  });

  // Background message handler (optional)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
