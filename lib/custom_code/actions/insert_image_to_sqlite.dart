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

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future insertImageToSqlite(
  String? path,
  String? owner,
  int? timestamp,
) async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'camera_media.db'),
  );

  final Map<String, dynamic> row = {
    'path': path,
    'owner': owner,
    'unix_timestamp': timestamp,
    'is_uploaded': 0,
    'is_uploading': 0
  };

  final db = await database;
  await db.insert('Images', row);
  // Add your function code here!
}
