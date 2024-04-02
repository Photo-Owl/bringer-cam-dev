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

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:android_download_manager/android_download_manager.dart';

Future<void> downloadImage(String url, String key) async {
  final [_, fileName] = key.split('/');
  if (defaultTargetPlatform != TargetPlatform.android) {
    await FileSaver.instance.saveFile(
      name: fileName,
      link: LinkDetails(link: url),
    );
    return;
  }

  AndroidDownloadManager.enqueue(
    downloadUrl: url,
    downloadPath: '/sdcard/Pictures/Bringer/',
    fileName: fileName,
  );
}
