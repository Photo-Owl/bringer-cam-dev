// Automatic FlutterFlow imports
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:android_download_manager/android_download_manager.dart';

Future<void> downloadImage(String url, String key) async {
  print('Downloading image from: $url');
  final [_, fileName] = key.split('/');
  if (kIsWeb) {
    await FileSaver.instance.saveFile(
      name: fileName,
      link: LinkDetails(link: url),
    );
    return;
  }
  print(' is ios ${Platform.isIOS}');
  if (Platform.isIOS) {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    print('Downloading file from: $directory to: $filePath');
    // Download the file
    final response = await http.get(Uri.parse(url));
    print('statusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Save the file
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('File downloaded to: $filePath');
    } else {
      print('Failed to download file: ${response.statusCode}');
    }
    return;
  }
  if (Platform.isAndroid) {
    AndroidDownloadManager.enqueue(
      downloadUrl: url,
      downloadPath: '/sdcard/Pictures/Social Gallery/',
      fileName: fileName,
    );
  }
}
