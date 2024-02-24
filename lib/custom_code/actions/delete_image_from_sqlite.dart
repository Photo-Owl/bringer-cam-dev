// Automatic FlutterFlow imports
import 'dart:io';

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

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
onLongPress:
    Feedback.wrapForLongPress(() {
  deleteImageFromSqlite(
          currentUserUid,
          uploadedImageItem)
      .then((_) async {
    final uploadedImages =
        await actions
            .readAllImagesSqlite(
                currentUserUid);
    setState(() {
      _model.uploadedImages =
          uploadedImages;
    });
  });
  }, context),
*/

Future deleteImageFromSqlite(String userId, Object image) async {
  // Open the database
  final db = openDatabase(
    join(await getDatabasesPath(), 'camera_media.db'),
  );
  final database = await db;

  final imagePath = getJsonField(image, r'''$["path"]''');

  await database.delete(
    'Images',
    where: "path = ?",
    whereArgs: [imagePath],
  );

  final file = File(imagePath);

  if (await file.exists()) {
    await file.delete();
  }
}
