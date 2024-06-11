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
import 'package:flutter/services.dart';
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
    try {
      await initFirebase();
      if (FirebaseAuth.instance.currentUser == null) return false;
      await SQLiteManager.initialize();
      final uploader = Uploader();
      await uploader.waitForUploads();
      return true;
    } catch (e) {
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
      return false;
    }
  });
}

Future startAutoUpload() async {
  Workmanager().initialize(
    taskDispatcher,
    isInDebugMode: false,
  );
  Workmanager().registerPeriodicTask(
    'com.smoose.photoowldev.uploadTask',
    'com.smoose.photoowldev.uploadTask',
    frequency: const Duration(minutes: 15),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
    ),
  );
  const autoUploadChannel = MethodChannel('com.smoose.photoowldev/autoUpload');
  autoUploadChannel.setMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == "upload_image") {
      WidgetsFlutterBinding.ensureInitialized();
      final appState = FFAppState();
      appState.update(() {
        appState.shouldReloadGallery = true;
      });
      Workmanager().registerOneOffTask(
        'com.smoose.photoowldev.immediateTask',
        'upload-img',
        existingWorkPolicy: ExistingWorkPolicy.append,
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
        ),
      );
    }
  });
}
