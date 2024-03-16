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

import 'package:path/path.dart' show basename;
import 'package:media_store_plus/media_store_plus.dart';

Future deleteImage(String path) async {
  MediaStore.appFolder = 'Bringer';
  final mediaStore = MediaStore();
  await SQLiteManager.instance.deleteImage(path: path);
  await mediaStore.deleteFile(
    fileName: basename(path),
    dirType: DirType.photo,
    dirName: DirName.pictures,
  );
}
