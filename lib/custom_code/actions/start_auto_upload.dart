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

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import '/backend/firebase/firebase_config.dart';
import '/custom_code/actions/uploader.dart';
import 'package:workmanager/workmanager.dart';

// to run this function from native code
@pragma('vm:entry-point')
void taskDispatcher() {
  Workmanager().executeTask((task, _) async {
    await initFirebase();
    await SQLiteManager.initialize();
    return Future.value(true);
  });
}

Future startAutoUpload() async {
  Workmanager().initialize(
    taskDispatcher,
    isInDebugMode: kDebugMode,
  );
  Workmanager().registerPeriodicTask(
    'com.smoose.photoowldev.uploadTask',
    'com.smoose.photoowldev.uploadTask',
    frequency: const Duration(minutes: 15),
  );
  if (FirebaseAuth.instance.currentUser != null) {
    final uploader = Uploader();
    uploader.uploadImages();
  }
}
