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

import '/auth/firebase_auth/auth_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' show adjustColor, decodeImage, encodeJpg;
import 'package:path/path.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<Uint8List?> _processImage(String path) async {
  final imageBytes = await File(path).readAsBytes();
  final image = decodeImage(imageBytes);
  if (image == null) {
    debugPrint('Failed to decode image.');
    return null;
  }

  // Increase sharpness
  return encodeJpg(adjustColor(image, amount: 1));
}

Future saveFileToGallery(String path) async {
  debugPrint('Image captured and saved to $path');
  final image = await _processImage(path);
  if (image == null) {
    debugPrint('Failed to process image and save.');
    return;
  }

  final processedFile = await File(path).writeAsBytes(image);
  final fileName = basename(processedFile.path);
  var newPath = '';
  if (defaultTargetPlatform == TargetPlatform.android) {
    final mediaStore = MediaStore();
    MediaStore.appFolder = 'Bringer';
    final isFileSaved = await mediaStore.saveFile(
      tempFilePath: processedFile.path,
      dirType: DirType.photo,
      dirName: DirName.pictures,
    );
    if (isFileSaved) {
      // newPath = (await mediaStore.getFileUri(
      //   fileName: file.name,
      //   dirType: DirType.photo,
      //   dirName: DirName.pictures,
      // ))!
      //     .toString();

      newPath = '/sdcard/Pictures/Bringer/$fileName';
      await MediaScanner.loadMedia(path: newPath);
    }
  }

  if (newPath.isEmpty) {
    final path = '${await getExternalStorageDirectory()}/Pictures';
    await Directory(path).create(recursive: true);
    newPath = '$path/$fileName';
    await File(newPath).writeAsBytes(image);
  }

  print('Image captured and saved locally at $newPath');
  final unixTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  actions.insertImageToSqlite(newPath, currentUserUid, unixTimestamp);
}
