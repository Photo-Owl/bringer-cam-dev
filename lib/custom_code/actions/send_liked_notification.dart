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

Future sendLikedNotification(
    String key, String displayName, String userId) async {
  final db = FirebaseFirestore.instance;
  final uploadsSnapshot = await db
      .collection('uploads')
      .where("key", isEqualTo: key)
      .limit(1)
      .get();
  final owner_id = uploadsSnapshot.docs[0].data()["owner_id"];
  if (owner_id == userId) {
    return;
  }

  final ownerSnapshot = await db.collection("users").doc(owner_id).get();

  final token = ownerSnapshot.data()!['fcmToken'];

  final title = displayName + " has liked the photo you shared";
  const body = "Tap to see which photo they liked";

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
    // If the server returns an unexpected response, throw an exception.
    throw Exception('Failed to send notification');
  }
}
