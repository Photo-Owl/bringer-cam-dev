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

Future<List<dynamic>> readAllImagesSqlite(String ownerId) async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'databasename.db'),
  );

  final db = await database;
  return await db.rawQuery(
      'SELECT * FROM Images WHERE owner = ? ORDER BY unix_timestamp DESC',
      [ownerId]);
}