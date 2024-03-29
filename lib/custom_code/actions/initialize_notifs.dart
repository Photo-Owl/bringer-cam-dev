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

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> initializeNotifs() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    carPlay: true,
    criticalAlert: true,
    sound: true,
    announcement: true,
    provisional: true,
    badge: true,
  );
  if (FirebaseAuth.instance.currentUser != null) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'fcmToken': fcmToken});
    }
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _firebaseMessaging.getInitialMessage();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
