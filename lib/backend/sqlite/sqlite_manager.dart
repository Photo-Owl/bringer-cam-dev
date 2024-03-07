import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';
import 'queries/update.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'bringer_cam',
      'camera_media.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<FetchImagesToUploadRow>> fetchImagesToUpload({
    String? ownerId,
  }) =>
      performFetchImagesToUpload(
        _database,
        ownerId: ownerId,
      );

  Future<List<ReadUploadedImagesRow>> readUploadedImages({
    String? ownerId,
  }) =>
      performReadUploadedImages(
        _database,
        ownerId: ownerId,
      );

  Future<List<ReadImagesToUploadRow>> readImagesToUpload({
    String? ownerId,
  }) =>
      performReadImagesToUpload(
        _database,
        ownerId: ownerId,
      );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  Future insertImage({
    String? path,
    String? ownerId,
    int? unixTimestamp,
  }) =>
      performInsertImage(
        _database,
        path: path,
        ownerId: ownerId,
        unixTimestamp: unixTimestamp,
      );

  /// END UPDATE QUERY CALLS
}
