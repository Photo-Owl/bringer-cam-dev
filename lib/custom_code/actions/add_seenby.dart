// Automatic FlutterFlow imports

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

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kReleaseMode;

Future addSeenby(String userId, String key, String displayName) async {
  final db = FirebaseFirestore.instance;
  final uploadSnapshot = await db
      .collection("uploads")
      .where('key', isEqualTo: key)
      .limit(1)
      .get();
  List<dynamic> seenby = uploadSnapshot.docs[0].data()['seen_by'] ?? [];
  String ownerId = uploadSnapshot.docs[0].data()['owner_id'];

  final usersRef = "users/" + userId;

  if (!seenby.contains(usersRef)) {
    seenby.add(usersRef);
    if (ownerId != userId)
      await sendSeenNotification(key, displayName, ownerId);
    await uploadSnapshot.docs[0].reference.update({"seen_by": seenby});
  }
  return;
}

Future<void> sendSeenNotification(
    String key, String displayName, String ownerId) async {
  final db = FirebaseFirestore.instance;
  final title = displayName + " has seen the photo you shared";
  const body = "You’ve been a good friend using Social Gallery.";
  final ownerSnapshot = await db.collection("users").doc(ownerId).get();

  final token = ownerSnapshot.data()!['fcmToken'];
  final payload = {
    "notification": {"title": title, "body": body},
    "token": token
  };
  final payloadJson = jsonEncode({"payload": payload});

  final response = await http.post(
    Uri.parse(
        'https://us-central1-${kReleaseMode ? 'bringer-cam-dev' : 'social-gallery-dev'}.cloudfunctions.net/sendNotification'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: payloadJson,
  );
  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    print('Notification sent successfully');
  } else {
    print('Notification sending failed');
  }
  return;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
